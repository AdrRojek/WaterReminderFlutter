import 'package:flutter/material.dart';

class StreakBadge extends StatelessWidget {
  const StreakBadge({super.key, required this.streak});

  final int streak;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            streak > 3 ? Icons.local_fire_department : Icons.whatshot_outlined,
            color: Colors.orangeAccent,
            size: 20,
          ),
          const SizedBox(width: 6),
          Text(
            '$streak dni',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.orangeAccent,
            ),
          ),
        ],
      ),
    );
  }
}
