import 'package:flutter/material.dart';
import 'background.dart';
import 'glass_container.dart';
import 'gradient_button.dart';

class SignUpPage extends StatelessWidget {
  final email = TextEditingController();
  final pass = TextEditingController();
  final confirm = TextEditingController();

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
                  "Create Account",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: email,
                  decoration: const InputDecoration(labelText: "Email"),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: pass,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Password"),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: confirm,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Confirm Password",
                  ),
                ),

                const SizedBox(height: 20),

                GradientButton(text: "Sign Up", onTap: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
