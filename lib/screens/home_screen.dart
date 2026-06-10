import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme.dart';
import '../providers/providers.dart';
import '../widgets/adjust_water_sheet.dart';
import '../widgets/history_list.dart';
import '../widgets/past_day_sheet.dart';
import '../widgets/progress_ring.dart';
import '../widgets/quick_action_buttons.dart';
import '../widgets/streak_badge.dart';
import '../widgets/water_drop.dart';
import 'settings_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final init = ref.watch(initProvider);

    return init.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Błąd: $e')),
      ),
      data: (_) {
        final repo = ref.watch(waterRepositoryProvider);
        final progress = repo.todayProgress;
        final goal = repo.settings.dailyGoalMl;
        final recommended = repo.recommendedMlNow();
        final remaining = (goal - progress).clamp(0, goal);
        final recommendedColor =
            AppTheme.recommendedColor(recommended, progress);

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: const Text('Water Reminder'),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined),
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
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).scaffoldBackgroundColor,
                  const Color(0xFF102A43),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {
                  await repo.scheduleDefaultNotifications();
                },
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  children: [
                    Center(child: StreakBadge(streak: repo.calculateStreak())),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        WaterDrop(progress: progress.toDouble(), goal: goal),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                progress >= goal
                                    ? 'Cel osiągnięty!'
                                    : 'Jeszcze $remaining ml',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      color: AppTheme.progressColor(
                                        progress.toDouble(),
                                        goal,
                                      ),
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Powinieneś mieć: $recommended ml',
                                style: TextStyle(
                                  color: recommendedColor,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: ProgressRing(
                        progress: progress,
                        goal: goal,
                      ),
                    ),
                    const SizedBox(height: 28),
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
                    Text(
                      'Historia',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    HistoryList(
                      entries: repo.entries,
                      dailyGoal: goal,
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Row(
              children: [
                _BottomIconButton(
                  icon: Icons.fitness_center,
                  active: repo.isKreatynaToday,
                  onTap: repo.toggleKreatyna,
                  tooltip: 'Kreatyna',
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: () => showAdjustWaterSheet(context, repo),
                  icon: const Icon(Icons.undo),
                  label: const Text('Cofnij'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
                  ),
                ),
                const Spacer(),
                _BottomIconButton(
                  icon: Icons.calendar_month,
                  onTap: () => showPastDaySheet(context, repo),
                  tooltip: 'Poprzedni dzień',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BottomIconButton extends StatelessWidget {
  const _BottomIconButton({
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
            ? Colors.green.withValues(alpha: 0.8)
            : Theme.of(context).cardColor,
      ),
      icon: Icon(icon),
    );
  }
}
