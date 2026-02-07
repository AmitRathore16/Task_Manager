import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // 🎨 Color Palette
  static const Color primaryGold = Color(0xFFBC9434);
  static const Color secondaryGold = Color(0xFFFED36A);
  static const Color darkBackground = Color(0xFF263238);
  static const Color inputFieldBg = Color(0xFF455A64);
  static const Color inputFieldBgDark = Color(0xFF3A3E47);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textLightGray = Color(0xFFE0E0E0);
  static const Color textMutedGray = Color(0xFF999999);
  static const Color dividerColor = Color(0xFF3A3E47);
  static const Color lightBg2 = Color(0xFFFAFAFA);
  static const Color lightBg3 = Color(0xFFEBEBEB);
  static const Color lightBg4 = Color(0xFFE0E0E0);
  static const Color pureBlack = Color(0xFF000000);

  static TextTheme _buildTextTheme(ColorScheme colorScheme) {
    final baseTextTheme = GoogleFonts.interTextTheme();
    return baseTextTheme.copyWith(
      // Large heading for "Manage your Task with DayTask" - Uses Pilat Demi 61px
      headlineLarge: const TextStyle(
        fontFamily: 'Pilat',
        fontSize: 61,
        fontWeight: FontWeight.w500, // Demi weight
        height: 1.0,
        color: textWhite,
        letterSpacing: 0,
      ),
      // Medium heading for "Welcome Back!" and "Create your account" - Inter 28px
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: colorScheme.brightness == Brightness.dark ? textWhite : pureBlack,
      ),
      // Title for "DayTask" logo text - Inter 20px
      titleLarge: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: colorScheme.brightness == Brightness.dark ? textWhite : pureBlack,
      ),
      // Button text - Inter Semi Bold 18px
      labelLarge: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600, // Semi Bold
        height: 1.2,
        color: colorScheme.brightness == Brightness.dark ? pureBlack : textWhite,
      ),
      // Body large text - Inter 16px
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: colorScheme.brightness == Brightness.dark ? textLightGray : const Color(0xFF333333),
      ),
      // Body medium text - Inter 14px
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: colorScheme.brightness == Brightness.dark ? textMutedGray : const Color(0xFF666666),
      ),
      // Small text for labels - Inter 12px
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: colorScheme.brightness == Brightness.dark ? textMutedGray : const Color(0xFF999999),
      ),
    );
  }

  // 🌙 Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: primaryGold,
      secondary: secondaryGold,
      surface: darkBackground,
      background: darkBackground,
      onPrimary: pureBlack,
      onSecondary: pureBlack,
      onSurface: textWhite,
      onBackground: textWhite,
    ),
    scaffoldBackgroundColor: darkBackground,
    textTheme: _buildTextTheme(const ColorScheme.dark()),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: inputFieldBg,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryGold, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textLightGray,
      ),
      hintStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textMutedGray,
      ),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: secondaryGold,
        foregroundColor: pureBlack,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        elevation: 0,
      ),
    ),

    // Outlined Button Theme (for Google sign-in)
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: textWhite,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: const BorderSide(color: textLightGray, width: 1),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: textLightGray,
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),

    // Checkbox Theme
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return secondaryGold;
        }
        return Colors.transparent;
      }),
      checkColor: MaterialStateProperty.all(pureBlack),
      side: const BorderSide(color: textMutedGray, width: 1.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),
  );

  // ☀️ Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: primaryGold,
      secondary: secondaryGold,
      surface: textWhite,
      background: lightBg2,
      onPrimary: textWhite,
      onSecondary: pureBlack,
      onSurface: pureBlack,
      onBackground: pureBlack,
    ),
    scaffoldBackgroundColor: textWhite,
    textTheme: _buildTextTheme(const ColorScheme.light()),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: lightBg3,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryGold, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF666666),
      ),
      hintStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textMutedGray,
      ),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: secondaryGold,
        foregroundColor: pureBlack,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        elevation: 0,
      ),
    ),

    // Outlined Button Theme (for Google sign-in)
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: pureBlack,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: const BorderSide(color: Color(0xFFCCCCCC), width: 1),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF666666),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),

    // Checkbox Theme
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return secondaryGold;
        }
        return Colors.transparent;
      }),
      checkColor: MaterialStateProperty.all(pureBlack),
      side: const BorderSide(color: Color(0xFFCCCCCC), width: 1.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),
  );
}
