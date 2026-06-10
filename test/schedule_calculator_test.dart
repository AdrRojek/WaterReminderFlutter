import 'package:flutter_test/flutter_test.dart';
import 'package:water_reminder/services/schedule_calculator.dart';

void main() {
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
}
