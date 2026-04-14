import sqlite3
import time
import os
from datetime import datetime, timezone

from dotenv import load_dotenv
from flask import Flask, request, send_from_directory, jsonify, send_file
from google import genai


def configure():
    load_dotenv()


configure()

app = Flask(__name__)

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
UPLOAD_DIR = os.path.join(BASE_DIR, "uploads")
os.makedirs(UPLOAD_DIR, exist_ok=True)

client = genai.Client(api_key=os.getenv("GEMINI_API_KEY"))

TTS_ENABLED = os.environ.get("TTS_ENABLED", "false").lower() == "true"

if TTS_ENABLED:
    from tts import tts


def get_db_path() -> str:
    raw = os.environ.get("DATABASE_URL", "").strip()
    if raw.startswith("sqlite:///"):
        return raw.replace("sqlite:///", "", 1)
    if raw:
        return raw
    return os.path.join(BASE_DIR, "..", "database", "app.db")


def save_capture_record(filename: str, response_text: str, user_id: int | None = None) -> None:
    path = os.path.abspath(get_db_path())
    conn = sqlite3.connect(path)
    try:
        conn.execute(
            """
            INSERT INTO food_captures (filename, response_text, created_at, user_id)
            VALUES (?, ?, ?, ?)
            """,
            (filename, response_text, datetime.now(timezone.utc).isoformat(), user_id),
        )
        conn.commit()
    finally:
        conn.close()


@app.route("/uploads/<path:name>")
def serve_upload(name: str):
    return send_from_directory(UPLOAD_DIR, name)


@app.route("/message", methods=["GET", "POST"])
def receive_message():
    if request.method == "POST":
        image_data = request.data

        filename = f"image{int(time.time())}.jpg"
        file_path = os.path.join(UPLOAD_DIR, filename)

        with open(file_path, "wb") as f:
            f.write(image_data)

        uploaded_file = client.files.upload(file=file_path)
        prompt = """Purpose:
            - Analyze the food in the picture
            - You are an assistant for blind people
            - You need to check if the food is eatable and safe to consume
            - The output should also tell the user what is the food type
            Requirements:
            - The output will be converted as voice using TTS
            - The output should not be longer than 3 sentences
            - The output should always be in Bulgarian language
            - You are allowed to say that you cannot analyse the food"""

        response = client.models.generate_content(
            model="gemini-3-flash-preview",
            contents=[uploaded_file, prompt]
        )

        text_response = response.text.strip()
        print(text_response)

        user_id = None
        raw_user_id = request.args.get("user_id")
        if raw_user_id is not None:
            try:
                user_id = int(raw_user_id)
            except ValueError:
                user_id = None

        save_capture_record(filename, text_response, user_id)

        if TTS_ENABLED:
            tts(str(text_response))

        return jsonify({
            "status": "success",
            "text": text_response
        }), 200

    else:
        return jsonify({
            "status": "running"
        }), 200


@app.route("/audio.wav")
def send_audio():
    return send_file("audio.wav", mimetype="audio/wav")


if __name__ == "__main__":
    port = int(os.environ.get("PORT", "5001"))
    app.run(host="0.0.0.0", port=port, debug=True)