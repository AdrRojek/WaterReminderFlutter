import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../data/water_repository.dart';
import '../l10n/app_localizations.dart';
import 'amount_picker.dart';

Future<void> showAdjustWaterSheet(
  BuildContext context,
  WaterRepository repo,
) async {
  var selectedAmount = 250;
  final l10n = AppLocalizations.of(context);

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppTheme.card,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 12,
              bottom: MediaQuery.paddingOf(context).bottom +
                  MediaQuery.viewInsetsOf(context).bottom +
                  28,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.howMuchToSubtract,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                AmountPicker(
                  value: selectedAmount,
                  allowZero: true,
                  valueLabel: (v) => '$v ml',
                  onChanged: (v) => setState(() => selectedAmount = v),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: selectedAmount <= 0
                            ? null
                            : () async {
                                await repo.subtractWater(selectedAmount);
                                if (context.mounted) Navigator.pop(context);
                              },
                        child: Text(l10n.subtractMl(selectedAmount)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: selectedAmount <= 0
                            ? null
                            : () async {
                                await repo.subtractWater(selectedAmount);
                                await repo.returnToBoiler(selectedAmount);
                                if (context.mounted) Navigator.pop(context);
                              },
                        child: Text(l10n.plusBoiler),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () async {
                    await repo.resetBoiler();
                    if (context.mounted) Navigator.pop(context);
                  },
                  child: Text(l10n.resetBoiler),
                ),
                TextButton(
                  onPressed: () async {
                    await repo.resetToday();
                    if (context.mounted) Navigator.pop(context);
                  },
                  style:
                      TextButton.styleFrom(foregroundColor: Colors.redAccent),
                  child: Text(l10n.resetWholeDay),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
