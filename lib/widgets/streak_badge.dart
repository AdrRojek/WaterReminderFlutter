import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/streak_info.dart';

class StreakBadge extends StatelessWidget {
  const StreakBadge({
    super.key,
    required this.info,
    this.onUseAmnesty,
  });

  final StreakInfo info;
  final VoidCallback? onUseAmnesty;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hot = info.streak > 3;
    final label = info.streak == 1
        ? l10n.streakOne(info.streak)
        : l10n.streakMany(info.streak);

    return Column(
      children: [
        Container(
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
                hot
                    ? Icons.local_fire_department_rounded
                    : Icons.whatshot_outlined,
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
              if (info.amnestyUsedThisMonth) ...[
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    l10n.amnestyUsedBadge,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (info.amnestyAvailable && onUseAmnesty != null) ...[
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: onUseAmnesty,
            icon: const Icon(Icons.shield_moon_rounded, size: 16),
            label: Text(l10n.useAmnesty),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFFFD54F),
              visualDensity: VisualDensity.compact,
            ),
          ),
        ] else if (!info.amnestyUsedThisMonth) ...[
          const SizedBox(height: 6),
          Text(
            l10n.amnestyHint,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.35),
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
