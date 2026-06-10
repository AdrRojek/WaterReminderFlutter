import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'schedule_calculator.dart';

typedef NightWakeCallback = Future<void> Function();

class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  NightWakeCallback? onNightWakeTapped;
  VoidCallback? onDrinkAction;

  static const _waterChannelId = 'water_reminder';
  static const _nightChannelId = 'night_wake';
  static const _drinkActionId = 'DRINK_ACTION';
  static const _nightPayload = 'night_wake';
  static const nightPayload = _nightPayload;

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Warsaw'));

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
      final android =
          _plugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await android?.createNotificationChannel(
        const AndroidNotificationChannel(
          _waterChannelId,
          'Przypomnienia o wodzie',
          description: 'Regularne przypomnienia o piciu wody',
          importance: Importance.high,
        ),
      );
      await android?.createNotificationChannel(
        const AndroidNotificationChannel(
          _nightChannelId,
          'Powiadomienie nocne',
          description: 'Budzenie i przeliczanie harmonogramu',
          importance: Importance.high,
        ),
      );
    }

    _initialized = true;
  }

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

  Future<void> scheduleReminders(
    List<ScheduledReminder> reminders, {
    bool replaceExisting = true,
  }) async {
    if (replaceExisting) {
      await cancelAll();
    }

    for (var i = 0; i < reminders.length; i++) {
      final reminder = reminders[i];
      if (reminder.time.isBefore(DateTime.now())) continue;

      await _plugin.zonedSchedule(
        1000 + i,
        'Wypij szklankę wody',
        'Do wypicia: ${reminder.portionMl} ml | '
            'Powinieneś już wypić: ${reminder.cumulativeMl.clamp(0, 99999)} ml',
        tz.TZDateTime.from(reminder.time, tz.local),
        NotificationDetails(
          android: AndroidNotificationDetails(
            _waterChannelId,
            'Przypomnienia o wodzie',
            channelDescription: 'Regularne przypomnienia o piciu wody',
            importance: Importance.high,
            priority: Priority.high,
            actions: const [
              AndroidNotificationAction(
                _drinkActionId,
                'Wypito 250 ml',
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
    }
  }

  Future<void> scheduleNightNotification(DateTime day) async {
    final nightTime = DateTime(
      day.year,
      day.month,
      day.day,
      2,
      0,
    );

    if (nightTime.isBefore(DateTime.now())) return;

    await _plugin.zonedSchedule(
      42,
      'Obudziłeś się w nocy?',
      'Kliknij, aby przeliczyć harmonogram picia wody na resztę dnia',
      tz.TZDateTime.from(nightTime, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          _nightChannelId,
          'Powiadomienie nocne',
          channelDescription: 'Budzenie i przeliczanie harmonogramu',
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
  }

  void _onNotificationResponse(NotificationResponse response) {
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
