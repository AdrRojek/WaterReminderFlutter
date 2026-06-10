import '../core/constants.dart';

class AppSettings {
  AppSettings({
    this.dailyGoalMl = AppConstants.dailyGoalMl,
    this.portionMl = AppConstants.portionMl,
    this.notificationsEnabled = true,
    this.nightNotificationEnabled = true,
  });

  int dailyGoalMl;
  int portionMl;
  bool notificationsEnabled;
  bool nightNotificationEnabled;

  Map<String, dynamic> toMap() => {
        'dailyGoalMl': dailyGoalMl,
        'portionMl': portionMl,
        'notificationsEnabled': notificationsEnabled,
        'nightNotificationEnabled': nightNotificationEnabled,
      };

  factory AppSettings.fromMap(Map<dynamic, dynamic> map) => AppSettings(
        dailyGoalMl:
            map['dailyGoalMl'] as int? ?? AppConstants.dailyGoalMl,
        portionMl: map['portionMl'] as int? ?? AppConstants.portionMl,
        notificationsEnabled: map['notificationsEnabled'] as bool? ?? true,
        nightNotificationEnabled:
            map['nightNotificationEnabled'] as bool? ?? true,
      );
}
