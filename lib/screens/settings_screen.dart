import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants.dart';
import '../core/locale_resolver.dart';
import '../core/theme.dart';
import '../l10n/app_localizations.dart';
import '../providers/providers.dart';
import '../services/notification_service.dart';
import '../widgets/adjust_water_sheet.dart';
import '../widgets/app_toast.dart';
import '../widgets/past_day_sheet.dart';
import 'rewards_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  int _resetTapCount = 0;
  bool _showTestNotification = false;

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(waterRepositoryProvider);
    final settings = repo.settings;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _SectionTitle(title: l10n.sectionGoals),
          ListTile(
            title: Text(l10n.dailyGoal),
            subtitle: Text('${settings.dailyGoalMl} ml'),
            trailing: SizedBox(
              width: 120,
              child: Slider(
                value: settings.dailyGoalMl.toDouble(),
                min: 2000,
                max: 6000,
                divisions: 16,
                label: '${settings.dailyGoalMl} ml',
                onChanged: (v) async {
                  await repo.updateSettings(
                    settings.copyWith(dailyGoalMl: v.round()),
                  );
                },
              ),
            ),
          ),
          ListTile(
            title: Text(l10n.portion),
            subtitle: Text('${settings.portionMl} ml'),
            trailing: SizedBox(
              width: 120,
              child: Slider(
                value: settings.portionMl.toDouble(),
                min: 100,
                max: 500,
                divisions: 8,
                label: '${settings.portionMl} ml',
                onChanged: (v) async {
                  await repo.updateSettings(
                    settings.copyWith(portionMl: v.round()),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          _SectionTitle(title: l10n.sectionLanguage),
          ListTile(
            title: Text(l10n.language),
            subtitle: Text(_languageLabel(l10n, settings.localeCode)),
            trailing: DropdownButton<String>(
              value: settings.localeCode,
              underline: const SizedBox.shrink(),
              items: [
                DropdownMenuItem(
                  value: 'system',
                  child: Text(l10n.languageSystem),
                ),
                DropdownMenuItem(
                  value: 'en',
                  child: Text(l10n.languageEnglish),
                ),
                DropdownMenuItem(
                  value: 'pl',
                  child: Text(l10n.languagePolish),
                ),
              ],
              onChanged: (code) async {
                if (code == null) return;
                await repo.updateSettings(settings.copyWith(localeCode: code));
                if (settings.notificationsEnabled) {
                  await repo.ensureDailySchedule();
                }
              },
            ),
          ),
          const SizedBox(height: 16),
          _SectionTitle(title: l10n.sectionAdjust),
          ListTile(
            title: Text(l10n.undoWater),
            subtitle: Text(l10n.undoWaterSubtitle),
            trailing: const Icon(Icons.undo_rounded),
            onTap: () => showAdjustWaterSheet(context, repo),
          ),
          ListTile(
            title: Text(l10n.pastDaySettings),
            subtitle: Text(l10n.pastDaySettingsSubtitle),
            trailing: const Icon(Icons.calendar_month_rounded),
            onTap: () => showPastDaySheet(context, repo),
          ),
          ListTile(
            title: Text(l10n.openRewards),
            subtitle: Text(l10n.openRewardsSubtitle),
            trailing: const Icon(Icons.emoji_events_rounded),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const RewardsScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _SectionTitle(title: l10n.sectionConfirm),
          ListTile(
            title: Text(l10n.confirmDrinks),
            subtitle: Text(_confirmLabel(l10n, settings.confirmDrinkMode)),
            trailing: DropdownButton<String>(
              value: settings.confirmDrinkMode,
              underline: const SizedBox.shrink(),
              items: [
                DropdownMenuItem(
                  value: 'none',
                  child: Text(l10n.confirmNone),
                ),
                DropdownMenuItem(
                  value: 'hold',
                  child: Text(l10n.confirmHold),
                ),
                DropdownMenuItem(
                  value: 'shake',
                  child: Text(l10n.confirmShake),
                ),
                DropdownMenuItem(
                  value: 'both',
                  child: Text(l10n.confirmBoth),
                ),
              ],
              onChanged: (mode) async {
                if (mode == null) return;
                await repo.updateSettings(
                  settings.copyWith(confirmDrinkMode: mode),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          _SectionTitle(title: l10n.sectionNotifications),
          SwitchListTile(
            title: Text(l10n.dailyReminders),
            subtitle: Text(l10n.dailyRemindersSubtitle),
            value: settings.notificationsEnabled,
            onChanged: (v) async {
              await repo.updateSettings(
                settings.copyWith(notificationsEnabled: v),
              );
              if (v) {
                await repo.scheduleDefaultNotifications();
              } else {
                await NotificationService.instance
                    .scheduleReminders([], replaceExisting: true);
              }
            },
          ),
          SwitchListTile(
            title: Text(l10n.nightNotification),
            subtitle: Text(
              l10n.nightNotificationSubtitle(AppConstants.nightNotificationHour),
            ),
            value: settings.nightNotificationEnabled,
            onChanged: (v) async {
              await repo.updateSettings(
                settings.copyWith(nightNotificationEnabled: v),
              );
              await repo.scheduleDefaultNotifications();
            },
          ),
          const SizedBox(height: 16),
          _SectionTitle(title: l10n.sectionSchedule),
          ListTile(
            title: Text(l10n.rescheduleFromNow),
            subtitle: Text(l10n.rescheduleFromNowSubtitle),
            trailing: const Icon(Icons.schedule_rounded),
            onTap: () async {
              await repo.handleNightWakeUp();
              if (context.mounted) {
                AppToast.show(
                  context,
                  l10n.toastScheduleRedistributed,
                  tone: AppToastTone.info,
                  icon: Icons.schedule_rounded,
                );
              }
            },
          ),
          ListTile(
            title: Text(l10n.resetStandardDay),
            subtitle: Text(l10n.resetStandardDaySubtitle),
            trailing: const Icon(Icons.refresh_rounded),
            onTap: () async {
              setState(() {
                _resetTapCount++;
                if (_resetTapCount >= 5) {
                  _showTestNotification = true;
                }
              });
              await repo.ensureDailySchedule(forceDefault: true);
              if (context.mounted) {
                AppToast.show(
                  context,
                  l10n.toastScheduleReset,
                  tone: AppToastTone.success,
                  icon: Icons.refresh_rounded,
                );
              }
            },
          ),
          if (_showTestNotification)
            ListTile(
              title: Text(l10n.testNotification),
              subtitle: Text(l10n.testNotificationSubtitle),
              trailing: const Icon(Icons.notification_add_rounded),
              onTap: () async {
                NotificationService.instance
                    .useLocalizations(l10nForSettings(repo.settings));
                await NotificationService.instance.scheduleTestNotification(
                  portionMl: settings.portionMl,
                );
                if (context.mounted) {
                  AppToast.show(
                    context,
                    l10n.toastTestNotification,
                    tone: AppToastTone.info,
                    icon: Icons.notification_add_rounded,
                  );
                }
              },
            ),
        ],
      ),
    );
  }

  String _languageLabel(AppLocalizations l10n, String code) {
    switch (code) {
      case 'pl':
        return l10n.languagePolish;
      case 'system':
        return l10n.languageSystem;
      case 'en':
      default:
        return l10n.languageEnglish;
    }
  }

  String _confirmLabel(AppLocalizations l10n, String mode) {
    switch (mode) {
      case 'hold':
        return l10n.confirmHold;
      case 'shake':
        return l10n.confirmShake;
      case 'both':
        return l10n.confirmBoth;
      case 'none':
      default:
        return l10n.confirmNone;
    }
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.dark.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
