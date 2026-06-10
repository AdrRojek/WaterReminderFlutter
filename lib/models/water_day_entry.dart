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
        dateKey: map['dateKey'] as String,
        progressMl: map['progressMl'] as int,
        kreatyna: map['kreatyna'] as bool? ?? false,
      );
}
