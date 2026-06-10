import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../core/theme.dart';
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
    if (entries.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: Text('Brak historii')),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: entries.length.clamp(0, 14),
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final entry = entries[index];
        final date = DateTime.parse(entry.dateKey);
        final color = AppTheme.progressColor(
          entry.progressMl.toDouble(),
          dailyGoal,
        );

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  DateFormat('d MMM yyyy', 'pl_PL').format(date),
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
              if (entry.kreatyna)
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    'K',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ),
              Text(
                '${entry.progressMl} ml',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
