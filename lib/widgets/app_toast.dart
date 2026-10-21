import 'package:flutter/material.dart';

import '../core/theme.dart';

enum AppToastTone { success, info, warning, error }

/// Floating glass-style toast (replaces plain SnackBars).
class AppToast {
  AppToast._();

  static void show(
    BuildContext context,
    String message, {
    AppToastTone tone = AppToastTone.info,
    IconData? icon,
    Duration duration = const Duration(milliseconds: 2600),
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();

    final colors = _toneColors(tone);
    final resolvedIcon = icon ?? _toneIcon(tone);

    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        duration: duration,
        content: _ToastCard(
          message: message,
          icon: resolvedIcon,
          accent: colors.$1,
          glow: colors.$2,
        ),
      ),
    );
  }

  static (Color, Color) _toneColors(AppToastTone tone) {
    switch (tone) {
      case AppToastTone.success:
        return (const Color(0xFF66BB6A), const Color(0xFF43A047));
      case AppToastTone.warning:
        return (const Color(0xFFFFD54F), const Color(0xFFFFA000));
      case AppToastTone.error:
        return (const Color(0xFFEF5350), const Color(0xFFE53935));
      case AppToastTone.info:
        return (AppTheme.primary, AppTheme.secondary);
    }
  }

  static IconData _toneIcon(AppToastTone tone) {
    switch (tone) {
      case AppToastTone.success:
        return Icons.check_circle_rounded;
      case AppToastTone.warning:
        return Icons.info_rounded;
      case AppToastTone.error:
        return Icons.error_rounded;
      case AppToastTone.info:
        return Icons.water_drop_rounded;
    }
  }
}

class _ToastCard extends StatelessWidget {
  const _ToastCard({
    required this.message,
    required this.icon,
    required this.accent,
    required this.glow,
  });

  final String message;
  final IconData icon;
  final Color accent;
  final Color glow;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1A2D44).withValues(alpha: 0.98),
            const Color(0xFF132337).withValues(alpha: 0.98),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withValues(alpha: 0.45)),
        boxShadow: [
          BoxShadow(
            color: glow.withValues(alpha: 0.28),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [accent, glow],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
