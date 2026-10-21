import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';

String formatAppDate(DateTime date, String localeCode) {
  return DateFormat.MMMd(localeCode).add_y().format(date);
}

String formatRelativeDay(
  DateTime date,
  DateTime today,
  AppLocalizations l10n,
) {
  final d = DateTime(date.year, date.month, date.day);
  final t = DateTime(today.year, today.month, today.day);
  final diff = t.difference(d).inDays;

  if (diff == 0) return l10n.today;
  if (diff == 1) return l10n.yesterday;
  return formatAppDate(date, l10n.localeName);
}
