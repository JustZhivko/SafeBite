import 'package:flutter/material.dart';

class AppTheme {
  // Accent colors
  static const accent = Color(0xFFA855F7);
  static const accent2 = Color(0xFF3B82F6);
  static const accent3 = Color(0xFF22D3EE);

  // Background
  static const bg0 = Color(0xFF04060F);
  static const bg1 = Color(0xFF060818);

  // Text
  static const text = Color.fromRGBO(255, 255, 255, 0.95);
  static const muted = Color.fromRGBO(255, 255, 255, 0.65);

  // Surfaces
  static const border = Color.fromRGBO(255, 255, 255, 0.12);
  static const surface = Color.fromRGBO(5, 8, 20, 0.55);
  static const surface2 = Color.fromRGBO(5, 8, 20, 0.72);

  static const placeholder = Color.fromRGBO(255, 255, 255, 0.40);

  static const radius = 18.0;

  // Shared glow shadows for text
  static List<Shadow> get textGlow => [
    Shadow(color: Colors.white.withOpacity(0.70), blurRadius: 12),
    Shadow(color: accent.withOpacity(0.45), blurRadius: 28),
  ];

  static List<Shadow> get subtleGlow => [
    Shadow(color: Colors.white.withOpacity(0.30), blurRadius: 8),
  ];

  // Dark theme
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.transparent,
    fontFamily: "Roboto",

    textTheme: TextTheme(
      headlineLarge: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 32,
        shadows: textGlow,
      ),
      headlineMedium: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 28,
        shadows: textGlow,
      ),
      headlineSmall: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 22,
        shadows: textGlow,
      ),
      titleLarge: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 18,
        shadows: textGlow,
      ),
      titleMedium: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontSize: 16,
        shadows: subtleGlow,
      ),

      bodyLarge: TextStyle(
        color: Colors.white.withOpacity(0.92),
        fontSize: 16,
        shadows: subtleGlow,
      ),
      bodyMedium: TextStyle(
        color: Colors.white.withOpacity(0.88),
        fontSize: 25,
        shadows: subtleGlow,
      ),
      bodySmall: TextStyle(
        color: Colors.white.withOpacity(0.65),
        fontSize: 20,
        shadows: subtleGlow,
      ),

      labelLarge: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 14,
        shadows: subtleGlow,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        borderSide: BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        borderSide: BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        borderSide: BorderSide(color: accent, width: 1.5),
      ),
      labelStyle: TextStyle(color: muted),
      hintStyle: TextStyle(color: placeholder),
    ),
  );
}
