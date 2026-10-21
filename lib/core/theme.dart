import 'package:flutter/material.dart';

class AppTheme {
  static const primary = Color(0xFF5DD4F5);
  static const secondary = Color(0xFF2196F3);
  static const accent = Color(0xFF7C4DFF);
  static const surface = Color(0xFF0A1628);
  static const surfaceLight = Color(0xFF132337);
  static const card = Color(0xFF1A2D44);

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        tertiary: accent,
        surface: surface,
        onPrimary: Colors.white,
        onSurface: Colors.white,
      ),
      scaffoldBackgroundColor: surface,
      cardColor: card,
      dividerColor: Colors.white12,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  static BoxDecoration get backgroundDecoration => backgroundFor(deepOcean: false);

  static BoxDecoration backgroundFor({
    bool deepOcean = false,
    bool aurora = false,
  }) {
    final colors = deepOcean
        ? const [
            Color(0xFF030B16),
            Color(0xFF061526),
            Color(0xFF0A1A2E),
          ]
        : aurora
            ? const [
                Color(0xFF0A1628),
                Color(0xFF12324A),
                Color(0xFF1A2540),
              ]
            : const [
                Color(0xFF0A1628),
                Color(0xFF0F2847),
                Color(0xFF0A1E35),
              ];
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: colors,
      ),
    );
  }

  static LinearGradient get waterGradient => const LinearGradient(
        colors: [primary, secondary],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient progressGradient(double progress, int goal) {
    final color = progressColor(progress, goal);
    return LinearGradient(
      colors: [color.withValues(alpha: 0.6), color],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );
  }

  static Color progressColor(double progress, int goal) {
    if (progress >= goal) return const Color(0xFF69F0AE);
    if (progress >= goal * 0.5) return const Color(0xFFFFD54F);
    return const Color(0xFFFF8A80);
  }

  static Color recommendedColor(int recommended, int current) {
    final diff = recommended - current;
    if (diff > 1000) return const Color(0xFFFF8A80);
    if (diff > 0) return const Color(0xFFFFD54F);
    return const Color(0xFF69F0AE);
  }
}
