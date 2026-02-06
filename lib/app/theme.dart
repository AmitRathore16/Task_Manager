import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // 🎨 Core Colors
  static const Color backgroundDark = Color(0xFF212832);
  static const Color accentGold = Color(0xFFBC9434);
  static const Color textLight = Colors.white;
  static const Color textMuted = Color(0xFFE0E0E0);

  // 🔤 Typography
  static final TextTheme textTheme = GoogleFonts.poppinsTextTheme().copyWith(
    headlineLarge: const TextStyle(
      fontSize: 42,
      fontWeight: FontWeight.w700,
      height: 1.2,
      color: textLight,
    ),
    headlineMedium: const TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      height: 1.3,
      color: textLight,
    ),
    titleLarge: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: textLight,
    ),
    bodyLarge: const TextStyle(
      fontSize: 16,
      color: textMuted,
    ),
    labelLarge: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
  );

  static ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: backgroundDark,
    textTheme: textTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentGold,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        textStyle: textTheme.labelLarge,
      ),
    ),
  );
}
