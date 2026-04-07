import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Sign In", style: TextStyle(fontSize: 28)),
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

          SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              // TODO: Add login logic
            },
            child: Text("Login"),
          ),
        ],
      ),
    );
  }
}
