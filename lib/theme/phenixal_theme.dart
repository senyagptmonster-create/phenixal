import 'package:flutter/material.dart';

class PhenixalTheme {
  static const Color forestDark = Color(0xFF14241B);
  static const Color alpineCard = Color(0xFF1E3528);
  static const Color trailEmerald = Color(0xFF52B788);
  static const Color peakAmber = Color(0xFFFFB703);

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        fontFamily: 'AppFont',
        brightness: Brightness.dark,
        scaffoldBackgroundColor: forestDark,
        colorScheme: const ColorScheme.dark(
          primary: trailEmerald,
          secondary: peakAmber,
          surface: alpineCard,
        ),
      );
}
