import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants.dart';
import '../core/theme.dart';
import '../models/app_settings.dart';
import '../providers/providers.dart';
import '../services/notification_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(waterRepositoryProvider);
    final settings = repo.settings;

    return Scaffold(
      appBar: AppBar(title: const Text('Ustawienia')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _SectionTitle(title: 'Cele'),
          ListTile(
            title: const Text('Dzienny cel'),
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
                  final updated = AppSettings(
                    dailyGoalMl: v.round(),
                    portionMl: settings.portionMl,
                    notificationsEnabled: settings.notificationsEnabled,
                    nightNotificationEnabled: settings.nightNotificationEnabled,
                  );
                  await repo.updateSettings(updated);
                },
              ),
            ),
          ),
          ListTile(
            title: const Text('Porcja'),
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
                  final updated = AppSettings(
                    dailyGoalMl: settings.dailyGoalMl,
                    portionMl: v.round(),
                    notificationsEnabled: settings.notificationsEnabled,
                    nightNotificationEnabled: settings.nightNotificationEnabled,
                  );
                  await repo.updateSettings(updated);
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          _SectionTitle(title: 'Powiadomienia'),
          SwitchListTile(
            title: const Text('Przypomnienia dzienne'),
            subtitle: const Text('9:00–21:00 co ~50 min'),
            value: settings.notificationsEnabled,
            onChanged: (v) async {
              final updated = AppSettings(
                dailyGoalMl: settings.dailyGoalMl,
                portionMl: settings.portionMl,
                notificationsEnabled: v,
                nightNotificationEnabled: settings.nightNotificationEnabled,
              );
              await repo.updateSettings(updated);
              if (v) {
                await repo.scheduleDefaultNotifications();
              } else {
                await NotificationService.instance
                    .scheduleReminders([], replaceExisting: true);
              }
            },
          ),
          SwitchListTile(
            title: const Text('Powiadomienie nocne'),
            subtitle: Text(
              'O ${AppConstants.nightNotificationHour}:00 — przelicza harmonogram po kliknięciu',
            ),
            value: settings.nightNotificationEnabled,
            onChanged: (v) async {
              final updated = AppSettings(
                dailyGoalMl: settings.dailyGoalMl,
                portionMl: settings.portionMl,
                notificationsEnabled: settings.notificationsEnabled,
                nightNotificationEnabled: v,
              );
              await repo.updateSettings(updated);
              await repo.scheduleDefaultNotifications();
            },
          ),
          const SizedBox(height: 16),
          _SectionTitle(title: 'Test'),
          ListTile(
            title: const Text('Przelicz harmonogram teraz'),
            subtitle: const Text('Symuluje kliknięcie powiadomienia nocnego'),
            trailing: const Icon(Icons.nightlight_round),
            onTap: () async {
              await repo.handleNightWakeUp();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Harmonogram przeliczony na resztę dnia'),
                  ),
                );
              }
            },
          ),
          ListTile(
            title: const Text('Zaplanuj powiadomienia od nowa'),
            onTap: () async {
              await repo.scheduleDefaultNotifications();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Powiadomienia zaplanowane')),
                );
              }
            },
          ),
        ],
      ),
    );
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
