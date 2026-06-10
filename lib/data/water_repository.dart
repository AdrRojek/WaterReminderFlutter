import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../core/constants.dart';
import '../data/storage_service.dart';
import '../models/app_settings.dart';
import '../models/boiler_state.dart';
import '../models/daily_completion.dart';
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
  bool _initialized = false;

  List<WaterDayEntry> get entries => List.unmodifiable(_entries);
  List<DailyCompletion> get completions => List.unmodifiable(_completions);
  BoilerState get boiler => _boiler;
  AppSettings get settings => _settings;
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
  }

  Future<void> subtractWater(int amountMl, {String? dateKey}) async {
    final key = dateKey ?? todayKey;
    final entry = await _storage.getOrCreateToday(key);
    entry.progressMl = (entry.progressMl - amountMl).clamp(0, 999999);
    await _storage.saveWaterEntry(entry);
    await _updateCompletion(key, entry.progressMl);
    _reload();
  }

  Future<void> resetToday() async {
    final entry = await _storage.getOrCreateToday(todayKey);
    entry.progressMl = 0;
    entry.kreatyna = false;
    await _storage.saveWaterEntry(entry);
    await _updateCompletion(todayKey, 0);
    _reload();
  }

  Future<void> toggleKreatyna() async {
    final entry = await _storage.getOrCreateToday(todayKey);
    entry.kreatyna = !entry.kreatyna;
    await _storage.saveWaterEntry(entry);
    _reload();
  }

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

  int calculateStreak() {
    final sorted = List<DailyCompletion>.from(_completions)
      ..sort((a, b) => b.dateKey.compareTo(a.dateKey));

    var streak = 0;
    var expected = DateTime.now();

    final todayCompletion = sorted.where((c) => c.dateKey == todayKey);
    if (todayCompletion.isNotEmpty && todayCompletion.first.done) {
      streak++;
      expected = expected.subtract(const Duration(days: 1));
    } else {
      expected = expected.subtract(const Duration(days: 1));
    }

    for (final entry in sorted) {
      if (entry.dateKey == todayKey) continue;

      final entryDate = DateTime.parse(entry.dateKey);
      while (entryDate.isBefore(
        DateTime(expected.year, expected.month, expected.day),
      )) {
        return streak;
      }

      if (entry.dateKey == _dateKey(expected) && entry.done) {
        streak++;
        expected = expected.subtract(const Duration(days: 1));
      } else if (entry.dateKey == _dateKey(expected)) {
        return streak;
      }
    }

    return streak;
  }

  int recommendedMlNow() =>
      ScheduleCalculator.recommendedMlAt(DateTime.now(), portionMl: _settings.portionMl);

  Future<void> scheduleDefaultNotifications() async {
    if (!_settings.notificationsEnabled) return;
    final now = DateTime.now();
    final day = now.hour >= AppConstants.dayEndHour
        ? now.add(const Duration(days: 1))
        : now;

    final schedule = ScheduleCalculator.defaultDailySchedule(
      day: day,
      portionMl: _settings.portionMl,
    ).where((r) => r.time.isAfter(now)).toList();

    await NotificationService.instance.scheduleReminders(schedule);
    if (_settings.nightNotificationEnabled) {
      await NotificationService.instance.scheduleNightNotification(day);
    }
  }

  /// Wywoływane po kliknięciu powiadomienia nocnego — przelicza harmonogram.
  Future<void> handleNightWakeUp() async {
    final now = DateTime.now();
    final schedule = ScheduleCalculator.redistributeFromWakeUp(
      now: now,
      currentProgressMl: todayProgress,
      dailyGoalMl: _settings.dailyGoalMl,
      portionMl: _settings.portionMl,
    );

    await NotificationService.instance.scheduleReminders(
      schedule,
      replaceExisting: true,
    );
    notifyListeners();
  }

  Future<void> _updateCompletion(String dateKey, int progressMl) async {
    final done = progressMl >= _settings.dailyGoalMl;
    final existing = _storage.getCompletionForDate(dateKey);
    if (existing != null) {
      existing.done = done;
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
