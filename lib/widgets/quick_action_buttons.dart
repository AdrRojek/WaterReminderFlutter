import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import 'hold_action_tile.dart';

class QuickActionButtons extends StatelessWidget {
  const QuickActionButtons({
    super.key,
    required this.onAdd250,
    required this.onAdd500,
    required this.onBoiler250,
    required this.boilerAmount,
    required this.onRefillBoiler,
    required this.portionMl,
    required this.creatineActive,
    required this.onCreatine,
    this.requireHold = false,
  });

  final VoidCallback onAdd250;
  final VoidCallback onAdd500;
  final VoidCallback onBoiler250;
  final VoidCallback onRefillBoiler;
  final VoidCallback onCreatine;
  final int boilerAmount;
  final int portionMl;
  final bool creatineActive;
  final bool requireHold;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: HoldActionTile(
                icon: Icons.water_drop_rounded,
                label: '+$portionMl ml',
                gradient: const LinearGradient(
                  colors: [Color(0xFF26C6DA), Color(0xFF00ACC1)],
                ),
                onConfirm: onAdd250,
                requireHold: requireHold,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: HoldActionTile(
                icon: Icons.local_drink_rounded,
                label: '+${portionMl * 2} ml',
                gradient: const LinearGradient(
                  colors: [Color(0xFF42A5F5), Color(0xFF1E88E5)],
                ),
                onConfirm: onAdd500,
                requireHold: requireHold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: boilerAmount >= portionMl
                  ? HoldActionTile(
                      icon: Icons.coffee_rounded,
                      label: l10n.boilerPortion(portionMl),
                      subtitle: l10n.boilerRemaining(boilerAmount),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7E57C2), Color(0xFF5E35B1)],
                      ),
                      onConfirm: onBoiler250,
                      requireHold: requireHold,
                    )
                  : HoldActionTile(
                      icon: Icons.refresh_rounded,
                      label: l10n.refillBoiler,
                      subtitle: l10n.refillBoilerSubtitle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF66BB6A), Color(0xFF43A047)],
                      ),
                      onConfirm: onRefillBoiler,
                      requireHold: false,
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: HoldActionTile(
                icon: creatineActive
                    ? Icons.check_circle_rounded
                    : Icons.medication_rounded,
                label: creatineActive ? l10n.creatineTaken : l10n.creatine,
                subtitle: creatineActive ? null : l10n.creatineTapHint,
                gradient: LinearGradient(
                  colors: creatineActive
                      ? const [Color(0xFF66BB6A), Color(0xFF43A047)]
                      : const [Color(0xFF78909C), Color(0xFF546E7A)],
                ),
                onConfirm: onCreatine,
                requireHold: false,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
