class WaterDayEntry {
  WaterDayEntry({
    required this.dateKey,
    required this.progressMl,
    this.kreatyna = false,
  });

  final String dateKey;
  int progressMl;
  bool kreatyna;

  Map<String, dynamic> toMap() => {
        'dateKey': dateKey,
        'progressMl': progressMl,
        'kreatyna': kreatyna,
      };

  factory WaterDayEntry.fromMap(Map<dynamic, dynamic> map) => WaterDayEntry(
        dateKey: map['dateKey']?.toString() ?? '',
        progressMl: _asInt(map['progressMl']),
        kreatyna: map['kreatyna'] == true,
      );
}

int _asInt(dynamic value, [int fallback = 0]) {
  if (value is int) return value;
  if (value is double) return value.round();
  if (value is num) return value.toInt();
  return fallback;
}
