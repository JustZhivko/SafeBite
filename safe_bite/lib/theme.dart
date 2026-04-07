import 'package:flutter/material.dart';

class AppTheme {
  // Accent colors
  static const accent = Color(0xFFA855F7);
  static const accent2 = Color(0xFF3B82F6);
  static const accent3 = Color(0xFF22D3EE);

  // Background
  static const bg0 = Color(0xFF070A14);
  static const bg1 = Color(0xFF0B1220);

  // Text
  static const text = Color.fromRGBO(255, 255, 255, 0.88);
  static const muted = Color.fromRGBO(255, 255, 255, 0.65);

  // Surfaces
  static const border = Color.fromRGBO(255, 255, 255, 0.10);
  static const surface = Color.fromRGBO(5, 8, 20, 0.55);
  static const surface2 = Color.fromRGBO(5, 8, 20, 0.72);

  static const placeholder = Color.fromRGBO(255, 255, 255, 0.45);

  static const radius = 18.0;

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.transparent,
    fontFamily: "Roboto",
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: text),
      bodySmall: TextStyle(color: muted),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        borderSide: BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        borderSide: BorderSide(color: accent),
      ),
      labelStyle: TextStyle(color: muted),
      hintStyle: TextStyle(color: placeholder),
    ),
  );
}
