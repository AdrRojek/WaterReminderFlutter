// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Water Reminder';

  @override
  String get settings => 'Settings';

  @override
  String initError(String error) {
    return 'Startup error: $error';
  }

  @override
  String get goalReached => 'Nice! Goal reached';

  @override
  String remainingMl(int amount) {
    return '$amount ml left';
  }

  @override
  String recommendation(int amount) {
    return 'Suggested: $amount ml';
  }

  @override
  String get history => 'History';

  @override
  String get recentDays => 'recent days';

  @override
  String get noHistory => 'No history yet';

  @override
  String get undo => 'Undo';

  @override
  String get pastDay => 'Past day';

  @override
  String get creatine => 'Creatine';

  @override
  String get creatineTaken => 'Taken';

  @override
  String get toastCreatineOn => 'Creatine marked as taken today';

  @override
  String get toastCreatineOff => 'Creatine unmarked';

  @override
  String get toastScheduleRedistributed =>
      'Rescheduled from now until 9 PM — tomorrow back to 9 AM–9 PM';

  @override
  String get toastScheduleReset => 'Restored the standard 9 AM–9 PM schedule';

  @override
  String streakOne(int count) {
    return '$count day streak';
  }

  @override
  String streakMany(int count) {
    return '$count day streak';
  }

  @override
  String ofGoalMl(int goal) {
    return 'of $goal ml';
  }

  @override
  String boilerPortion(int amount) {
    return 'Boiler $amount ml';
  }

  @override
  String boilerRemaining(int amount) {
    return '$amount ml left';
  }

  @override
  String get refillBoiler => 'Refill boiler';

  @override
  String get refillBoilerSubtitle => 'Empty — tap to fill up';

  @override
  String get sectionGoals => 'Goals';

  @override
  String get dailyGoal => 'Daily goal';

  @override
  String get portion => 'Portion';

  @override
  String get sectionNotifications => 'Notifications';

  @override
  String get dailyReminders => 'Daily reminders';

  @override
  String get dailyRemindersSubtitle => '9:00–21:00 about every 50 min';

  @override
  String get nightNotification => 'Night notification';

  @override
  String nightNotificationSubtitle(int hour) {
    return 'At $hour:00 — tap to rebuild today’s schedule';
  }

  @override
  String get sectionSchedule => 'Schedule';

  @override
  String get rescheduleFromNow => 'Reschedule from now';

  @override
  String get rescheduleFromNowSubtitle =>
      'e.g. at 3 PM — equal 250 ml gaps until 9 PM';

  @override
  String get resetStandardDay => 'Reset to standard day';

  @override
  String get resetStandardDaySubtitle => 'Back to 9:00–21:00 ~every 50 min';

  @override
  String get sectionLanguage => 'Language';

  @override
  String get language => 'App language';

  @override
  String get languageSystem => 'System default';

  @override
  String get languageEnglish => 'English';

  @override
  String get languagePolish => 'Polish';

  @override
  String get howMuchToSubtract => 'How much to subtract?';

  @override
  String subtractMl(int amount) {
    return 'Subtract $amount ml';
  }

  @override
  String get plusBoiler => '+ boiler';

  @override
  String get resetBoiler => 'Reset boiler';

  @override
  String get resetWholeDay => 'Reset whole day';

  @override
  String get addWaterPastDay => 'Add water to a past day';

  @override
  String get pickDay => 'Pick a day';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String get change => 'Change';

  @override
  String get useBoilerYesterday => 'Use boiler (yesterday)';

  @override
  String addMl(int amount) {
    return 'Add $amount ml';
  }

  @override
  String get customAmountMl => 'Custom amount (ml)';

  @override
  String get customAmountHint => 'e.g. 333';

  @override
  String selectedAmount(String label) {
    return 'Selected: $label';
  }

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get notifDrinkTitle => 'Drink a glass of water';

  @override
  String notifGoalReached(int amount) {
    return 'Daily goal reached — $amount ml';
  }

  @override
  String notifDrinkBody(int current, int portion, String time, int toSlot) {
    return 'You have $current ml · drink $portion ml · to slot goal ($time): $toSlot ml';
  }

  @override
  String get notifChannelWater => 'Water reminders';

  @override
  String get notifChannelWaterDesc => 'Regular reminders to drink water';

  @override
  String get notifDrinkAction => 'Drank 250 ml';

  @override
  String get notifNightTitle => 'Rebuild schedule?';

  @override
  String get notifNightBody =>
      'Tap — equal gaps from now until 9 PM (tomorrow 9 AM–9 PM again)';

  @override
  String get notifChannelNight => 'Night notification';

  @override
  String get notifChannelNightDesc => 'Wake-up and schedule rebuild';

  @override
  String get notifResetTitle => 'New day';

  @override
  String get notifResetBody => 'Your water reminder schedule was refreshed';

  @override
  String get notifChannelReset => 'Schedule reset';

  @override
  String get notifChannelResetDesc => 'Daily notification refresh';

  @override
  String get notifCreatineHint => 'pair with creatine if not taken yet';

  @override
  String get notifDrinkCreatineTitle => 'Water + creatine?';

  @override
  String debtTitle(int amount) {
    return 'Behind by $amount ml';
  }

  @override
  String debtSubtitle(int portions, int portion, int minutes) {
    return 'Catch up: $portions×$portion ml every ~$minutes min until 9 PM';
  }

  @override
  String get debtAction => 'Rebuild from now';

  @override
  String get toastCatchUpApplied => 'Catch-up schedule set until 9 PM';

  @override
  String get todayTags => 'Today feels like…';

  @override
  String get todayTagsHint => 'Pace nudge only — your goal stays the same';

  @override
  String get tagHot => 'Hot day';

  @override
  String get tagTraining => 'Training';

  @override
  String get tagRoughMorning => 'Rough morning';

  @override
  String get sectionConfirm => 'Confirm drinks';

  @override
  String get confirmDrinks => 'Anti-mis-tap';

  @override
  String get confirmNone => 'Off (tap adds water)';

  @override
  String get confirmHold => 'Hold button';

  @override
  String get confirmShake => 'Shake phone';

  @override
  String get confirmBoth => 'Hold or shake';

  @override
  String get confirmHoldHint => 'Hold ~0.8s';

  @override
  String toastShakeLogged(int amount) {
    return 'Shake logged +$amount ml';
  }

  @override
  String toastHoldLogged(int amount) {
    return 'Logged +$amount ml';
  }
}
