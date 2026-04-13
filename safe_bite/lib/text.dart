import 'package:flutter/material.dart';

TextStyle glowingText(double size, {FontWeight weight = FontWeight.w600}) {
  return TextStyle(
    fontSize: size,
    fontWeight: weight,
    color: Colors.white,
    shadows: [
      Shadow(color: Colors.white.withOpacity(0.75), blurRadius: 14),
      Shadow(color: const Color(0xFFA855F7).withOpacity(0.50), blurRadius: 32),
    ],
  );
}

TextStyle mutedGlowText(double size, {FontWeight weight = FontWeight.w400}) {
  return TextStyle(
    fontSize: size,
    fontWeight: weight,
    color: Colors.white.withOpacity(0.75),
    shadows: [Shadow(color: Colors.white.withOpacity(0.30), blurRadius: 8)],
  );
}
