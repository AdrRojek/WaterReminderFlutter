import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/locale_resolver.dart';
import 'core/theme.dart';
import 'l10n/app_localizations.dart';
import 'providers/providers.dart';
import 'screens/home_screen.dart';

class WaterReminderApp extends ConsumerWidget {
  const WaterReminderApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(waterRepositoryProvider).settings;

    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      locale: resolveAppLocale(settings),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: const HomeScreen(),
    );
  }
}
