import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../core/constants.dart';
import '../l10n/app_localizations.dart';
import 'schedule_calculator.dart';

typedef NightWakeCallback = Future<void> Function();

class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  NightWakeCallback? onNightWakeTapped;
  VoidCallback? onDrinkAction;
  NightWakeCallback? onDailyReset;

  static const _waterChannelId = 'water_reminder';
  static const _nightChannelId = 'night_wake';
  static const _resetChannelId = 'schedule_reset';
  static const _drinkActionId = 'DRINK_ACTION';
  static const _nightPayload = 'night_wake';
  static const _resetPayload = 'schedule_reset';
  static const nightPayload = _nightPayload;
  static const resetPayload = _resetPayload;

  bool _initialized = false;
  Future<void>? _initFuture;
  AppLocalizations _l10n = lookupAppLocalizations(const Locale('en'));

  void useLocalizations(AppLocalizations l10n) {
    _l10n = l10n;
  }

  Future<void> ensureInitialized() {
    return _initFuture ??= initialize();
  }

  Future<void> initialize() async {
    if (_initialized) return;

    try {
      tz_data.initializeTimeZones();
      await _configureLocalTimezone();

      const androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

      await _plugin.initialize(
        const InitializationSettings(
          android: androidSettings,
          iOS: iosSettings,
        ),
        onDidReceiveNotificationResponse: _onNotificationResponse,
      );

      if (Platform.isAndroid) {
        await _ensureAndroidChannels();
      }

      _initialized = true;
    } catch (e, st) {
      debugPrint('NotificationService.initialize failed: $e\n$st');
      _initialized = false;
      _initFuture = null;
      rethrow;
    }
  }

  Future<void> _ensureAndroidChannels() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await android?.createNotificationChannel(
      AndroidNotificationChannel(
        _waterChannelId,
        _l10n.notifChannelWater,
        description: _l10n.notifChannelWaterDesc,
        importance: Importance.high,
      ),
    );
    await android?.createNotificationChannel(
      AndroidNotificationChannel(
        _nightChannelId,
        _l10n.notifChannelNight,
        description: _l10n.notifChannelNightDesc,
        importance: Importance.high,
      ),
    );
    await android?.createNotificationChannel(
      AndroidNotificationChannel(
        _resetChannelId,
        _l10n.notifChannelReset,
        description: _l10n.notifChannelResetDesc,
        importance: Importance.low,
      ),
    );
  }

  Future<void> _configureLocalTimezone() async {
    try {
      final timezoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timezoneName));
      debugPrint('Notification timezone: $timezoneName');
      return;
    } catch (e) {
      debugPrint('flutter_timezone failed, trying Europe/Warsaw: $e');
    }

    try {
      tz.setLocalLocation(tz.getLocation('Europe/Warsaw'));
    } catch (_) {
      tz.setLocalLocation(tz.UTC);
    }
  }

  tz.TZDateTime _toZonedLocal(DateTime localTime) {
    return tz.TZDateTime(
      tz.local,
      localTime.year,
      localTime.month,
      localTime.day,
      localTime.hour,
      localTime.minute,
      localTime.second,
    );
  }

  int _notificationIdFor(ScheduledReminder reminder) {
    return reminder.slotKey.hashCode & 0x7fffffff;
  }

  String _formatTime(DateTime time) => DateFormat('HH:mm').format(time);

  Future<bool> requestPermissions() async {
    if (Platform.isIOS) {
      final ios = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      final alert = await ios?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return alert ?? false;
    }

    if (Platform.isAndroid) {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      return await android?.requestNotificationsPermission() ?? true;
    }

    return true;
  }

  Future<void> cancelAll() => _plugin.cancelAll();

  Future<NotificationAppLaunchDetails?> getLaunchDetails() =>
      _plugin.getNotificationAppLaunchDetails();

  String _buildBody(
    ScheduledReminder reminder, {
    required int currentProgressMl,
    required int dailyGoalMl,
    required bool creatineTaken,
  }) {
    if (currentProgressMl >= dailyGoalMl) {
      return _l10n.notifGoalReached(currentProgressMl);
    }

    final toSlot = reminder.cumulativeMl - currentProgressMl;
    var body = _l10n.notifDrinkBody(
      currentProgressMl,
      reminder.portionMl,
      _formatTime(reminder.time),
      toSlot,
    );

    // Creatine ritual: hint only until marked taken (morning window).
    if (!creatineTaken && reminder.time.hour < 12) {
      body = '$body · ${_l10n.notifCreatineHint}';
    }

    return body;
  }

  Future<void> scheduleReminders(
    List<ScheduledReminder> reminders, {
    bool replaceExisting = true,
    int currentProgressMl = 0,
    int dailyGoalMl = AppConstants.dailyGoalMl,
    bool creatineTaken = true,
  }) async {
    await ensureInitialized();
    if (Platform.isAndroid) {
      await _ensureAndroidChannels();
    }

    if (replaceExisting) {
      await cancelAll();
    }

    final now = DateTime.now();
    final relevant = ScheduleCalculator.filterAheadOfProgress(
      reminders,
      currentProgressMl,
      dailyGoalMl: dailyGoalMl,
    ).where((reminder) => reminder.time.isAfter(now));

    for (final reminder in relevant) {
      final body = _buildBody(
        reminder,
        currentProgressMl: currentProgressMl,
        dailyGoalMl: dailyGoalMl,
        creatineTaken: creatineTaken,
      );

      try {
        await _plugin.zonedSchedule(
          _notificationIdFor(reminder),
          creatineTaken || reminder.time.hour >= 12
              ? _l10n.notifDrinkTitle
              : _l10n.notifDrinkCreatineTitle,
          body,
          _toZonedLocal(reminder.time),
          NotificationDetails(
            android: AndroidNotificationDetails(
              _waterChannelId,
              _l10n.notifChannelWater,
              channelDescription: _l10n.notifChannelWaterDesc,
              importance: Importance.high,
              priority: Priority.high,
              actions: [
                AndroidNotificationAction(
                  _drinkActionId,
                  _l10n.notifDrinkAction,
                ),
              ],
            ),
            iOS: const DarwinNotificationDetails(
              presentAlert: true,
              presentSound: true,
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: 'water_${reminder.portionMl}',
        );
      } catch (e) {
        debugPrint('Failed to schedule ${_formatTime(reminder.time)}: $e');
      }
    }
  }

  Future<void> scheduleNightNotification(DateTime referenceDay) async {
    await ensureInitialized();

    var nightTime = DateTime(
      referenceDay.year,
      referenceDay.month,
      referenceDay.day,
      AppConstants.nightNotificationHour,
      AppConstants.nightNotificationMinute,
    );

    if (!nightTime.isAfter(DateTime.now())) {
      final nextDay = referenceDay.add(const Duration(days: 1));
      nightTime = DateTime(
        nextDay.year,
        nextDay.month,
        nextDay.day,
        AppConstants.nightNotificationHour,
        AppConstants.nightNotificationMinute,
      );
    }

    try {
      await _plugin.zonedSchedule(
        nightTime.millisecondsSinceEpoch.remainder(100000) + 42,
        _l10n.notifNightTitle,
        _l10n.notifNightBody,
        _toZonedLocal(nightTime),
        NotificationDetails(
          android: AndroidNotificationDetails(
            _nightChannelId,
            _l10n.notifChannelNight,
            channelDescription: _l10n.notifChannelNightDesc,
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: _nightPayload,
      );
    } catch (e) {
      debugPrint('Failed to schedule night notification: $e');
    }
  }

  Future<void> scheduleMidnightReset() async {
    await ensureInitialized();

    final now = DateTime.now();
    var midnight = DateTime(now.year, now.month, now.day).add(
      const Duration(days: 1),
    );

    if (!midnight.isAfter(now)) {
      midnight = midnight.add(const Duration(days: 1));
    }

    try {
      await _plugin.zonedSchedule(
        1,
        _l10n.notifResetTitle,
        _l10n.notifResetBody,
        _toZonedLocal(midnight),
        NotificationDetails(
          android: AndroidNotificationDetails(
            _resetChannelId,
            _l10n.notifChannelReset,
            channelDescription: _l10n.notifChannelResetDesc,
            importance: Importance.low,
            silent: true,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: false,
            presentSound: false,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: _resetPayload,
      );
    } catch (e) {
      debugPrint('Failed to schedule midnight reset: $e');
    }
  }

  void _onNotificationResponse(NotificationResponse response) {
    if (response.payload == _resetPayload) {
      onDailyReset?.call();
      return;
    }

    if (response.actionId == _drinkActionId ||
        response.payload?.startsWith('water_') == true) {
      onDrinkAction?.call();
      return;
    }

    if (response.payload == _nightPayload) {
      onNightWakeTapped?.call();
    }
  }
}
