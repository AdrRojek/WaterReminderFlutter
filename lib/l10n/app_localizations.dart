import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pl'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Water Reminder'**
  String get appTitle;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @initError.
  ///
  /// In en, this message translates to:
  /// **'Startup error: {error}'**
  String initError(String error);

  /// No description provided for @goalReached.
  ///
  /// In en, this message translates to:
  /// **'Nice! Goal reached'**
  String get goalReached;

  /// No description provided for @remainingMl.
  ///
  /// In en, this message translates to:
  /// **'{amount} ml left'**
  String remainingMl(int amount);

  /// No description provided for @recommendation.
  ///
  /// In en, this message translates to:
  /// **'Suggested: {amount} ml'**
  String recommendation(int amount);

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @recentDays.
  ///
  /// In en, this message translates to:
  /// **'recent days'**
  String get recentDays;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'No history yet'**
  String get noHistory;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @pastDay.
  ///
  /// In en, this message translates to:
  /// **'Past day'**
  String get pastDay;

  /// No description provided for @creatine.
  ///
  /// In en, this message translates to:
  /// **'Creatine'**
  String get creatine;

  /// No description provided for @creatineTaken.
  ///
  /// In en, this message translates to:
  /// **'Taken'**
  String get creatineTaken;

  /// No description provided for @toastCreatineOn.
  ///
  /// In en, this message translates to:
  /// **'Creatine marked as taken today'**
  String get toastCreatineOn;

  /// No description provided for @toastCreatineOff.
  ///
  /// In en, this message translates to:
  /// **'Creatine unmarked'**
  String get toastCreatineOff;

  /// No description provided for @toastScheduleRedistributed.
  ///
  /// In en, this message translates to:
  /// **'Rescheduled from now until 9 PM — tomorrow back to 9 AM–9 PM'**
  String get toastScheduleRedistributed;

  /// No description provided for @toastScheduleReset.
  ///
  /// In en, this message translates to:
  /// **'Restored the standard 9 AM–9 PM schedule'**
  String get toastScheduleReset;

  /// No description provided for @streakOne.
  ///
  /// In en, this message translates to:
  /// **'{count} day streak'**
  String streakOne(int count);

  /// No description provided for @streakMany.
  ///
  /// In en, this message translates to:
  /// **'{count} day streak'**
  String streakMany(int count);

  /// No description provided for @ofGoalMl.
  ///
  /// In en, this message translates to:
  /// **'of {goal} ml'**
  String ofGoalMl(int goal);

  /// No description provided for @boilerPortion.
  ///
  /// In en, this message translates to:
  /// **'Boiler {amount} ml'**
  String boilerPortion(int amount);

  /// No description provided for @boilerRemaining.
  ///
  /// In en, this message translates to:
  /// **'{amount} ml left'**
  String boilerRemaining(int amount);

  /// No description provided for @refillBoiler.
  ///
  /// In en, this message translates to:
  /// **'Refill boiler'**
  String get refillBoiler;

  /// No description provided for @refillBoilerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Empty — tap to fill up'**
  String get refillBoilerSubtitle;

  /// No description provided for @sectionGoals.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get sectionGoals;

  /// No description provided for @dailyGoal.
  ///
  /// In en, this message translates to:
  /// **'Daily goal'**
  String get dailyGoal;

  /// No description provided for @portion.
  ///
  /// In en, this message translates to:
  /// **'Portion'**
  String get portion;

  /// No description provided for @sectionNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get sectionNotifications;

  /// No description provided for @dailyReminders.
  ///
  /// In en, this message translates to:
  /// **'Daily reminders'**
  String get dailyReminders;

  /// No description provided for @dailyRemindersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'9:00–21:00 about every 50 min'**
  String get dailyRemindersSubtitle;

  /// No description provided for @nightNotification.
  ///
  /// In en, this message translates to:
  /// **'Night notification'**
  String get nightNotification;

  /// No description provided for @nightNotificationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'At {hour}:00 — tap to rebuild today’s schedule'**
  String nightNotificationSubtitle(int hour);

  /// No description provided for @sectionSchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get sectionSchedule;

  /// No description provided for @rescheduleFromNow.
  ///
  /// In en, this message translates to:
  /// **'Reschedule from now'**
  String get rescheduleFromNow;

  /// No description provided for @rescheduleFromNowSubtitle.
  ///
  /// In en, this message translates to:
  /// **'e.g. at 3 PM — equal 250 ml gaps until 9 PM'**
  String get rescheduleFromNowSubtitle;

  /// No description provided for @resetStandardDay.
  ///
  /// In en, this message translates to:
  /// **'Reset to standard day'**
  String get resetStandardDay;

  /// No description provided for @resetStandardDaySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Back to 9:00–21:00 ~every 50 min'**
  String get resetStandardDaySubtitle;

  /// No description provided for @sectionLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get sectionLanguage;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystem;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languagePolish.
  ///
  /// In en, this message translates to:
  /// **'Polish'**
  String get languagePolish;

  /// No description provided for @howMuchToSubtract.
  ///
  /// In en, this message translates to:
  /// **'How much to subtract?'**
  String get howMuchToSubtract;

  /// No description provided for @subtractMl.
  ///
  /// In en, this message translates to:
  /// **'Subtract {amount} ml'**
  String subtractMl(int amount);

  /// No description provided for @plusBoiler.
  ///
  /// In en, this message translates to:
  /// **'+ boiler'**
  String get plusBoiler;

  /// No description provided for @resetBoiler.
  ///
  /// In en, this message translates to:
  /// **'Reset boiler'**
  String get resetBoiler;

  /// No description provided for @resetWholeDay.
  ///
  /// In en, this message translates to:
  /// **'Reset whole day'**
  String get resetWholeDay;

  /// No description provided for @addWaterPastDay.
  ///
  /// In en, this message translates to:
  /// **'Add water to a past day'**
  String get addWaterPastDay;

  /// No description provided for @pickDay.
  ///
  /// In en, this message translates to:
  /// **'Pick a day'**
  String get pickDay;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @useBoilerYesterday.
  ///
  /// In en, this message translates to:
  /// **'Use boiler (yesterday)'**
  String get useBoilerYesterday;

  /// No description provided for @addMl.
  ///
  /// In en, this message translates to:
  /// **'Add {amount} ml'**
  String addMl(int amount);

  /// No description provided for @customAmountMl.
  ///
  /// In en, this message translates to:
  /// **'Custom amount (ml)'**
  String get customAmountMl;

  /// No description provided for @customAmountHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 333'**
  String get customAmountHint;

  /// No description provided for @selectedAmount.
  ///
  /// In en, this message translates to:
  /// **'Selected: {label}'**
  String selectedAmount(String label);

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @notifDrinkTitle.
  ///
  /// In en, this message translates to:
  /// **'Drink a glass of water'**
  String get notifDrinkTitle;

  /// No description provided for @notifGoalReached.
  ///
  /// In en, this message translates to:
  /// **'Daily goal reached — {amount} ml'**
  String notifGoalReached(int amount);

  /// No description provided for @notifDrinkBody.
  ///
  /// In en, this message translates to:
  /// **'You have {current} ml · drink {portion} ml · to slot goal ({time}): {toSlot} ml'**
  String notifDrinkBody(int current, int portion, String time, int toSlot);

  /// No description provided for @notifChannelWater.
  ///
  /// In en, this message translates to:
  /// **'Water reminders'**
  String get notifChannelWater;

  /// No description provided for @notifChannelWaterDesc.
  ///
  /// In en, this message translates to:
  /// **'Regular reminders to drink water'**
  String get notifChannelWaterDesc;

  /// No description provided for @notifDrinkAction.
  ///
  /// In en, this message translates to:
  /// **'Drank 250 ml'**
  String get notifDrinkAction;

  /// No description provided for @notifNightTitle.
  ///
  /// In en, this message translates to:
  /// **'Rebuild schedule?'**
  String get notifNightTitle;

  /// No description provided for @notifNightBody.
  ///
  /// In en, this message translates to:
  /// **'Tap — equal gaps from now until 9 PM (tomorrow 9 AM–9 PM again)'**
  String get notifNightBody;

  /// No description provided for @notifChannelNight.
  ///
  /// In en, this message translates to:
  /// **'Night notification'**
  String get notifChannelNight;

  /// No description provided for @notifChannelNightDesc.
  ///
  /// In en, this message translates to:
  /// **'Wake-up and schedule rebuild'**
  String get notifChannelNightDesc;

  /// No description provided for @notifResetTitle.
  ///
  /// In en, this message translates to:
  /// **'New day'**
  String get notifResetTitle;

  /// No description provided for @notifResetBody.
  ///
  /// In en, this message translates to:
  /// **'Your water reminder schedule was refreshed'**
  String get notifResetBody;

  /// No description provided for @notifChannelReset.
  ///
  /// In en, this message translates to:
  /// **'Schedule reset'**
  String get notifChannelReset;

  /// No description provided for @notifChannelResetDesc.
  ///
  /// In en, this message translates to:
  /// **'Daily notification refresh'**
  String get notifChannelResetDesc;

  /// No description provided for @notifCreatineHint.
  ///
  /// In en, this message translates to:
  /// **'pair with creatine if not taken yet'**
  String get notifCreatineHint;

  /// No description provided for @notifDrinkCreatineTitle.
  ///
  /// In en, this message translates to:
  /// **'Water + creatine?'**
  String get notifDrinkCreatineTitle;

  /// No description provided for @debtTitle.
  ///
  /// In en, this message translates to:
  /// **'Behind by {amount} ml'**
  String debtTitle(int amount);

  /// No description provided for @debtSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Catch up: {portions}×{portion} ml every ~{minutes} min until 9 PM'**
  String debtSubtitle(int portions, int portion, int minutes);

  /// No description provided for @debtAction.
  ///
  /// In en, this message translates to:
  /// **'Rebuild from now'**
  String get debtAction;

  /// No description provided for @toastCatchUpApplied.
  ///
  /// In en, this message translates to:
  /// **'Catch-up schedule set until 9 PM'**
  String get toastCatchUpApplied;

  /// No description provided for @todayTags.
  ///
  /// In en, this message translates to:
  /// **'Today feels like…'**
  String get todayTags;

  /// No description provided for @todayTagsHint.
  ///
  /// In en, this message translates to:
  /// **'Pace nudge only — your goal stays the same'**
  String get todayTagsHint;

  /// No description provided for @tagHot.
  ///
  /// In en, this message translates to:
  /// **'Hot day'**
  String get tagHot;

  /// No description provided for @tagTraining.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get tagTraining;

  /// No description provided for @tagRoughMorning.
  ///
  /// In en, this message translates to:
  /// **'Rough morning'**
  String get tagRoughMorning;

  /// No description provided for @sectionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm drinks'**
  String get sectionConfirm;

  /// No description provided for @confirmDrinks.
  ///
  /// In en, this message translates to:
  /// **'Anti-mis-tap'**
  String get confirmDrinks;

  /// No description provided for @confirmNone.
  ///
  /// In en, this message translates to:
  /// **'Off (tap adds water)'**
  String get confirmNone;

  /// No description provided for @confirmHold.
  ///
  /// In en, this message translates to:
  /// **'Hold button'**
  String get confirmHold;

  /// No description provided for @confirmShake.
  ///
  /// In en, this message translates to:
  /// **'Shake phone'**
  String get confirmShake;

  /// No description provided for @confirmBoth.
  ///
  /// In en, this message translates to:
  /// **'Hold or shake'**
  String get confirmBoth;

  /// No description provided for @confirmHoldHint.
  ///
  /// In en, this message translates to:
  /// **'Hold ~0.8s'**
  String get confirmHoldHint;

  /// No description provided for @toastShakeLogged.
  ///
  /// In en, this message translates to:
  /// **'Shake logged +{amount} ml'**
  String toastShakeLogged(int amount);

  /// No description provided for @toastHoldLogged.
  ///
  /// In en, this message translates to:
  /// **'Logged +{amount} ml'**
  String toastHoldLogged(int amount);

  /// No description provided for @notifBoilerAction.
  ///
  /// In en, this message translates to:
  /// **'From boiler'**
  String get notifBoilerAction;

  /// No description provided for @notifSnoozeAction.
  ///
  /// In en, this message translates to:
  /// **'Quiet 20 min'**
  String get notifSnoozeAction;

  /// No description provided for @notifSnoozeTitle.
  ///
  /// In en, this message translates to:
  /// **'Snoozed sip'**
  String get notifSnoozeTitle;

  /// No description provided for @useAmnesty.
  ///
  /// In en, this message translates to:
  /// **'Use monthly amnesty (50%+)'**
  String get useAmnesty;

  /// No description provided for @amnestyUsedBadge.
  ///
  /// In en, this message translates to:
  /// **'Amnesty'**
  String get amnestyUsedBadge;

  /// No description provided for @amnestyHint.
  ///
  /// In en, this message translates to:
  /// **'1 soft day / month at ≥50% keeps your streak'**
  String get amnestyHint;

  /// No description provided for @toastAmnestyUsed.
  ///
  /// In en, this message translates to:
  /// **'Amnesty used — streak safe this month'**
  String get toastAmnestyUsed;

  /// No description provided for @toastAmnestyUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Amnesty needs ≥50% and one use per month'**
  String get toastAmnestyUnavailable;

  /// No description provided for @snoozeNextSlot.
  ///
  /// In en, this message translates to:
  /// **'Quiet next slot (20 min)'**
  String get snoozeNextSlot;

  /// No description provided for @toastSnoozeOk.
  ///
  /// In en, this message translates to:
  /// **'Next reminder shifted +20 min'**
  String get toastSnoozeOk;

  /// No description provided for @toastSnoozeFail.
  ///
  /// In en, this message translates to:
  /// **'Nothing left to snooze today'**
  String get toastSnoozeFail;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pl':
      return AppLocalizationsPl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
