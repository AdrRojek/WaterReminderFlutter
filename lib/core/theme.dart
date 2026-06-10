import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const _primary = Color(0xFF4FC3F7);
  static const _secondary = Color(0xFF0288D1);
  static const _surface = Color(0xFF0D1B2A);
  static const _card = Color(0xFF1B2838);

  static ThemeData get dark {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: _primary,
        secondary: _secondary,
        surface: _surface,
        onPrimary: Colors.white,
        onSurface: Colors.white,
      ),
      scaffoldBackgroundColor: _surface,
      cardColor: _card,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _secondary,
        foregroundColor: Colors.white,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    return base.copyWith(
      textTheme: GoogleFonts.outfitTextTheme(base.textTheme),
    );
  }

  static LinearGradient get waterGradient => const LinearGradient(
        colors: [_primary, _secondary],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

  static Color progressColor(double progress, int goal) {
    if (progress >= goal) return Colors.greenAccent;
    if (progress >= goal * 0.5) return Colors.amber;
    return Colors.redAccent;
  }

  static Color recommendedColor(int recommended, int current) {
    final diff = recommended - current;
    if (diff > 1000) return Colors.redAccent;
    if (diff > 0) return Colors.amber;
    return Colors.greenAccent;
  }
}
