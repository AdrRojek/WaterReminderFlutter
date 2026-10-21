class StreakInfo {
  const StreakInfo({
    required this.streak,
    required this.amnestyAvailable,
    required this.amnestyUsedThisMonth,
    this.amnestyDateKey,
  });

  final int streak;
  final bool amnestyAvailable;
  final bool amnestyUsedThisMonth;
  final String? amnestyDateKey;
}
