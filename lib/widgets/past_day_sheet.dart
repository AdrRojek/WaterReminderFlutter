import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/theme.dart';
import '../data/water_repository.dart';
import 'amount_picker.dart';

Future<void> showPastDaySheet(
  BuildContext context,
  WaterRepository repo,
) async {
  var selectedDate = DateTime.now().subtract(const Duration(days: 1));
  var amount = AppConstants.portionMl;
  var useBoiler = false;

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
          final yesterday = DateTime.now().subtract(const Duration(days: 1));
          final isYesterday = selectedDate.year == yesterday.year &&
              selectedDate.month == yesterday.month &&
              selectedDate.day == yesterday.day;

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
                  'Dodaj wodę do poprzedniego dnia',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                CalendarDatePicker(
                  initialDate: selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: yesterday,
                  onDateChanged: (date) {
                    setState(() {
                      selectedDate = date;
                      final stillYesterday = date.year == yesterday.year &&
                          date.month == yesterday.month &&
                          date.day == yesterday.day;
                      if (!stillYesterday) useBoiler = false;
                    });
                  },
                ),
                AmountPicker(
                  value: amount,
                  onChanged: (v) => setState(() => amount = v),
                ),
                if (isYesterday) ...[
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Użyj bojlera (wczoraj)'),
                    value: useBoiler,
                    onChanged: (v) => setState(() => useBoiler = v),
                  ),
                ],
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: () async {
                    if (useBoiler && isYesterday) {
                      await repo.useBoilerForYesterday(amount);
                    } else {
                      await repo.addWaterToPastDay(selectedDate, amount);
                    }
                    if (context.mounted) Navigator.pop(context);
                  },
                  child: Text('Dodaj $amount ml'),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
