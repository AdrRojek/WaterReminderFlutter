import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme.dart';
import '../l10n/app_localizations.dart';
import '../providers/providers.dart';
import '../models/rewards_state.dart';
import '../widgets/app_toast.dart';
import '../widgets/catch_up_card.dart';
import '../widgets/glass_card.dart';
import '../widgets/history_list.dart';
import '../widgets/progress_ring.dart';
import '../widgets/quick_action_buttons.dart';
import '../widgets/shake_drink_listener.dart';
import '../widgets/streak_badge.dart';
import 'settings_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver {
  bool _notificationsScheduled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _notificationsScheduled) {
      ref.read(waterRepositoryProvider).ensureDailySchedule();
    }
  }

  @override
  Widget build(BuildContext context) {
    final init = ref.watch(initProvider);
    final l10n = AppLocalizations.of(context);

    return init.when(
      loading: () => Scaffold(
        body: Container(
          decoration: AppTheme.backgroundDecoration,
          child: const Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (e, _) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(l10n.initError('$e')),
          ),
        ),
      ),
      data: (_) {
        if (!_notificationsScheduled) {
          _notificationsScheduled = true;
          final repo = ref.read(waterRepositoryProvider);
          Future<void>.delayed(const Duration(seconds: 2), () {
            setupNotifications(repo);
          });
        }

        final repo = ref.watch(waterRepositoryProvider);
        final progress = repo.todayProgress;
        final goal = repo.settings.dailyGoalMl;
        final recommended = repo.recommendedMlNow();
        final remaining = (goal - progress).clamp(0, goal);
        final statusColor =
            AppTheme.progressColor(progress.toDouble(), goal);
        final recommendedColor =
            AppTheme.recommendedColor(recommended, progress);
        final catchUp = repo.catchUpPlanNow();
        final requireHold = repo.settings.confirmHold;
        final shakeEnabled = repo.settings.confirmShake;
        final rewards = repo.rewards;
        final streakInfo = repo.calculateStreak();

        void showUnlockToasts() {
          final unlocked = repo.consumeUnlockToasts();
          for (final id in unlocked) {
            if (!context.mounted) return;
            AppToast.show(
              context,
              l10n.toastRewardUnlocked(_rewardTitle(l10n, id)),
              tone: AppToastTone.success,
              icon: Icons.emoji_events_rounded,
            );
          }
        }

        Future<void> logPortion(
          int amount, {
          String? toast,
          bool countConfirm = false,
        }) async {
          await repo.addWater(amount);
          if (countConfirm) await repo.registerConfirm();
          if (!context.mounted) return;
          showUnlockToasts();
          if (toast == null) return;
          AppToast.show(
            context,
            toast,
            tone: AppToastTone.success,
            icon: Icons.water_drop_rounded,
          );
        }

        return ShakeDrinkListener(
          enabled: shakeEnabled,
          onShake: () {
            final amount = repo.settings.portionMl;
            logPortion(
              amount,
              toast: l10n.toastShakeLogged(amount),
              countConfirm: true,
            );
          },
          child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(rewards.goldLogo ? 2 : 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: rewards.goldLogo
                        ? const LinearGradient(
                            colors: [Color(0xFFFFD54F), Color(0xFFFF8F00)],
                          )
                        : null,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/brand/logo.png',
                      width: 28,
                      height: 28,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  l10n.appTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_paused_rounded),
                tooltip: l10n.snoozeNextSlot,
                onPressed: () async {
                  final ok = await repo.snoozeNextSlot();
                  if (!context.mounted) return;
                  AppToast.show(
                    context,
                    ok ? l10n.toastSnoozeOk : l10n.toastSnoozeFail,
                    tone: ok ? AppToastTone.info : AppToastTone.warning,
                    icon: Icons.notifications_paused_rounded,
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.tune_rounded),
                tooltip: l10n.settings,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const SettingsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Container(
            decoration: AppTheme.backgroundFor(
              deepOcean: rewards.deepOcean,
              aurora: rewards.auroraGlow,
            ),
            child: SafeArea(
              child: RefreshIndicator(
                color: AppTheme.primary,
                onRefresh: () async {
                  await setupNotifications(ref.read(waterRepositoryProvider));
                },
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                  children: [
                    Center(
                      child: StreakBadge(
                        info: streakInfo,
                        rewards: rewards,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: _KreatynaChip(
                        active: repo.isKreatynaToday,
                        onTap: () async {
                          await repo.toggleKreatyna();
                          if (!context.mounted) return;
                          final taken =
                              ref.read(waterRepositoryProvider).isKreatynaToday;
                          AppToast.show(
                            context,
                            taken
                                ? l10n.toastCreatineOn
                                : l10n.toastCreatineOff,
                            tone: taken
                                ? AppToastTone.success
                                : AppToastTone.info,
                            icon: taken
                                ? Icons.check_circle_rounded
                                : Icons.medication_outlined,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    GlassCard(
                      padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
                      child: Column(
                        children: [
                          Center(
                            child: ProgressRing(
                              progress: progress,
                              goal: goal,
                              animated: rewards.animatedRing,
                              aurora: rewards.auroraGlow,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            progress >= goal
                                ? l10n.goalReached
                                : l10n.remainingMl(remaining),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: statusColor,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            l10n.recommendation(recommended),
                            style: TextStyle(
                              color: recommendedColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (catchUp != null) ...[
                      const SizedBox(height: 14),
                      CatchUpCard(
                        plan: catchUp,
                        portionMl: repo.settings.portionMl,
                        onApply: () async {
                          await repo.applyCatchUpPlan();
                          if (!context.mounted) return;
                          showUnlockToasts();
                          AppToast.show(
                            context,
                            l10n.toastCatchUpApplied,
                            tone: AppToastTone.info,
                            icon: Icons.schedule_rounded,
                          );
                        },
                      ),
                    ],
                    const SizedBox(height: 20),
                    QuickActionButtons(
                      portionMl: repo.settings.portionMl,
                      boilerAmount: repo.boiler.amountMl,
                      requireHold: requireHold,
                      onAdd250: () => logPortion(
                        repo.settings.portionMl,
                        toast: requireHold
                            ? l10n.toastHoldLogged(repo.settings.portionMl)
                            : null,
                        countConfirm: requireHold,
                      ),
                      onAdd500: () => logPortion(
                        repo.settings.portionMl * 2,
                        toast: requireHold
                            ? l10n.toastHoldLogged(
                                repo.settings.portionMl * 2,
                              )
                            : null,
                        countConfirm: requireHold,
                      ),
                      onBoiler250: () async {
                        await repo.useBoiler(repo.settings.portionMl);
                        if (requireHold) await repo.registerConfirm();
                        if (!context.mounted) return;
                        showUnlockToasts();
                        if (!requireHold) return;
                        AppToast.show(
                          context,
                          l10n.toastHoldLogged(repo.settings.portionMl),
                          tone: AppToastTone.success,
                        );
                      },
                      onRefillBoiler: repo.refillBoiler,
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Text(
                          l10n.history,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const Spacer(),
                        Text(
                          l10n.recentDays,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.35),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    HistoryList(
                      entries: repo.entries,
                      dailyGoal: goal,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        );
      },
    );
  }
}

String _rewardTitle(AppLocalizations l10n, String id) {
  switch (id) {
    case RewardIds.streak7:
      return l10n.rewardStreak7Title;
    case RewardIds.streak14:
      return l10n.rewardStreak14Title;
    case RewardIds.streak30:
      return l10n.rewardStreak30Title;
    case RewardIds.firstCatchUp:
      return l10n.rewardCatchUpTitle;
    case RewardIds.confirms50:
      return l10n.rewardConfirms50Title;
    case RewardIds.confirms100:
      return l10n.rewardConfirms100Title;
    case RewardIds.goalStreak3:
      return l10n.rewardGoal3Title;
    case RewardIds.ironMonth:
      return l10n.rewardIronTitle;
    default:
      return id;
  }
}

class _KreatynaChip extends StatelessWidget {
  const _KreatynaChip({
    required this.active,
    required this.onTap,
  });

  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: active
                ? const Color(0xFF43A047).withValues(alpha: 0.9)
                : Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: active
                  ? const Color(0xFF66BB6A)
                  : Colors.white.withValues(alpha: 0.15),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                active ? Icons.check_circle_rounded : Icons.medication_rounded,
                size: 18,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Text(
                active ? l10n.creatineTaken : l10n.creatine,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
