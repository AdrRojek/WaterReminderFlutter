/// Temporary “today feels like…” tags.
/// They nudge pace / debt sensitivity — they do **not** raise the daily goal.
class DayModifiers {
  const DayModifiers({
    this.hot = false,
    this.training = false,
    this.roughMorning = false,
  });

  final bool hot;
  final bool training;
  final bool roughMorning;

  bool get any => hot || training || roughMorning;

  /// Extra ml treated as “behind” for catch-up prompts only.
  int get paceNudgeMl {
    var nudge = 0;
    if (hot) nudge += 250;
    if (training) nudge += 500;
    if (roughMorning) nudge += 250;
    return nudge;
  }

  DayModifiers copyWith({
    bool? hot,
    bool? training,
    bool? roughMorning,
  }) {
    return DayModifiers(
      hot: hot ?? this.hot,
      training: training ?? this.training,
      roughMorning: roughMorning ?? this.roughMorning,
    );
  }

  Map<String, dynamic> toMap() => {
        'hot': hot,
        'training': training,
        'roughMorning': roughMorning,
      };

  factory DayModifiers.fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) return const DayModifiers();
    return DayModifiers(
      hot: map['hot'] == true,
      training: map['training'] == true,
      roughMorning: map['roughMorning'] == true,
    );
  }
}
