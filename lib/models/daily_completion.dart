class DailyCompletion {
  DailyCompletion({
    required this.dateKey,
    required this.done,
  });

  final String dateKey;
  bool done;

  Map<String, dynamic> toMap() => {
        'dateKey': dateKey,
        'done': done,
      };

  factory DailyCompletion.fromMap(Map<dynamic, dynamic> map) =>
      DailyCompletion(
        dateKey: map['dateKey'] as String,
        done: map['done'] as bool,
      );
}
