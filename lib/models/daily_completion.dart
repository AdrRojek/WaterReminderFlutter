class DailyCompletion {
  DailyCompletion({
    required this.dateKey,
    required this.done,
    this.amnesty = false,
  });

  final String dateKey;
  bool done;

  /// Soft day (≈50%+ goal) that keeps the streak once per month.
  bool amnesty;

  bool get countsForStreak => done || amnesty;

  Map<String, dynamic> toMap() => {
        'dateKey': dateKey,
        'done': done,
        'amnesty': amnesty,
      };

  factory DailyCompletion.fromMap(Map<dynamic, dynamic> map) =>
      DailyCompletion(
        dateKey: map['dateKey']?.toString() ?? '',
        done: map['done'] == true,
        amnesty: map['amnesty'] == true,
      );
}
