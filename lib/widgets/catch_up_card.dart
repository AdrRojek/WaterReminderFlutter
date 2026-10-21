import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../l10n/app_localizations.dart';
import '../services/schedule_calculator.dart';

class CatchUpCard extends StatelessWidget {
  const CatchUpCard({
    super.key,
    required this.plan,
    required this.portionMl,
    required this.onApply,
  });

  final CatchUpPlan plan;
  final int portionMl;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFFF8A80).withValues(alpha: 0.22),
            const Color(0xFFFFD54F).withValues(alpha: 0.12),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFFF8A80).withValues(alpha: 0.45),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFF8A80).withValues(alpha: 0.9),
                ),
                child: const Icon(
                  Icons.speed_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.debtTitle(plan.debtMl),
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.debtSubtitle(
                        plan.portions,
                        portionMl,
                        plan.intervalMinutes,
                      ),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: onApply,
            icon: const Icon(Icons.schedule_rounded, size: 18),
            label: Text(l10n.debtAction),
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.primary.withValues(alpha: 0.95),
              foregroundColor: Colors.white,
              minimumSize: const Size(0, 44),
            ),
          ),
        ],
      ),
    );
  }
}
