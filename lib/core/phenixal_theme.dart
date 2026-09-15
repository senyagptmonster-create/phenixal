import 'package:flutter/material.dart';

class PhenixalTheme {
  // Outdoor trail forest green and terra orange palette
  static const Color forestPrimary = Color(0xFF1E4D2B);
  static const Color forestDeep = Color(0xFF112E1B);
  static const Color terraOrange = Color(0xFFD96B43);
  static const Color terraWarm = Color(0xFFE7825A);
  static const Color earthSand = Color(0xFFF7F5EE);
  static const Color sageAccent = Color(0xFF6B9080);
  static const Color pineCard = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF1F2923);
  static const Color textMuted = Color(0xFF637367);
  static const Color surfaceBorder = Color(0xFFE2E7E1);

  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: earthSand,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: forestPrimary,
        onPrimary: Colors.white,
        secondary: terraOrange,
        onSecondary: Colors.white,
        surface: pineCard,
        onSurface: textDark,
        error: Color(0xFFBA1A1A),
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: earthSand,
        foregroundColor: textDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: textDark,
          letterSpacing: -0.3,
        ),
      ),
      cardTheme: CardThemeData(
        color: pineCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: surfaceBorder, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: forestPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: surfaceBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: surfaceBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: forestPrimary, width: 1.8),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: forestPrimary,
        unselectedItemColor: textMuted,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
