import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../l10n/app_localizations.dart';
import '../models/day_modifiers.dart';

class DayTagsRow extends StatelessWidget {
  const DayTagsRow({
    super.key,
    required this.modifiers,
    required this.onChanged,
  });

  final DayModifiers modifiers;
  final ValueChanged<DayModifiers> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.todayTags,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.todayTagsHint,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.4),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _TagChip(
              label: l10n.tagHot,
              icon: Icons.wb_sunny_rounded,
              selected: modifiers.hot,
              onTap: () =>
                  onChanged(modifiers.copyWith(hot: !modifiers.hot)),
            ),
            _TagChip(
              label: l10n.tagTraining,
              icon: Icons.fitness_center_rounded,
              selected: modifiers.training,
              onTap: () => onChanged(
                modifiers.copyWith(training: !modifiers.training),
              ),
            ),
            _TagChip(
              label: l10n.tagRoughMorning,
              icon: Icons.nightlife_rounded,
              selected: modifiers.roughMorning,
              onTap: () => onChanged(
                modifiers.copyWith(roughMorning: !modifiers.roughMorning),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            color: selected
                ? AppTheme.primary.withValues(alpha: 0.28)
                : Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? AppTheme.primary.withValues(alpha: 0.7)
                  : Colors.white.withValues(alpha: 0.12),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: selected ? AppTheme.primary : Colors.white70,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: selected ? Colors.white : Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
