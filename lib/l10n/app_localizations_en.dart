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
  String get todayTagsHint =>
      'Doesn’t raise your liter goal. Makes the “behind schedule” card appear sooner (hot +250, training +500, rough morning +250 ml of pace pressure).';

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

  @override
  String get notifBoilerAction => 'From boiler';

  @override
  String get notifSnoozeAction => 'Quiet 20 min';

  @override
  String get notifSnoozeTitle => 'Snoozed sip';

  @override
  String get amnestyUsedBadge => 'Amnesty';

  @override
  String get amnestyHint =>
      'Auto: 1 soft day / month at ≥50% keeps your streak';

  @override
  String get amnestyAutoUsed => 'Amnesty auto-applied this month (≥50% day)';

  @override
  String get snoozeNextSlot => 'Quiet next slot (20 min)';

  @override
  String get toastSnoozeOk => 'Next reminder shifted +20 min';

  @override
  String get toastSnoozeFail => 'Nothing left to snooze today';

  @override
  String get sectionRewards => 'Rewards';

  @override
  String get rewardsHint => 'Cosmetic unlocks — no XP, no paywall';

  @override
  String rewardsProgress(int confirms, int catchUps, int streak) {
    return 'Confirms $confirms · catch-ups $catchUps · best streak $streak';
  }

  @override
  String get rewardStreak7Title => 'Golden drop';

  @override
  String get rewardStreak7Desc => '7-day streak — gold ring on the logo';

  @override
  String get rewardStreak14Title => 'Deep ocean';

  @override
  String get rewardStreak14Desc => '14-day streak — darker background';

  @override
  String get rewardStreak30Title => 'Living ring';

  @override
  String get rewardStreak30Desc =>
      '30-day streak — slow animated progress ring';

  @override
  String get rewardCatchUpTitle => 'Comeback kid';

  @override
  String get rewardCatchUpDesc => 'First catch-up rebuild of the day';

  @override
  String get rewardConfirms50Title => 'Steady hands';

  @override
  String get rewardConfirms50Desc => '50 hold/shake confirms';

  @override
  String get rewardConfirms100Title => 'Solid sipper';

  @override
  String get rewardConfirms100Desc => '100 confirms — title on your streak';

  @override
  String get rewardGoal3Title => 'Aurora glow';

  @override
  String get rewardGoal3Desc => '3 full-goal days in a row (no amnesty)';

  @override
  String get rewardIronTitle => 'Iron month';

  @override
  String get rewardIronDesc => 'Previous month ≥70% full goals, no amnesty';

  @override
  String get rewardTitleSolidSipper => 'Solid sipper';

  @override
  String toastRewardUnlocked(String title) {
    return 'Unlocked: $title';
  }

  @override
  String get sectionAdjust => 'Adjust';

  @override
  String get undoWater => 'Undo / adjust water';

  @override
  String get undoWaterSubtitle => 'Subtract, return to boiler, or reset today';

  @override
  String get pastDaySettings => 'Add water to a past day';

  @override
  String get pastDaySettingsSubtitle => 'Backfill yesterday or any earlier day';

  @override
  String get openRewards => 'Rewards & unlocks';

  @override
  String get openRewardsSubtitle => 'Cosmetics you’ve earned';

  @override
  String get creatineTapHint => 'Tap to mark';

  @override
  String get testNotification => 'Test notification (in 1 min)';

  @override
  String get testNotificationSubtitle =>
      'Dev hidden — schedules a sample reminder';

  @override
  String get toastTestNotification => 'Test notification in ~1 minute';

  @override
  String get notifTestBody =>
      'Test ping — actions: water / boiler / quiet 20 min';
}
