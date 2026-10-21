import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../core/constants.dart';
import '../core/locale_resolver.dart';
import '../data/storage_service.dart';
import '../models/app_settings.dart';
import '../models/boiler_state.dart';
import '../models/daily_completion.dart';
import '../models/day_modifiers.dart';
import '../models/streak_info.dart';
import '../models/water_day_entry.dart';
import '../services/notification_service.dart';
import '../services/schedule_calculator.dart';

class WaterRepository extends ChangeNotifier {
  WaterRepository(this._storage);

  final StorageService _storage;

  List<WaterDayEntry> _entries = [];
  List<DailyCompletion> _completions = [];
  BoilerState _boiler = BoilerState(amountMl: AppConstants.boilerCapacityMl);
  AppSettings _settings = AppSettings();
  DayModifiers _dayModifiers = const DayModifiers();
  bool _initialized = false;

  List<WaterDayEntry> get entries => List.unmodifiable(_entries);
  List<DailyCompletion> get completions => List.unmodifiable(_completions);
  BoilerState get boiler => _boiler;
  AppSettings get settings => _settings;
  DayModifiers get dayModifiers => _dayModifiers;
  bool get isInitialized => _initialized;

  String get todayKey => _dateKey(DateTime.now());

  int get todayProgress =>
      _entries.firstWhere(
        (e) => e.dateKey == todayKey,
        orElse: () => WaterDayEntry(dateKey: todayKey, progressMl: 0),
      ).progressMl;

  bool get isKreatynaToday {
    final entry = _entries.where((e) => e.dateKey == todayKey);
    return entry.isNotEmpty && entry.first.kreatyna;
  }

  Future<void> initialize() async {
    await _storage.openBoxes();
    _entries = _storage.getAllWaterEntries();
    _completions = _storage.getAllCompletions();
    _boiler = _storage.getBoiler();
    _settings = _storage.getSettings();
    await _storage.getOrCreateToday(todayKey);
    _entries = _storage.getAllWaterEntries();
    _dayModifiers = _storage.getDayModifiers(todayKey);
    _initialized = true;
    notifyListeners();
  }

  Future<void> addWater(int amountMl, {String? dateKey}) async {
    final key = dateKey ?? todayKey;
    final entry = await _storage.getOrCreateToday(key);
    entry.progressMl += amountMl;
    await _storage.saveWaterEntry(entry);
    await _updateCompletion(key, entry.progressMl);
    _reload();
    if (key == todayKey) {
      await _refreshNotificationsForToday();
    }
  }

  Future<void> subtractWater(int amountMl, {String? dateKey}) async {
    final key = dateKey ?? todayKey;
    final entry = await _storage.getOrCreateToday(key);
    entry.progressMl = (entry.progressMl - amountMl).clamp(0, 999999);
    await _storage.saveWaterEntry(entry);
    await _updateCompletion(key, entry.progressMl);
    _reload();
    if (key == todayKey) {
      await _refreshNotificationsForToday();
    }
  }

  Future<void> resetToday() async {
    final entry = await _storage.getOrCreateToday(todayKey);
    entry.progressMl = 0;
    entry.kreatyna = false;
    await _storage.saveWaterEntry(entry);
    await _updateCompletion(todayKey, 0);
    _reload();
    await _refreshNotificationsForToday();
  }

  Future<void> toggleKreatyna() async {
    final entry = await _storage.getOrCreateToday(todayKey);
    entry.kreatyna = !entry.kreatyna;
    await _storage.saveWaterEntry(entry);
    _reload();
    // Creatine taken → drop creatine hints from upcoming notifications.
    await _refreshNotificationsForToday();
  }

  Future<void> updateDayModifiers(DayModifiers modifiers) async {
    _dayModifiers = modifiers;
    await _storage.saveDayModifiers(todayKey, modifiers);
    notifyListeners();
  }

  CatchUpPlan? catchUpPlanNow() {
    return ScheduleCalculator.catchUpPlan(
      now: DateTime.now(),
      currentProgressMl: todayProgress,
      dailyGoalMl: _settings.dailyGoalMl,
      portionMl: _settings.portionMl,
      paceNudgeMl: _dayModifiers.paceNudgeMl,
    );
  }

  /// One-tap catch-up: equal gaps from now until 21:00 for remaining goal.
  Future<void> applyCatchUpPlan() => handleNightWakeUp();

  Future<void> useBoiler(int amountMl) async {
    if (_boiler.amountMl < amountMl) return;
    _boiler.amountMl -= amountMl;
    await _storage.saveBoiler(_boiler);
    await addWater(amountMl);
  }

  Future<void> refillBoiler() async {
    _boiler.amountMl = AppConstants.boilerCapacityMl;
    await _storage.saveBoiler(_boiler);
    notifyListeners();
  }

  Future<void> returnToBoiler(int amountMl) async {
    _boiler.amountMl = (_boiler.amountMl + amountMl)
        .clamp(0, AppConstants.boilerCapacityMl);
    await _storage.saveBoiler(_boiler);
    notifyListeners();
  }

  Future<void> resetBoiler() async {
    await refillBoiler();
  }

  Future<void> addWaterToPastDay(DateTime date, int amountMl) async {
    final key = _dateKey(date);
    await addWater(amountMl, dateKey: key);
  }

  Future<void> useBoilerForYesterday(int amountMl) async {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final key = _dateKey(yesterday);

    final available = _boiler.amountMl.clamp(0, amountMl);
    final remaining = amountMl - available;

    _boiler.amountMl -= available;
    if (remaining > 0) {
      _boiler.amountMl = AppConstants.boilerCapacityMl - remaining;
    }
    await _storage.saveBoiler(_boiler);
    await addWater(amountMl, dateKey: key);
  }

  Future<void> updateSettings(AppSettings settings) async {
    _settings = settings;
    await _storage.saveSettings(settings);
    notifyListeners();
  }

  String get _monthKey {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}';
  }

  StreakInfo calculateStreak() {
    final monthKey = _monthKey;
    // ignore: discarded_futures
    _storage.clearAmnestyIfOtherMonth(monthKey);

    final amnestyMonth = _storage.getAmnestyMonthKey();
    final amnestyDate = _storage.getAmnestyDateKey();
    final amnestyUsedThisMonth = amnestyMonth == monthKey;
    final byDate = {
      for (final c in _completions) c.dateKey: c,
    };

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final todayCompletion = byDate[todayKey];

    var streak = 0;
    var expected = today;
    if (todayCompletion != null && todayCompletion.countsForStreak) {
      streak++;
      expected = today.subtract(const Duration(days: 1));
    } else {
      expected = today.subtract(const Duration(days: 1));
    }

    for (var i = 0; i < 400; i++) {
      final key = _dateKey(expected);
      final completion = byDate[key];
      if (completion != null && completion.countsForStreak) {
        streak++;
        expected = expected.subtract(const Duration(days: 1));
        continue;
      }
      break;
    }

    final half = (_settings.dailyGoalMl * 0.5).round();
    final amnestyAvailable = !amnestyUsedThisMonth &&
        todayProgress >= half &&
        todayProgress < _settings.dailyGoalMl &&
        (todayCompletion == null || !todayCompletion.countsForStreak);

    return StreakInfo(
      streak: streak,
      amnestyAvailable: amnestyAvailable,
      amnestyUsedThisMonth: amnestyUsedThisMonth,
      amnestyDateKey: amnestyUsedThisMonth ? amnestyDate : null,
    );
  }

  /// Once per month: keep streak with ≥50% of the goal (wild day).
  Future<bool> useAmnestyToday() async {
    final info = calculateStreak();
    if (!info.amnestyAvailable) return false;

    final existing = _storage.getCompletionForDate(todayKey);
    final completion = existing ??
        DailyCompletion(dateKey: todayKey, done: false, amnesty: true);
    completion.amnesty = true;
    completion.done = todayProgress >= _settings.dailyGoalMl;
    await _storage.saveCompletion(completion);
    await _storage.setAmnestyUsed(monthKey: _monthKey, dateKey: todayKey);
    _reload();
    return true;
  }

  /// Push the next reminder ~20 minutes later (silent / quiet slot).
  Future<bool> snoozeNextSlot({
    Duration delay = const Duration(minutes: 20),
  }) async {
    if (!_settings.notificationsEnabled) return false;
    _bindNotificationL10n();
    final now = DateTime.now();
    final when = now.add(delay);
    final end = DateTime(
      now.year,
      now.month,
      now.day,
      AppConstants.dayEndHour,
      AppConstants.dayEndMinute,
    );
    if (when.isAfter(end)) return false;

    // Cancel the soonest upcoming slot so it doesn't double-fire.
    final upcoming = _upcomingReminders(now);
    if (upcoming.isNotEmpty) {
      await NotificationService.instance.cancelReminder(upcoming.first);
    }

    await NotificationService.instance.snoozeReminder(
      when: when,
      portionMl: _settings.portionMl,
      currentProgressMl: todayProgress,
      dailyGoalMl: _settings.dailyGoalMl,
      creatineTaken: isKreatynaToday,
    );
    return true;
  }

  List<ScheduledReminder> _upcomingReminders(DateTime now) {
    final saved = _storage.getActiveScheduleMaps();
    var schedule =
        saved.map(_reminderFromMap).whereType<ScheduledReminder>().toList();
    if (schedule.isEmpty) {
      schedule = ScheduleCalculator.defaultDailySchedule(
        day: now,
        portionMl: _settings.portionMl,
      );
    }
    return ScheduleCalculator.filterAheadOfProgress(
      schedule,
      todayProgress,
      dailyGoalMl: _settings.dailyGoalMl,
    ).where((r) => r.time.isAfter(now)).toList()
      ..sort((a, b) => a.time.compareTo(b.time));
  }

  int recommendedMlNow() =>
      ScheduleCalculator.recommendedMlAt(DateTime.now(), portionMl: _settings.portionMl);

  void _bindNotificationL10n() {
    NotificationService.instance.useLocalizations(l10nForSettings(_settings));
  }

  /// Codziennie 9:00–21:00, chyba że dziś już przeliczono „od teraz”.
  Future<void> ensureDailySchedule({bool forceDefault = false}) async {
    if (!_settings.notificationsEnabled) return;

    final today = todayKey;
    final scheduleDate = _storage.getScheduleDateKey();
    final redistributed = _storage.isScheduleRedistributed();

    if (forceDefault || scheduleDate != today) {
      await scheduleDefaultNotifications();
      return;
    }

    if (redistributed) {
      await _rescheduleRedistributedKeepingProgress();
    } else {
      await scheduleDefaultNotifications();
    }
  }

  Future<void> _refreshNotificationsForToday() async {
    if (!_settings.notificationsEnabled) return;
    try {
      await ensureDailySchedule();
    } catch (e) {
      debugPrint('Notification refresh: $e');
    }
  }

  Future<void> scheduleDefaultNotifications() async {
    if (!_settings.notificationsEnabled) return;
    _bindNotificationL10n();

    final now = DateTime.now();
    final progress = todayProgress;
    final planDay = now.hour >= AppConstants.dayEndHour
        ? DateTime(now.year, now.month, now.day).add(const Duration(days: 1))
        : DateTime(now.year, now.month, now.day);

    // Po 21:00 planujemy jutrzejszy standardowy dzień (0 ml postępu).
    final progressForPlan =
        _dateKey(planDay) == todayKey ? progress : 0;

    final schedule = ScheduleCalculator.defaultDailySchedule(
      day: planDay,
      portionMl: _settings.portionMl,
    );

    await NotificationService.instance.scheduleReminders(
      schedule,
      currentProgressMl: progressForPlan,
      dailyGoalMl: _settings.dailyGoalMl,
      creatineTaken: isKreatynaToday,
    );

    if (_settings.nightNotificationEnabled) {
      await NotificationService.instance.scheduleNightNotification(planDay);
    }

    await NotificationService.instance.scheduleMidnightReset();
    await _storage.setScheduleState(
      dateKey: todayKey,
      redistributed: false,
      activeSchedule: null,
    );
  }

  /// Kliknięcie o dowolnej godzinie (np. 15:00) — równe odstępy do 21:00.
  Future<void> handleNightWakeUp() async {
    _bindNotificationL10n();
    final now = DateTime.now();
    final progress = todayProgress;
    final schedule = ScheduleCalculator.redistributeFromWakeUp(
      now: now,
      currentProgressMl: progress,
      dailyGoalMl: _settings.dailyGoalMl,
      portionMl: _settings.portionMl,
    );

    await NotificationService.instance.scheduleReminders(
      schedule,
      replaceExisting: true,
      currentProgressMl: progress,
      dailyGoalMl: _settings.dailyGoalMl,
      creatineTaken: isKreatynaToday,
    );

    if (_settings.nightNotificationEnabled) {
      await NotificationService.instance.scheduleNightNotification(now);
    }
    await NotificationService.instance.scheduleMidnightReset();
    await _storage.setScheduleState(
      dateKey: todayKey,
      redistributed: true,
      activeSchedule: schedule.map(_reminderToMap).toList(),
    );
    notifyListeners();
  }

  /// Trzyma godziny z kliknięcia (np. 15:00), tylko odcina już wypite sloty.
  Future<void> _rescheduleRedistributedKeepingProgress() async {
    _bindNotificationL10n();
    final now = DateTime.now();
    final progress = todayProgress;
    final saved = _storage.getActiveScheduleMaps();
    var schedule = saved.map(_reminderFromMap).whereType<ScheduledReminder>().toList();

    if (schedule.isEmpty) {
      schedule = ScheduleCalculator.redistributeFromWakeUp(
        now: now,
        currentProgressMl: progress,
        dailyGoalMl: _settings.dailyGoalMl,
        portionMl: _settings.portionMl,
      );
    }

    await NotificationService.instance.scheduleReminders(
      schedule,
      replaceExisting: true,
      currentProgressMl: progress,
      dailyGoalMl: _settings.dailyGoalMl,
      creatineTaken: isKreatynaToday,
    );

    if (_settings.nightNotificationEnabled) {
      await NotificationService.instance.scheduleNightNotification(now);
    }
    await NotificationService.instance.scheduleMidnightReset();
    await _storage.setScheduleState(
      dateKey: todayKey,
      redistributed: true,
      activeSchedule: schedule.map(_reminderToMap).toList(),
    );
  }

  Map<String, dynamic> _reminderToMap(ScheduledReminder reminder) => {
        'time': reminder.time.toIso8601String(),
        'portionMl': reminder.portionMl,
        'cumulativeMl': reminder.cumulativeMl,
        'isNightWake': reminder.isNightWake,
      };

  ScheduledReminder? _reminderFromMap(Map<String, dynamic> map) {
    final rawTime = map['time'];
    if (rawTime is! String) return null;
    final time = DateTime.tryParse(rawTime);
    if (time == null) return null;
    return ScheduledReminder(
      time: time,
      portionMl: (map['portionMl'] as num?)?.toInt() ?? _settings.portionMl,
      cumulativeMl: (map['cumulativeMl'] as num?)?.toInt() ?? 0,
      isNightWake: map['isNightWake'] == true,
    );
  }

  Future<void> _updateCompletion(String dateKey, int progressMl) async {
    final done = progressMl >= _settings.dailyGoalMl;
    final existing = _storage.getCompletionForDate(dateKey);
    if (existing != null) {
      existing.done = done;
      if (done) existing.amnesty = false;
      await _storage.saveCompletion(existing);
    } else {
      await _storage.saveCompletion(
        DailyCompletion(dateKey: dateKey, done: done),
      );
    }
  }

  void _reload() {
    _entries = _storage.getAllWaterEntries();
    _completions = _storage.getAllCompletions();
    notifyListeners();
  }

  String _dateKey(DateTime date) => DateFormat('yyyy-MM-dd').format(date);
}
