import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../data/water_repository.dart';

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
    backgroundColor: Theme.of(context).cardColor,
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
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Dodaj wodę do poprzedniego dnia',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                CalendarDatePicker(
                  initialDate: selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: yesterday,
                  onDateChanged: (date) {
                    setState(() {
                      selectedDate = date;
                      if (!isYesterday) useBoiler = false;
                    });
                  },
                ),
                SizedBox(
                  height: 120,
                  child: ListWheelScrollView.useDelegate(
                    itemExtent: 36,
                    onSelectedItemChanged: (index) {
                      setState(() => amount = (index + 1) * 50);
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: 20,
                      builder: (context, index) {
                        final value = (index + 1) * 50;
                        return Center(child: Text('$value ml'));
                      },
                    ),
                  ),
                ),
                if (isYesterday) ...[
                  SwitchListTile(
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
                  child: const Text('Dodaj'),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
