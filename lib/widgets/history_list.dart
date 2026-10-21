import 'package:flutter/material.dart';

import '../core/date_format.dart';
import '../core/theme.dart';
import '../l10n/app_localizations.dart';
import '../models/water_day_entry.dart';

class HistoryList extends StatelessWidget {
  const HistoryList({
    super.key,
    required this.entries,
    required this.dailyGoal,
  });

  final List<WaterDayEntry> entries;
  final int dailyGoal;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final today = DateTime.now();
    final visible = entries.take(14).toList();

    if (visible.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 32),
        alignment: Alignment.center,
        child: Column(
          children: [
            Icon(
              Icons.history_rounded,
              size: 40,
              color: Colors.white.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.noHistory,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.45)),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        for (var i = 0; i < visible.length; i++) ...[
          if (i > 0) const SizedBox(height: 10),
          _HistoryTile(
            entry: visible[i],
            dailyGoal: dailyGoal,
            today: today,
          ),
        ],
      ],
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({
    required this.entry,
    required this.dailyGoal,
    required this.today,
  });

  final WaterDayEntry entry;
  final int dailyGoal;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final date = DateTime.parse(entry.dateKey);
    final fraction = (entry.progressMl / dailyGoal).clamp(0.0, 1.0);
    final done = entry.progressMl >= dailyGoal;
    final color =
        AppTheme.progressColor(entry.progressMl.toDouble(), dailyGoal);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  formatRelativeDay(date, today, l10n),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
              if (entry.kreatyna)
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF43A047).withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF66BB6A).withValues(alpha: 0.6),
                    ),
                  ),
                  child: Text(
                    l10n.creatine,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                      color: Color(0xFFA5D6A7),
                    ),
                  ),
                ),
              if (done)
                Icon(
                  Icons.check_circle_rounded,
                  size: 18,
                  color: color,
                ),
              const SizedBox(width: 8),
              Text(
                '${entry.progressMl} ml',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: fraction,
              minHeight: 6,
              backgroundColor: Colors.white.withValues(alpha: 0.08),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }
}
