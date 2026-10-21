import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/date_format.dart';
import '../core/theme.dart';
import '../data/water_repository.dart';
import '../l10n/app_localizations.dart';
import 'amount_picker.dart';

Future<void> showPastDaySheet(
  BuildContext context,
  WaterRepository repo,
) async {
  var selectedDate = DateTime.now().subtract(const Duration(days: 1));
  var amount = AppConstants.portionMl;
  var useBoiler = false;
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
          final today = DateTime.now();
          final yesterday = today.subtract(const Duration(days: 1));
          final isYesterday = selectedDate.year == yesterday.year &&
              selectedDate.month == yesterday.month &&
              selectedDate.day == yesterday.day;

          Future<void> pickDate() async {
            final picked = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime(2020),
              lastDate: yesterday,
              helpText: l10n.pickDay,
              cancelText: l10n.cancel,
              confirmText: l10n.ok,
              locale: Localizations.localeOf(context),
            );
            if (picked != null) {
              setState(() {
                selectedDate = picked;
                final stillYesterday = picked.year == yesterday.year &&
                    picked.month == yesterday.month &&
                    picked.day == yesterday.day;
                if (!stillYesterday) useBoiler = false;
              });
            }
          }

          final bottomInset = MediaQuery.paddingOf(context).bottom;

          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.76,
            minChildSize: 0.5,
            maxChildSize: 0.92,
            builder: (context, scrollController) {
              return ListView(
                controller: scrollController,
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 12,
                  bottom: bottomInset +
                      MediaQuery.viewInsetsOf(context).bottom +
                      28,
                ),
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
                    l10n.addWaterPastDay,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Material(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      onTap: pickDate,
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color:
                                    AppTheme.secondary.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.calendar_month_rounded,
                                color: AppTheme.primary,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    formatRelativeDay(
                                      selectedDate,
                                      today,
                                      l10n,
                                    ),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    formatAppDate(
                                      selectedDate,
                                      l10n.localeName,
                                    ),
                                    style: TextStyle(
                                      color:
                                          Colors.white.withValues(alpha: 0.5),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: pickDate,
                              child: Text(l10n.change),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  AmountPicker(
                    value: amount,
                    onChanged: (v) => setState(() => amount = v),
                  ),
                  if (isYesterday) ...[
                    const SizedBox(height: 8),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.useBoilerYesterday),
                      value: useBoiler,
                      onChanged: (v) => setState(() => useBoiler = v),
                    ),
                  ],
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: amount <= 0
                        ? null
                        : () async {
                            if (useBoiler && isYesterday) {
                              await repo.useBoilerForYesterday(amount);
                            } else {
                              await repo.addWaterToPastDay(
                                selectedDate,
                                amount,
                              );
                            }
                            if (context.mounted) Navigator.pop(context);
                          },
                    child: Text(l10n.addMl(amount)),
                  ),
                ],
              );
            },
          );
        },
      );
    },
  );
}
