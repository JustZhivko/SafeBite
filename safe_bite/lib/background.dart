import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color.fromARGB(255, 7, 38, 104),
            Color.fromARGB(255, 0, 0, 0),
            Color.fromARGB(255, 36, 4, 88),
          ],
        ),
      ),
      child: child,
    );
  }
}
