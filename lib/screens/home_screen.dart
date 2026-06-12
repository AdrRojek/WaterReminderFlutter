import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme.dart';
import '../providers/providers.dart';
import '../widgets/adjust_water_sheet.dart';
import '../widgets/glass_card.dart';
import '../widgets/history_list.dart';
import '../widgets/past_day_sheet.dart';
import '../widgets/progress_ring.dart';
import '../widgets/quick_action_buttons.dart';
import '../widgets/streak_badge.dart';
import 'settings_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _notificationsScheduled = false;

  @override
  Widget build(BuildContext context) {
    final init = ref.watch(initProvider);

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
            child: Text('Błąd inicjalizacji: $e'),
          ),
        ),
      ),
      data: (_) {
        if (!_notificationsScheduled) {
          _notificationsScheduled = true;
          final repo = ref.read(waterRepositoryProvider);
          Future.microtask(() => setupNotifications(repo));
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

        return Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: const Text(
              'Water Reminder',
              style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: -0.3),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.tune_rounded),
                tooltip: 'Ustawienia',
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
                                ? 'Świetnie! Cel osiągnięty'
                                : 'Zostało $remaining ml',
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
                            'Rekomendacja: $recommended ml',
                            style: TextStyle(
                              color: recommendedColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    QuickActionButtons(
                      portionMl: repo.settings.portionMl,
                      boilerAmount: repo.boiler.amountMl,
                      onAdd250: () => repo.addWater(repo.settings.portionMl),
                      onAdd500: () =>
                          repo.addWater(repo.settings.portionMl * 2),
                      onBoiler250: () =>
                          repo.useBoiler(repo.settings.portionMl),
                      onRefillBoiler: repo.refillBoiler,
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Text(
                          'Historia',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const Spacer(),
                        Text(
                          'ostatnie dni',
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
            onKreatyna: repo.toggleKreatyna,
            onUndo: () => showAdjustWaterSheet(context, repo),
            onCalendar: () => showPastDaySheet(context, repo),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            ),
            child: Row(
              children: [
                _DockButton(
                  icon: Icons.fitness_center_rounded,
                  active: kreatynaActive,
                  onTap: onKreatyna,
                  tooltip: 'Kreatyna',
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: FilledButton.icon(
                      onPressed: onUndo,
                      icon: const Icon(Icons.undo_rounded, size: 18),
                      label: const Text('Cofnij'),
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
                  tooltip: 'Poprzedni dzień',
                ),
              ],
            ),
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
    this.active = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      tooltip: tooltip,
      onPressed: onTap,
      style: IconButton.styleFrom(
        backgroundColor: active
            ? const Color(0xFF43A047).withValues(alpha: 0.85)
            : Colors.white.withValues(alpha: 0.08),
        foregroundColor: Colors.white,
        fixedSize: const Size(48, 48),
      ),
      icon: Icon(icon, size: 22),
    );
  }
}
