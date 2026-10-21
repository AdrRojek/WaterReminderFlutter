import '../core/constants.dart';

class ScheduledReminder {
  const ScheduledReminder({
    required this.time,
    required this.portionMl,
    required this.cumulativeMl,
    this.isNightWake = false,
  });

  final DateTime time;
  final int portionMl;
  final int cumulativeMl;
  final bool isNightWake;

  String get slotKey =>
      '${time.year}-${time.month}-${time.day}_${time.hour}_${time.minute}';
}

class ScheduleCalculator {
  static const _dailyTimes = [
    (9, 0),
    (9, 50),
    (10, 40),
    (11, 30),
    (12, 20),
    (13, 10),
    (14, 0),
    (14, 50),
    (15, 40),
    (16, 30),
    (17, 20),
    (18, 10),
    (19, 0),
    (19, 50),
    (20, 40),
    (21, 0),
  ];

  /// Domyślny harmonogram jak w wersji iOS (co ~50 min, 9:00–21:00).
  static List<ScheduledReminder> defaultDailySchedule({
    required DateTime day,
    int portionMl = AppConstants.portionMl,
  }) {
    return [
      for (var i = 0; i < _dailyTimes.length; i++)
        ScheduledReminder(
          time: DateTime(
            day.year,
            day.month,
            day.day,
            _dailyTimes[i].$1,
            _dailyTimes[i].$2,
          ),
          portionMl: portionMl,
          cumulativeMl: portionMl * (i + 1),
        ),
    ];
  }

  /// Po kliknięciu powiadomienia nocnego — równe odstępy od teraz do końca dnia.
  static List<ScheduledReminder> redistributeFromWakeUp({
    required DateTime now,
    required int currentProgressMl,
    required int dailyGoalMl,
    int portionMl = AppConstants.portionMl,
    int endHour = AppConstants.dayEndHour,
    int endMinute = AppConstants.dayEndMinute,
  }) {
    final endOfDay = DateTime(
      now.year,
      now.month,
      now.day,
      endHour,
      endMinute,
    );

    if (!now.isBefore(endOfDay)) return [];

    final remainingMl = (dailyGoalMl - currentProgressMl).clamp(0, dailyGoalMl);
    if (remainingMl <= 0) return [];

    final portions = (remainingMl / portionMl).ceil();
    final totalMinutes = endOfDay.difference(now).inMinutes;

    if (portions <= 0 || totalMinutes <= 0) return [];

    final intervalMinutes = totalMinutes / portions;
    final reminders = <ScheduledReminder>[];

    for (var i = 0; i < portions; i++) {
      final time = now.add(
        Duration(minutes: (intervalMinutes * (i + 1)).round()),
      );
      if (time.isAfter(endOfDay)) break;

      reminders.add(
        ScheduledReminder(
          time: time,
          portionMl: portionMl,
          cumulativeMl: currentProgressMl + portionMl * (i + 1),
          isNightWake: i == 0,
        ),
      );
    }

    return reminders;
  }

  /// Ile wody powinieneś mieć wypite — wg ostatniego minionego slotu harmonogramu.
  static int recommendedMlAt(DateTime now, {int portionMl = 250}) {
    final schedule = defaultDailySchedule(day: now, portionMl: portionMl);
    final passed = schedule.where((slot) => !slot.time.isAfter(now)).toList();
    if (passed.isEmpty) return 0;
    return passed.last.cumulativeMl;
  }

  static ScheduledReminder? slotAt(DateTime time, {int portionMl = 250}) {
    final schedule = defaultDailySchedule(day: time, portionMl: portionMl);
    for (final slot in schedule) {
      if (slot.time.hour == time.hour && slot.time.minute == time.minute) {
        return slot;
      }
    }
    return null;
  }

  /// Zostawia tylko przypomnienia, których cel jest wyższy niż aktualny postęp.
  static List<ScheduledReminder> filterAheadOfProgress(
    List<ScheduledReminder> reminders,
    int currentProgressMl, {
    int? dailyGoalMl,
  }) {
    if (dailyGoalMl != null && currentProgressMl >= dailyGoalMl) {
      return [];
    }

    return reminders
        .where((reminder) => reminder.cumulativeMl > currentProgressMl)
        .toList();
  }

  /// How far behind the schedule you are (optionally nudged by day tags).
  static CatchUpPlan? catchUpPlan({
    required DateTime now,
    required int currentProgressMl,
    required int dailyGoalMl,
    int portionMl = AppConstants.portionMl,
    int paceNudgeMl = 0,
  }) {
    final endOfDay = DateTime(
      now.year,
      now.month,
      now.day,
      AppConstants.dayEndHour,
      AppConstants.dayEndMinute,
    );
    if (!now.isBefore(endOfDay)) return null;
    if (currentProgressMl >= dailyGoalMl) return null;

    final recommended = recommendedMlAt(now, portionMl: portionMl);
    final effectiveTarget = recommended + paceNudgeMl;
    final debtMl = (effectiveTarget - currentProgressMl).clamp(0, dailyGoalMl);
    if (debtMl < portionMl) return null;

    final remainingMl = (dailyGoalMl - currentProgressMl).clamp(0, dailyGoalMl);
    final portions = (remainingMl / portionMl).ceil();
    final totalMinutes = endOfDay.difference(now).inMinutes;
    if (portions <= 0 || totalMinutes <= 0) return null;

    return CatchUpPlan(
      debtMl: debtMl,
      remainingMl: remainingMl,
      portions: portions,
      intervalMinutes: (totalMinutes / portions).round().clamp(1, totalMinutes),
    );
  }
}

class CatchUpPlan {
  const CatchUpPlan({
    required this.debtMl,
    required this.remainingMl,
    required this.portions,
    required this.intervalMinutes,
  });

  final int debtMl;
  final int remainingMl;
  final int portions;
  final int intervalMinutes;
}
