import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/app_settings.dart';

Locale? resolveAppLocale(AppSettings settings) {
  switch (settings.localeCode) {
    case 'en':
      return const Locale('en');
    case 'pl':
      return const Locale('pl');
    case 'system':
    default:
      return null;
  }
}

Locale effectiveLocale(AppSettings settings, List<Locale>? deviceLocales) {
  final forced = resolveAppLocale(settings);
  if (forced != null) return forced;

  final device = (deviceLocales != null && deviceLocales.isNotEmpty)
      ? deviceLocales.first
      : WidgetsBinding.instance.platformDispatcher.locale;
  if (device.languageCode == 'pl') return const Locale('pl');
  return const Locale('en');
}

AppLocalizations l10nForSettings(
  AppSettings settings, [
  List<Locale>? deviceLocales,
]) {
  return lookupAppLocalizations(effectiveLocale(settings, deviceLocales));
}
