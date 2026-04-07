import 'package:flutter/material.dart';

TextStyle glowingText(double size, {FontWeight weight = FontWeight.w600}) {
  return TextStyle(
    fontSize: size,
    fontWeight: weight,
    color: Colors.white,
    shadows: [Shadow(color: Colors.white.withOpacity(0.6), blurRadius: 12)],
  );
}
