import '../core/constants.dart';

/// Stored locale preference: `system`, `en`, or `pl`.
/// confirmDrinkMode: `none` | `hold` | `shake` | `both`.
class AppSettings {
  AppSettings({
    this.dailyGoalMl = AppConstants.dailyGoalMl,
    this.portionMl = AppConstants.portionMl,
    this.notificationsEnabled = true,
    this.nightNotificationEnabled = true,
    this.localeCode = 'en',
    this.confirmDrinkMode = 'both',
  });

  int dailyGoalMl;
  int portionMl;
  bool notificationsEnabled;
  bool nightNotificationEnabled;
  String localeCode;
  String confirmDrinkMode;

  bool get confirmHold =>
      confirmDrinkMode == 'hold' || confirmDrinkMode == 'both';
  bool get confirmShake =>
      confirmDrinkMode == 'shake' || confirmDrinkMode == 'both';

  AppSettings copyWith({
    int? dailyGoalMl,
    int? portionMl,
    bool? notificationsEnabled,
    bool? nightNotificationEnabled,
    String? localeCode,
    String? confirmDrinkMode,
  }) {
    return AppSettings(
      dailyGoalMl: dailyGoalMl ?? this.dailyGoalMl,
      portionMl: portionMl ?? this.portionMl,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      nightNotificationEnabled:
          nightNotificationEnabled ?? this.nightNotificationEnabled,
      localeCode: localeCode ?? this.localeCode,
      confirmDrinkMode: confirmDrinkMode ?? this.confirmDrinkMode,
    );
  }

  Map<String, dynamic> toMap() => {
        'dailyGoalMl': dailyGoalMl,
        'portionMl': portionMl,
        'notificationsEnabled': notificationsEnabled,
        'nightNotificationEnabled': nightNotificationEnabled,
        'localeCode': localeCode,
        'confirmDrinkMode': confirmDrinkMode,
      };

  factory AppSettings.fromMap(Map<dynamic, dynamic> map) => AppSettings(
        dailyGoalMl: _asInt(map['dailyGoalMl'], AppConstants.dailyGoalMl),
        portionMl: _asInt(map['portionMl'], AppConstants.portionMl),
        notificationsEnabled: map['notificationsEnabled'] != false,
        nightNotificationEnabled: map['nightNotificationEnabled'] != false,
        localeCode: _asLocaleCode(map['localeCode']),
        confirmDrinkMode: _asConfirmMode(map['confirmDrinkMode']),
      );
}

String _asConfirmMode(dynamic value) {
  if (value is String &&
      (value == 'none' ||
          value == 'hold' ||
          value == 'shake' ||
          value == 'both')) {
    return value;
  }
  return 'both';
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
