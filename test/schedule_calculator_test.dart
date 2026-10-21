import 'package:flutter_test/flutter_test.dart';
import 'package:water_reminder/services/schedule_calculator.dart';

void main() {
  group('ScheduleCalculator', () {
    test('redistributeFromWakeUp creates equal intervals until end of day', () {
      final now = DateTime(2026, 6, 11, 2, 0);
      final schedule = ScheduleCalculator.redistributeFromWakeUp(
        now: now,
        currentProgressMl: 0,
        dailyGoalMl: 4000,
        portionMl: 250,
      );

      expect(schedule.length, 16);
      expect(schedule.first.time.isAfter(now), isTrue);
      expect(schedule.last.time.hour, lessThanOrEqualTo(21));
    });

    test('recommendedMlAt returns 0 before 9:00', () {
      final early = DateTime(2026, 6, 11, 7, 30);
      expect(ScheduleCalculator.recommendedMlAt(early), 0);
    });

    test('recommendedMlAt at 15:40 matches schedule slot', () {
      final afternoon = DateTime(2026, 6, 11, 15, 40);
      expect(ScheduleCalculator.recommendedMlAt(afternoon), 2250);
    });

    test('recommendedMlAt at 20:45 matches last passed slot (20:40)', () {
      final evening = DateTime(2026, 6, 11, 20, 45);
      expect(ScheduleCalculator.recommendedMlAt(evening), 3750);
    });

    test('filterAheadOfProgress skips slots below current intake', () {
      final schedule = ScheduleCalculator.defaultDailySchedule(
        day: DateTime(2026, 6, 11),
      );
      final filtered = ScheduleCalculator.filterAheadOfProgress(
        schedule,
        3000,
        dailyGoalMl: 4000,
      );

      expect(filtered.every((slot) => slot.cumulativeMl > 3000), isTrue);
      expect(filtered.first.cumulativeMl, 3250);
      expect(filtered.last.cumulativeMl, 4000);
    });

    test('filterAheadOfProgress returns empty when goal reached', () {
      final schedule = ScheduleCalculator.defaultDailySchedule(
        day: DateTime(2026, 6, 11),
      );
      final filtered = ScheduleCalculator.filterAheadOfProgress(
        schedule,
        4000,
        dailyGoalMl: 4000,
      );

      expect(filtered, isEmpty);
    });

    test('catchUpPlan returns null when on pace', () {
    final plan = ScheduleCalculator.catchUpPlan(
      now: DateTime(2026, 3, 15, 10, 0),
      currentProgressMl: 500,
      dailyGoalMl: 4000,
      portionMl: 250,
    );
    expect(plan, isNull);
  });

  test('catchUpPlan appears when behind schedule', () {
    final plan = ScheduleCalculator.catchUpPlan(
      now: DateTime(2026, 3, 15, 15, 40),
      currentProgressMl: 250,
      dailyGoalMl: 4000,
      portionMl: 250,
    );
    expect(plan, isNotNull);
    expect(plan!.debtMl, greaterThanOrEqualTo(250));
    expect(plan.portions, greaterThan(0));
  });

  test('defaultDailySchedule has 16 reminders', () {
      final schedule = ScheduleCalculator.defaultDailySchedule(
        day: DateTime(2026, 6, 11),
      );
      expect(schedule.length, 16);
      expect(schedule.first.time.hour, 9);
      expect(schedule[14].time.hour, 20);
      expect(schedule[14].time.minute, 40);
      expect(schedule[14].cumulativeMl, 3750);
    });
  });
}
