import 'package:flutter/material.dart';

import '../data/water_repository.dart';

Future<void> showAdjustWaterSheet(
  BuildContext context,
  WaterRepository repo,
) async {
  var selectedAmount = 50;

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).cardColor,
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
              top: 20,
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
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 140,
                  child: ListWheelScrollView.useDelegate(
                    itemExtent: 40,
                    onSelectedItemChanged: (index) {
                      setState(() => selectedAmount = index * 50);
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: 21,
                      builder: (context, index) {
                        final value = index * 50;
                        return Center(
                          child: Text(
                            '-$value ml',
                            style: TextStyle(
                              fontSize: value == selectedAmount ? 22 : 16,
                              fontWeight: value == selectedAmount
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
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
