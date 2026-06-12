import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../data/water_repository.dart';
import 'amount_picker.dart';

Future<void> showAdjustWaterSheet(
  BuildContext context,
  WaterRepository repo,
) async {
  var selectedAmount = 50;
  final values = List.generate(21, (index) => index * 50);

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
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
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
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
                  'Ile chcesz odjąć?',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                AmountPicker(
                  value: selectedAmount,
                  values: values,
                  quickValues: const [50, 250, 500, 1000],
                  labelBuilder: (v) => '-$v ml',
                  onChanged: (v) => setState(() => selectedAmount = v),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () async {
                          await repo.subtractWater(selectedAmount);
                          if (context.mounted) Navigator.pop(context);
                        },
                        child: const Text('Odejmij wodę'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          await repo.subtractWater(selectedAmount);
                          await repo.returnToBoiler(selectedAmount);
                          if (context.mounted) Navigator.pop(context);
                        },
                        child: const Text('+ bojler'),
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
                  child: const Text('Reset bojlera'),
                ),
                TextButton(
                  onPressed: () async {
                    await repo.resetToday();
                    if (context.mounted) Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
                  child: const Text('Resetuj cały dzień'),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
