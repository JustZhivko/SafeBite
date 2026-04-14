import os
import sqlite3
from datetime import datetime

from flask import Flask, jsonify, request, session
from flask_cors import CORS
from werkzeug.security import check_password_hash, generate_password_hash


def get_db_path() -> str:
    return os.environ.get(
        "DATABASE_URL",
        os.path.join(os.path.dirname(__file__), "app.db"),
    )


def create_app() -> Flask:
    app = Flask(__name__)

    app.secret_key = os.environ.get("FLASK_SECRET_KEY", "dev-secret-change-me")
    app.config.update(
        SESSION_COOKIE_HTTPONLY=True,
        SESSION_COOKIE_SAMESITE="Lax",
        SESSION_COOKIE_SECURE=False,
    )

    CORS(app, supports_credentials=True)

    @app.get("/health")
    def health() -> tuple[object, int]:
        return jsonify({"ok": True}), 200

    def get_conn() -> sqlite3.Connection:
        conn = sqlite3.connect(get_db_path())
        conn.row_factory = sqlite3.Row
        return conn

    def init_db() -> None:
        conn = get_conn()
        try:
            conn.execute(
                """
                CREATE TABLE IF NOT EXISTS users (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    email TEXT NOT NULL UNIQUE,
                    name TEXT,
                    password_hash TEXT NOT NULL,
                    created_at TEXT NOT NULL
                )
                """
            )
            conn.execute(
                """
                CREATE TABLE IF NOT EXISTS food_captures (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    filename TEXT NOT NULL,
                    response_text TEXT NOT NULL,
                    created_at TEXT NOT NULL
                )
                """
            )
            conn.commit()

            try:
                conn.execute(
                    "ALTER TABLE food_captures ADD COLUMN user_id INTEGER REFERENCES users(id)"
                )
                conn.commit()
            except Exception:
                pass

        finally:
            conn.close()

    init_db()

    def current_user():
        user_id = session.get("user_id")
        if not user_id:
            return None

        conn = get_conn()
        try:
            row = conn.execute(
                "SELECT id, email, name, created_at FROM users WHERE id = ?",
                (user_id,),
            ).fetchone()
            if row is None:
                return None
            return {
                "id": row["id"],
                "email": row["email"],
                "name": row["name"],
                "created_at": row["created_at"],
            }
        finally:
            conn.close()

    @app.post("/api/auth/signup")
    def signup():
        payload = request.get_json(silent=True) or {}
        email = (payload.get("email") or "").strip().lower()
        name = (payload.get("name") or "").strip()
        password = payload.get("password") or ""

        if not email or "@" not in email:
            return jsonify({"error": "Valid email is required."}), 400
        if not name:
            return jsonify({"error": "Name is required."}), 400
        if len(password) < 8:
            return jsonify({"error": "Password must be at least 8 characters."}), 400

        conn = get_conn()
        try:
            existing = conn.execute(
                "SELECT id FROM users WHERE email = ?",
                (email,),
            ).fetchone()
            if existing is not None:
                return jsonify({"error": "Email already exists."}), 409

            password_hash = generate_password_hash(password)
            conn.execute(
                """
                INSERT INTO users (email, name, password_hash, created_at)
                VALUES (?, ?, ?, ?)
                """,
                (email, name, password_hash, datetime.utcnow().isoformat()),
            )
            conn.commit()

            user = conn.execute(
                "SELECT id, email, name, created_at FROM users WHERE email = ?",
                (email,),
            ).fetchone()

            session["user_id"] = user["id"]
            return jsonify({
                "user": {
                    "id": user["id"],
                    "email": user["email"],
                    "name": user["name"],
                    "created_at": user["created_at"],
                }
            }), 201
        finally:
            conn.close()

    @app.post("/api/auth/login")
    def login():
        payload = request.get_json(silent=True) or {}
        email = (payload.get("email") or "").strip().lower()
        password = payload.get("password") or ""

        if not email or "@" not in email:
            return jsonify({"error": "Valid email is required."}), 400
        if not password:
            return jsonify({"error": "Password is required."}), 400

        conn = get_conn()
        try:
            user = conn.execute(
                "SELECT id, email, name, password_hash, created_at FROM users WHERE email = ?",
                (email,),
            ).fetchone()

            if user is None or not check_password_hash(user["password_hash"], password):
                return jsonify({"error": "Invalid email or password."}), 401

            session["user_id"] = user["id"]
            return jsonify({
                "user": {
                    "id": user["id"],
                    "email": user["email"],
                    "name": user["name"],
                    "created_at": user["created_at"],
                }
            }), 200
        finally:
            conn.close()

    @app.post("/api/auth/logout")
    def logout():
        session.pop("user_id", None)
        return jsonify({"ok": True}), 200

    @app.get("/api/auth/me")
    def me():
        user = current_user()
        return jsonify({"user": user}), 200

    @app.get("/api/captures")
    def list_captures():
        
        raw = request.args.get("user_id")
        if raw is not None:
            try:
                user_id = int(raw)
            except ValueError:
                return jsonify({"error": "Invalid user_id."}), 400
        else:
            user = current_user()
            if user is None:
                return jsonify({"error": "Unauthorized."}), 401
            user_id = user["id"]

        conn = get_conn()
        try:
            rows = conn.execute(
                """
                SELECT id, filename, response_text, created_at
                FROM food_captures
                WHERE user_id = ?
                ORDER BY datetime(created_at) DESC
                """,
                (user_id,),
            ).fetchall()
            base_url = os.environ.get("UPLOADS_BASE_URL", "http://localhost:5001/uploads")
            captures = [
                {**dict(r), "image_url": f"{base_url}/{r['filename']}"}
                for r in rows
            ]
            return jsonify({"captures": captures}), 200
        finally:
            conn.close()

    return app


app = create_app()


if __name__ == "__main__":
    port = int(os.environ.get("PORT", "5000"))
    app.run(host="0.0.0.0", port=port, debug=True)