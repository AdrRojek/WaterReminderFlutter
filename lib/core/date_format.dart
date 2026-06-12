const _polishMonths = [
  'sty',
  'lut',
  'mar',
  'kwi',
  'maj',
  'cze',
  'lip',
  'sie',
  'wrz',
  'paź',
  'lis',
  'gru',
];

String formatPolishDate(DateTime date) {
  return '${date.day} ${_polishMonths[date.month - 1]} ${date.year}';
}

String formatRelativeDay(DateTime date, DateTime today) {
  final d = DateTime(date.year, date.month, date.day);
  final t = DateTime(today.year, today.month, today.day);
  final diff = t.difference(d).inDays;

  if (diff == 0) return 'Dziś';
  if (diff == 1) return 'Wczoraj';
  return formatPolishDate(date);
}
