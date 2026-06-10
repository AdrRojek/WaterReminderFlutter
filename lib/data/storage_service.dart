import 'package:hive_flutter/hive_flutter.dart';

import '../core/constants.dart';
import '../models/app_settings.dart';
import '../models/boiler_state.dart';
import '../models/daily_completion.dart';
import '../models/water_day_entry.dart';

class StorageService {
  StorageService._();
  static final instance = StorageService._();

  Box<Map>? _waterBox;
  Box<Map>? _completionBox;
  Box<Map>? _boilerBox;
  Box<Map>? _settingsBox;

  Future<void> openBoxes() async {
    _waterBox ??= await Hive.openBox<Map>(AppConstants.waterBoxName);
    _completionBox ??=
        await Hive.openBox<Map>(AppConstants.completionBoxName);
    _boilerBox ??= await Hive.openBox<Map>(AppConstants.boilerBoxName);
    _settingsBox ??= await Hive.openBox<Map>(AppConstants.settingsBoxName);
  }

  List<WaterDayEntry> getAllWaterEntries() {
    return _waterBox!.values
        .map((e) => WaterDayEntry.fromMap(e))
        .toList()
      ..sort((a, b) => b.dateKey.compareTo(a.dateKey));
  }

  WaterDayEntry? getEntryForDate(String dateKey) {
    final data = _waterBox!.get(dateKey);
    if (data == null) return null;
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
    await _waterBox!.put(entry.dateKey, entry.toMap());
  }

  List<DailyCompletion> getAllCompletions() {
    return _completionBox!.values
        .map((e) => DailyCompletion.fromMap(e))
        .toList()
      ..sort((a, b) => b.dateKey.compareTo(a.dateKey));
  }

  DailyCompletion? getCompletionForDate(String dateKey) {
    final data = _completionBox!.get(dateKey);
    if (data == null) return null;
    return DailyCompletion.fromMap(data);
  }

  Future<void> saveCompletion(DailyCompletion completion) async {
    await _completionBox!.put(completion.dateKey, completion.toMap());
  }

  BoilerState getBoiler() {
    final data = _boilerBox!.get('state');
    if (data == null) {
      return BoilerState(amountMl: AppConstants.boilerCapacityMl);
    }
    return BoilerState.fromMap(data);
  }

  Future<void> saveBoiler(BoilerState boiler) async {
    await _boilerBox!.put('state', boiler.toMap());
  }

  AppSettings getSettings() {
    final data = _settingsBox!.get('settings');
    if (data == null) return AppSettings();
    return AppSettings.fromMap(data);
  }

  Future<void> saveSettings(AppSettings settings) async {
    await _settingsBox!.put('settings', settings.toMap());
  }
}
