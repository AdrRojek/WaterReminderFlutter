import '../core/constants.dart';

/// Stored locale preference: `system`, `en`, or `pl`.
class AppSettings {
  AppSettings({
    this.dailyGoalMl = AppConstants.dailyGoalMl,
    this.portionMl = AppConstants.portionMl,
    this.notificationsEnabled = true,
    this.nightNotificationEnabled = true,
    this.localeCode = 'en',
  });

  int dailyGoalMl;
  int portionMl;
  bool notificationsEnabled;
  bool nightNotificationEnabled;
  String localeCode;

  AppSettings copyWith({
    int? dailyGoalMl,
    int? portionMl,
    bool? notificationsEnabled,
    bool? nightNotificationEnabled,
    String? localeCode,
  }) {
    return AppSettings(
      dailyGoalMl: dailyGoalMl ?? this.dailyGoalMl,
      portionMl: portionMl ?? this.portionMl,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      nightNotificationEnabled:
          nightNotificationEnabled ?? this.nightNotificationEnabled,
      localeCode: localeCode ?? this.localeCode,
    );
  }

  Map<String, dynamic> toMap() => {
        'dailyGoalMl': dailyGoalMl,
        'portionMl': portionMl,
        'notificationsEnabled': notificationsEnabled,
        'nightNotificationEnabled': nightNotificationEnabled,
        'localeCode': localeCode,
      };

  factory AppSettings.fromMap(Map<dynamic, dynamic> map) => AppSettings(
        dailyGoalMl: _asInt(map['dailyGoalMl'], AppConstants.dailyGoalMl),
        portionMl: _asInt(map['portionMl'], AppConstants.portionMl),
        notificationsEnabled: map['notificationsEnabled'] != false,
        nightNotificationEnabled: map['nightNotificationEnabled'] != false,
        localeCode: _asLocaleCode(map['localeCode']),
      );
}

String _asLocaleCode(dynamic value) {
  if (value is String &&
      (value == 'en' || value == 'pl' || value == 'system')) {
    return value;
  }
  return 'en';
}

int _asInt(dynamic value, [int fallback = 0]) {
  if (value is int) return value;
  if (value is double) return value.round();
  if (value is num) return value.toInt();
  return fallback;
}
