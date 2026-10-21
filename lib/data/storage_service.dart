import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants.dart';
import '../models/app_settings.dart';
import '../models/boiler_state.dart';
import '../models/daily_completion.dart';
import '../models/day_modifiers.dart';
import '../models/water_day_entry.dart';

class StorageService {
  StorageService._();
  static final instance = StorageService._();

  SharedPreferences? _prefs;

  static const _waterKey = 'water_entries_v1';
  static const _completionKey = 'daily_completions_v1';
  static const _boilerKey = 'boiler_v1';
  static const _settingsKey = 'settings_v1';
  static const _scheduleDateKey = 'schedule_date_v1';
  static const _scheduleRedistributedKey = 'schedule_redistributed_v1';
  static const _activeScheduleKey = 'active_schedule_v1';
  static const _dayModifiersKey = 'day_modifiers_v1';
  static const _amnestyMonthKey = 'amnesty_month_v1';
  static const _amnestyDateKey = 'amnesty_date_v1';

  Future<void> openBoxes() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> resetAll() async {
    await openBoxes();
    await _prefs!.remove(_waterKey);
    await _prefs!.remove(_completionKey);
    await _prefs!.remove(_boilerKey);
    await _prefs!.remove(_settingsKey);
    await _prefs!.remove(_scheduleDateKey);
    await _prefs!.remove(_scheduleRedistributedKey);
    await _prefs!.remove(_activeScheduleKey);
    await _prefs!.remove(_dayModifiersKey);
    await _prefs!.remove(_amnestyMonthKey);
    await _prefs!.remove(_amnestyDateKey);
  }

  String? getAmnestyMonthKey() => _prefs?.getString(_amnestyMonthKey);

  String? getAmnestyDateKey() => _prefs?.getString(_amnestyDateKey);

  Future<void> setAmnestyUsed({
    required String monthKey,
    required String dateKey,
  }) async {
    await openBoxes();
    await _prefs!.setString(_amnestyMonthKey, monthKey);
    await _prefs!.setString(_amnestyDateKey, dateKey);
  }

  Future<void> clearAmnestyIfOtherMonth(String currentMonthKey) async {
    final stored = getAmnestyMonthKey();
    if (stored != null && stored != currentMonthKey) {
      await openBoxes();
      await _prefs!.remove(_amnestyMonthKey);
      await _prefs!.remove(_amnestyDateKey);
    }
  }

  DayModifiers getDayModifiers(String dateKey) {
    if (_prefs == null) return const DayModifiers();
    final map = _decodeMap(_prefs!.getString(_dayModifiersKey));
    final data = map[dateKey];
    if (data is Map) return DayModifiers.fromMap(data);
    return const DayModifiers();
  }

  Future<void> saveDayModifiers(String dateKey, DayModifiers modifiers) async {
    await openBoxes();
    final map = _decodeMap(_prefs!.getString(_dayModifiersKey));
    map[dateKey] = modifiers.toMap();
    await _encodeMap(_dayModifiersKey, map);
  }

  String? getScheduleDateKey() => _prefs?.getString(_scheduleDateKey);

  bool isScheduleRedistributed() =>
      _prefs?.getBool(_scheduleRedistributedKey) ?? false;

  Future<void> setScheduleState({
    required String dateKey,
    required bool redistributed,
    List<Map<String, dynamic>>? activeSchedule,
  }) async {
    await openBoxes();
    await _prefs!.setString(_scheduleDateKey, dateKey);
    await _prefs!.setBool(_scheduleRedistributedKey, redistributed);
    if (activeSchedule != null) {
      await _prefs!.setString(_activeScheduleKey, jsonEncode(activeSchedule));
    } else if (!redistributed) {
      await _prefs!.remove(_activeScheduleKey);
    }
  }

  List<Map<String, dynamic>> getActiveScheduleMaps() {
    if (_prefs == null) return [];
    final raw = _prefs!.getString(_activeScheduleKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded
            .whereType<Map>()
            .map((e) => e.map((k, v) => MapEntry(k.toString(), v)))
            .toList();
      }
    } catch (e) {
      debugPrint('Active schedule decode error: $e');
    }
    return [];
  }

  Map<String, dynamic> _decodeMap(String? raw) {
    if (raw == null || raw.isEmpty) return {};
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map) {
        return decoded.map((k, v) => MapEntry(k.toString(), v));
      }
    } catch (e) {
      debugPrint('JSON decode error: $e');
    }
    return {};
  }

  Future<void> _encodeMap(String key, Map<String, dynamic> map) async {
    await _prefs!.setString(key, jsonEncode(map));
  }

  List<WaterDayEntry> getAllWaterEntries() {
    if (_prefs == null) return [];
    final map = _decodeMap(_prefs!.getString(_waterKey));
    return map.values
        .whereType<Map>()
        .map((e) => WaterDayEntry.fromMap(e))
        .toList()
      ..sort((a, b) => b.dateKey.compareTo(a.dateKey));
  }

  WaterDayEntry? getEntryForDate(String dateKey) {
    if (_prefs == null) return null;
    final map = _decodeMap(_prefs!.getString(_waterKey));
    final data = map[dateKey];
    if (data is! Map) return null;
    return WaterDayEntry.fromMap(data);
  }

  Future<WaterDayEntry> getOrCreateToday(String dateKey) async {
    final existing = getEntryForDate(dateKey);
    if (existing != null) return existing;
    final entry = WaterDayEntry(dateKey: dateKey, progressMl: 0);
    await saveWaterEntry(entry);
    return entry;
  }

  Future<void> saveWaterEntry(WaterDayEntry entry) async {
    await openBoxes();
    final map = _decodeMap(_prefs!.getString(_waterKey));
    map[entry.dateKey] = entry.toMap();
    await _encodeMap(_waterKey, map);
  }

  List<DailyCompletion> getAllCompletions() {
    if (_prefs == null) return [];
    final map = _decodeMap(_prefs!.getString(_completionKey));
    return map.values
        .whereType<Map>()
        .map((e) => DailyCompletion.fromMap(e))
        .toList()
      ..sort((a, b) => b.dateKey.compareTo(a.dateKey));
  }

  DailyCompletion? getCompletionForDate(String dateKey) {
    if (_prefs == null) return null;
    final map = _decodeMap(_prefs!.getString(_completionKey));
    final data = map[dateKey];
    if (data is! Map) return null;
    return DailyCompletion.fromMap(data);
  }

  Future<void> saveCompletion(DailyCompletion completion) async {
    await openBoxes();
    final map = _decodeMap(_prefs!.getString(_completionKey));
    map[completion.dateKey] = completion.toMap();
    await _encodeMap(_completionKey, map);
  }

  BoilerState getBoiler() {
    if (_prefs == null) {
      return BoilerState(amountMl: AppConstants.boilerCapacityMl);
    }
    final raw = _prefs!.getString(_boilerKey);
    if (raw == null) {
      return BoilerState(amountMl: AppConstants.boilerCapacityMl);
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map) return BoilerState.fromMap(decoded);
    } catch (_) {}
    return BoilerState(amountMl: AppConstants.boilerCapacityMl);
  }

  Future<void> saveBoiler(BoilerState boiler) async {
    await openBoxes();
    await _prefs!.setString(_boilerKey, jsonEncode(boiler.toMap()));
  }

  AppSettings getSettings() {
    if (_prefs == null) return AppSettings();
    final raw = _prefs!.getString(_settingsKey);
    if (raw == null) return AppSettings();
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map) return AppSettings.fromMap(decoded);
    } catch (_) {}
    return AppSettings();
  }

  Future<void> saveSettings(AppSettings settings) async {
    await openBoxes();
    await _prefs!.setString(_settingsKey, jsonEncode(settings.toMap()));
  }
}
