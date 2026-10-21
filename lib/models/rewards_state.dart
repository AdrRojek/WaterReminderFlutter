/// Cosmetic unlocks — no XP / no paywall.
class RewardIds {
  static const streak7 = 'streak_7';
  static const streak14 = 'streak_14';
  static const streak30 = 'streak_30';
  static const firstCatchUp = 'first_catchup';
  static const confirms50 = 'confirms_50';
  static const confirms100 = 'confirms_100';
  static const ironMonth = 'iron_month';
  static const goalStreak3 = 'goal_streak_3';

  static const all = [
    streak7,
    streak14,
    streak30,
    firstCatchUp,
    confirms50,
    confirms100,
    ironMonth,
    goalStreak3,
  ];
}

class RewardsState {
  RewardsState({
    Set<String>? unlocked,
    this.confirmCount = 0,
    this.catchUpCount = 0,
    this.maxStreak = 0,
    this.ironMonths = 0,
    this.seenUnlockToast = const {},
  }) : unlocked = unlocked ?? {};

  final Set<String> unlocked;
  final int confirmCount;
  final int catchUpCount;
  final int maxStreak;
  final int ironMonths;
  final Set<String> seenUnlockToast;

  bool has(String id) => unlocked.contains(id);

  bool get goldLogo => has(RewardIds.streak7);
  bool get deepOcean => has(RewardIds.streak14);
  bool get animatedRing => has(RewardIds.streak30);
  bool get solidSipper => has(RewardIds.confirms100);
  bool get ironBadge => has(RewardIds.ironMonth);
  bool get auroraGlow => has(RewardIds.goalStreak3);

  RewardsState copyWith({
    Set<String>? unlocked,
    int? confirmCount,
    int? catchUpCount,
    int? maxStreak,
    int? ironMonths,
    Set<String>? seenUnlockToast,
  }) {
    return RewardsState(
      unlocked: unlocked ?? this.unlocked,
      confirmCount: confirmCount ?? this.confirmCount,
      catchUpCount: catchUpCount ?? this.catchUpCount,
      maxStreak: maxStreak ?? this.maxStreak,
      ironMonths: ironMonths ?? this.ironMonths,
      seenUnlockToast: seenUnlockToast ?? this.seenUnlockToast,
    );
  }

  Map<String, dynamic> toMap() => {
        'unlocked': unlocked.toList(),
        'confirmCount': confirmCount,
        'catchUpCount': catchUpCount,
        'maxStreak': maxStreak,
        'ironMonths': ironMonths,
        'seenUnlockToast': seenUnlockToast.toList(),
      };

  factory RewardsState.fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) return RewardsState();
    return RewardsState(
      unlocked: {
        for (final e in (map['unlocked'] as List? ?? const [])) e.toString(),
      },
      confirmCount: (map['confirmCount'] as num?)?.toInt() ?? 0,
      catchUpCount: (map['catchUpCount'] as num?)?.toInt() ?? 0,
      maxStreak: (map['maxStreak'] as num?)?.toInt() ?? 0,
      ironMonths: (map['ironMonths'] as num?)?.toInt() ?? 0,
      seenUnlockToast: {
        for (final e in (map['seenUnlockToast'] as List? ?? const []))
          e.toString(),
      },
    );
  }
}
