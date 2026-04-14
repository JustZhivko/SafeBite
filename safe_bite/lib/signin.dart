import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'background.dart';
import 'glass_container.dart';
import 'gradient_button.dart';

class SignInPage extends StatefulWidget {
  final void Function(Map<String, dynamic> user) onLoginSuccess;

  const SignInPage({super.key, required this.onLoginSuccess});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool _loading = false;
  String? _error;

  static const String _authBaseUrl = 'http://localhost:5000';
  static const String _captureBaseUrl = 'http://localhost:5001';

  Future<void> _login() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final response = await http.post(
        Uri.parse('$_authBaseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email.text.trim(),
          'password': password.text,
        }),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final user = data['user'] as Map<String, dynamic>;

        // if the user is active, it's known by main.py
        await _setActiveUser(user['id'] as int);

        widget.onLoginSuccess(user);
      } else {
        setState(() {
          _error = data['error'] as String? ?? 'Login failed.';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Cannot connect to server. Check your connection.';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _setActiveUser(int userId) async {
    try {
      await http.post(
        Uri.parse('$_captureBaseUrl/set-active-user'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId}),
      );
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: GlassContainer(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Sign In",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: "Email"),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: password,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Password"),
                ),

                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.withOpacity(0.4)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.redAccent,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _error!,
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                _loading
                    ? const CircularProgressIndicator(color: Color(0xFFA855F7))
                    : GradientButton(text: "Login", onTap: _login),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
