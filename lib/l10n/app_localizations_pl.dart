// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Water Reminder';

  @override
  String get settings => 'Ustawienia';

  @override
  String initError(String error) {
    return 'Błąd inicjalizacji: $error';
  }

  @override
  String get goalReached => 'Świetnie! Cel osiągnięty';

  @override
  String remainingMl(int amount) {
    return 'Zostało $amount ml';
  }

  @override
  String recommendation(int amount) {
    return 'Rekomendacja: $amount ml';
  }

  @override
  String get history => 'Historia';

  @override
  String get recentDays => 'ostatnie dni';

  @override
  String get noHistory => 'Brak historii';

  @override
  String get undo => 'Cofnij';

  @override
  String get pastDay => 'Poprzedni dzień';

  @override
  String get creatine => 'Kreatyna';

  @override
  String get creatineTaken => 'Wzięta';

  @override
  String get toastCreatineOn => 'Oznaczono: kreatyna wzięta dziś';

  @override
  String get toastCreatineOff => 'Odznaczono kreatynę';

  @override
  String get toastScheduleRedistributed =>
      'Przeliczono od teraz do 21:00 — jutro znów 9:00–21:00';

  @override
  String get toastScheduleReset => 'Przywrócono harmonogram 9:00–21:00';

  @override
  String streakOne(int count) {
    return '$count dzień z rzędu';
  }

  @override
  String streakMany(int count) {
    return '$count dni z rzędu';
  }

  @override
  String ofGoalMl(int goal) {
    return 'z $goal ml';
  }

  @override
  String boilerPortion(int amount) {
    return 'Bojler $amount ml';
  }

  @override
  String boilerRemaining(int amount) {
    return 'Pozostało $amount ml';
  }

  @override
  String get refillBoiler => 'Uzupełnij bojler';

  @override
  String get refillBoilerSubtitle => 'Pusty — naciśnij, aby napełnić';

  @override
  String get sectionGoals => 'Cele';

  @override
  String get dailyGoal => 'Dzienny cel';

  @override
  String get portion => 'Porcja';

  @override
  String get sectionNotifications => 'Powiadomienia';

  @override
  String get dailyReminders => 'Przypomnienia dzienne';

  @override
  String get dailyRemindersSubtitle => '9:00–21:00 co ~50 min';

  @override
  String get nightNotification => 'Powiadomienie nocne';

  @override
  String nightNotificationSubtitle(int hour) {
    return 'O $hour:00 — przelicza harmonogram po kliknięciu';
  }

  @override
  String get sectionSchedule => 'Harmonogram';

  @override
  String get rescheduleFromNow => 'Przelicz od teraz';

  @override
  String get rescheduleFromNowSubtitle =>
      'Np. o 15:00 — równe odstępy 250 ml do 21:00';

  @override
  String get resetStandardDay => 'Reset na standardowy dzień';

  @override
  String get resetStandardDaySubtitle => 'Wraca do 9:00–21:00 co ~50 min';

  @override
  String get sectionLanguage => 'Język';

  @override
  String get language => 'Język aplikacji';

  @override
  String get languageSystem => 'Jak w systemie';

  @override
  String get languageEnglish => 'Angielski';

  @override
  String get languagePolish => 'Polski';

  @override
  String get howMuchToSubtract => 'Ile chcesz odjąć?';

  @override
  String subtractMl(int amount) {
    return 'Odejmij $amount ml';
  }

  @override
  String get plusBoiler => '+ bojler';

  @override
  String get resetBoiler => 'Reset bojlera';

  @override
  String get resetWholeDay => 'Resetuj cały dzień';

  @override
  String get addWaterPastDay => 'Dodaj wodę do poprzedniego dnia';

  @override
  String get pickDay => 'Wybierz dzień';

  @override
  String get cancel => 'Anuluj';

  @override
  String get ok => 'OK';

  @override
  String get change => 'Zmień';

  @override
  String get useBoilerYesterday => 'Użyj bojlera (wczoraj)';

  @override
  String addMl(int amount) {
    return 'Dodaj $amount ml';
  }

  @override
  String get customAmountMl => 'Własna ilość (ml)';

  @override
  String get customAmountHint => 'np. 333';

  @override
  String selectedAmount(String label) {
    return 'Wybrano: $label';
  }

  @override
  String get today => 'Dziś';

  @override
  String get yesterday => 'Wczoraj';

  @override
  String get notifDrinkTitle => 'Wypij szklankę wody';

  @override
  String notifGoalReached(int amount) {
    return 'Cel dzienny osiągnięty — $amount ml';
  }

  @override
  String notifDrinkBody(int current, int portion, String time, int toSlot) {
    return 'Masz $current ml · wypij $portion ml · do celu slotu ($time): $toSlot ml';
  }

  @override
  String get notifChannelWater => 'Przypomnienia o wodzie';

  @override
  String get notifChannelWaterDesc => 'Regularne przypomnienia o piciu wody';

  @override
  String get notifDrinkAction => 'Wypito 250 ml';

  @override
  String get notifNightTitle => 'Przelicz harmonogram?';

  @override
  String get notifNightBody =>
      'Kliknij — równe odstępy od teraz do 21:00 (jutro znów 9:00–21:00)';

  @override
  String get notifChannelNight => 'Powiadomienie nocne';

  @override
  String get notifChannelNightDesc => 'Budzenie i przeliczanie harmonogramu';

  @override
  String get notifResetTitle => 'Nowy dzień';

  @override
  String get notifResetBody => 'Harmonogram picia wody został odświeżony';

  @override
  String get notifChannelReset => 'Reset harmonogramu';

  @override
  String get notifChannelResetDesc => 'Codzienne odświeżenie powiadomień';

  @override
  String get notifCreatineHint => 'połącz z kreatyną, jeśli jeszcze nie wzięta';

  @override
  String get notifDrinkCreatineTitle => 'Woda + kreatyna?';

  @override
  String debtTitle(int amount) {
    return 'Jesteś $amount ml w tyle';
  }

  @override
  String debtSubtitle(int portions, int portion, int minutes) {
    return 'Dogonienie: $portions×$portion ml co ~$minutes min do 21:00';
  }

  @override
  String get debtAction => 'Przelicz od teraz';

  @override
  String get toastCatchUpApplied => 'Ustawiono doganianie do 21:00';

  @override
  String get todayTags => 'Dziś jest raczej…';

  @override
  String get todayTagsHint =>
      'Nie podbija celu w litrach. Przyspiesza kartę „jesteś w tyle” (gorąco +250, trening +500, ciężki start +250 ml „presji tempa”).';

  @override
  String get tagHot => 'Gorąco';

  @override
  String get tagTraining => 'Trening';

  @override
  String get tagRoughMorning => 'Ciężki start';

  @override
  String get sectionConfirm => 'Potwierdzanie';

  @override
  String get confirmDrinks => 'Anti-przypadkowy tap';

  @override
  String get confirmNone => 'Wyłączone (tap dodaje)';

  @override
  String get confirmHold => 'Przytrzymaj przycisk';

  @override
  String get confirmShake => 'Potrząśnij telefonem';

  @override
  String get confirmBoth => 'Hold albo shake';

  @override
  String get confirmHoldHint => 'Przytrzymaj ~0,8 s';

  @override
  String toastShakeLogged(int amount) {
    return 'Shake: +$amount ml';
  }

  @override
  String toastHoldLogged(int amount) {
    return 'Zapisano +$amount ml';
  }

  @override
  String get notifBoilerAction => 'Z bojlera';

  @override
  String get notifSnoozeAction => 'Cicho 20 min';

  @override
  String get notifSnoozeTitle => 'Przesunięty łyk';

  @override
  String get amnestyUsedBadge => 'Amnestia';

  @override
  String get amnestyHint =>
      'Auto: 1 miękki dzień / miesiąc przy ≥50% chroni streak';

  @override
  String get amnestyAutoUsed =>
      'Amnestia użyta auto w tym miesiącu (dzień ≥50%)';

  @override
  String get snoozeNextSlot => 'Cichy slot (+20 min)';

  @override
  String get toastSnoozeOk => 'Następne przypomnienie za +20 min';

  @override
  String get toastSnoozeFail => 'Nie ma już slotu do przesunięcia';

  @override
  String get sectionRewards => 'Nagrody';

  @override
  String get rewardsHint => 'Odblokowania kosmetyczne — bez XP i paywalla';

  @override
  String rewardsProgress(int confirms, int catchUps, int streak) {
    return 'Potwierdzenia $confirms · dogonienia $catchUps · najlepszy streak $streak';
  }

  @override
  String get rewardStreak7Title => 'Złota kropla';

  @override
  String get rewardStreak7Desc => '7 dni streak — złota obręcz na logo';

  @override
  String get rewardStreak14Title => 'Głęboki ocean';

  @override
  String get rewardStreak14Desc => '14 dni streak — ciemniejsze tło';

  @override
  String get rewardStreak30Title => 'Żywy ring';

  @override
  String get rewardStreak30Desc => '30 dni streak — wolna animacja pierścienia';

  @override
  String get rewardCatchUpTitle => 'Comeback';

  @override
  String get rewardCatchUpDesc => 'Pierwsze dogonienie harmonogramu';

  @override
  String get rewardConfirms50Title => 'Spokojna ręka';

  @override
  String get rewardConfirms50Desc => '50 potwierdzeń hold/shake';

  @override
  String get rewardConfirms100Title => 'Solid sipper';

  @override
  String get rewardConfirms100Desc => '100 potwierdzeń — tytuł przy streaku';

  @override
  String get rewardGoal3Title => 'Aurora';

  @override
  String get rewardGoal3Desc => '3 pełne cele z rzędu (bez amnestii)';

  @override
  String get rewardIronTitle => 'Iron month';

  @override
  String get rewardIronDesc =>
      'Poprzedni miesiąc ≥70% pełnych celów, bez amnestii';

  @override
  String get rewardTitleSolidSipper => 'Solid sipper';

  @override
  String toastRewardUnlocked(String title) {
    return 'Odblokowano: $title';
  }

  @override
  String get sectionAdjust => 'Korekty';

  @override
  String get undoWater => 'Cofnij / popraw wodę';

  @override
  String get undoWaterSubtitle =>
      'Odejmij, wróć do bojlera albo zresetuj dzień';

  @override
  String get pastDaySettings => 'Dodaj wodę do poprzedniego dnia';

  @override
  String get pastDaySettingsSubtitle =>
      'Uzupełnij wczoraj lub dowolny wcześniejszy dzień';

  @override
  String get openRewards => 'Nagrody i odblokowania';

  @override
  String get openRewardsSubtitle => 'Kosmetyki, które zdobyłeś';

  @override
  String get creatineTapHint => 'Kliknij, aby oznaczyć';

  @override
  String get testNotification => 'Test powiadomienia (za 1 min)';

  @override
  String get testNotificationSubtitle => 'Ukryte — przykładowe przypomnienie';

  @override
  String get toastTestNotification => 'Testowe powiadomienie za ~1 minutę';

  @override
  String get notifTestBody => 'Test — akcje: woda / bojler / cicho 20 min';
}
