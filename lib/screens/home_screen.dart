import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme.dart';
import '../l10n/app_localizations.dart';
import '../providers/providers.dart';
import '../widgets/adjust_water_sheet.dart';
import '../widgets/app_toast.dart';
import '../widgets/catch_up_card.dart';
import '../widgets/day_tags_row.dart';
import '../widgets/glass_card.dart';
import '../widgets/history_list.dart';
import '../widgets/past_day_sheet.dart';
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

        Future<void> logPortion(
          int amount, {
          String? toast,
        }) async {
          await repo.addWater(amount);
          if (!context.mounted || toast == null) return;
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
            logPortion(amount, toast: l10n.toastShakeLogged(amount));
          },
          child: Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: Text(
              l10n.appTitle,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
            actions: [
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
            decoration: AppTheme.backgroundDecoration,
            child: SafeArea(
              child: RefreshIndicator(
                color: AppTheme.primary,
                onRefresh: () async {
                  await setupNotifications(ref.read(waterRepositoryProvider));
                },
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 120),
                  children: [
                    Center(child: StreakBadge(streak: repo.calculateStreak())),
                    const SizedBox(height: 20),
                    GlassCard(
                      padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
                      child: Column(
                        children: [
                          Center(
                            child: ProgressRing(
                              progress: progress,
                              goal: goal,
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
                          AppToast.show(
                            context,
                            l10n.toastCatchUpApplied,
                            tone: AppToastTone.info,
                            icon: Icons.schedule_rounded,
                          );
                        },
                      ),
                    ],
                    const SizedBox(height: 16),
                    DayTagsRow(
                      modifiers: repo.dayModifiers,
                      onChanged: repo.updateDayModifiers,
                    ),
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
                      ),
                      onAdd500: () => logPortion(
                        repo.settings.portionMl * 2,
                        toast: requireHold
                            ? l10n.toastHoldLogged(
                                repo.settings.portionMl * 2,
                              )
                            : null,
                      ),
                      onBoiler250: () async {
                        await repo.useBoiler(repo.settings.portionMl);
                        if (!context.mounted || !requireHold) return;
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
          bottomNavigationBar: _BottomDock(
            kreatynaActive: repo.isKreatynaToday,
            onKreatyna: () async {
              await repo.toggleKreatyna();
              if (!context.mounted) return;
              final taken = ref.read(waterRepositoryProvider).isKreatynaToday;
              AppToast.show(
                context,
                taken ? l10n.toastCreatineOn : l10n.toastCreatineOff,
                tone: taken ? AppToastTone.success : AppToastTone.info,
                icon: taken
                    ? Icons.check_circle_rounded
                    : Icons.medication_outlined,
              );
            },
            onUndo: () => showAdjustWaterSheet(context, repo),
            onCalendar: () => showPastDaySheet(context, repo),
          ),
        ),
        );
      },
    );
  }
}

class _BottomDock extends StatelessWidget {
  const _BottomDock({
    required this.kreatynaActive,
    required this.onKreatyna,
    required this.onUndo,
    required this.onCalendar,
  });

  final bool kreatynaActive;
  final VoidCallback onKreatyna;
  final VoidCallback onUndo;
  final VoidCallback onCalendar;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF1A2D44).withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: Row(
          children: [
            _KreatynaChip(
              active: kreatynaActive,
              onTap: onKreatyna,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: FilledButton.icon(
                  onPressed: onUndo,
                  icon: const Icon(Icons.undo_rounded, size: 18),
                  label: Text(l10n.undo),
                  style: FilledButton.styleFrom(
                    backgroundColor:
                        const Color(0xFFE57373).withValues(alpha: 0.9),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 48),
                  ),
                ),
              ),
            ),
            _DockButton(
              icon: Icons.calendar_month_rounded,
              onTap: onCalendar,
              tooltip: l10n.pastDay,
            ),
          ],
        ),
      ),
    );
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                active ? Icons.check_circle_rounded : Icons.medication_rounded,
                size: 18,
                color: Colors.white,
              ),
              const SizedBox(height: 2),
              Text(
                active ? l10n.creatineTaken : l10n.creatine,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
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

class _DockButton extends StatelessWidget {
  const _DockButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      tooltip: tooltip,
      onPressed: onTap,
      style: IconButton.styleFrom(
        backgroundColor: Colors.white.withValues(alpha: 0.08),
        foregroundColor: Colors.white,
        fixedSize: const Size(48, 48),
      ),
      icon: Icon(icon, size: 22),
    );
  }
}
