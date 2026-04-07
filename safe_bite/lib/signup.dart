import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Sign Up", style: TextStyle(fontSize: 28)),
          SizedBox(height: 20),

          TextField(
            controller: emailController,
            decoration: InputDecoration(labelText: "Email"),
          ),

          TextField(
            controller: passwordController,
            decoration: InputDecoration(labelText: "Password"),
            obscureText: true,
          ),

          TextField(
            controller: confirmController,
            decoration: InputDecoration(labelText: "Confirm Password"),
            obscureText: true,
          ),

          SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              // TODO: Add signup logic
            },
            child: Text("Create Account"),
          ),
        ],
      ),
    );
  }
}
