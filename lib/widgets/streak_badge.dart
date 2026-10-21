import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

class StreakBadge extends StatelessWidget {
  const StreakBadge({super.key, required this.streak});

  final int streak;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hot = streak > 3;
    final label =
        streak == 1 ? l10n.streakOne(streak) : l10n.streakMany(streak);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: hot
              ? [const Color(0xFFFF6D00), const Color(0xFFFF9100)]
              : [
                  Colors.white.withValues(alpha: 0.08),
                  Colors.white.withValues(alpha: 0.04),
                ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: hot
              ? Colors.orange.withValues(alpha: 0.5)
              : Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            hot ? Icons.local_fire_department_rounded : Icons.whatshot_outlined,
            color: hot ? Colors.white : Colors.orangeAccent,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: hot ? Colors.white : Colors.orangeAccent,
            ),
          ),
        ],
      ),
    );
  }
}
