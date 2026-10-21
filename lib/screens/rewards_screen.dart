import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme.dart';
import '../l10n/app_localizations.dart';
import '../providers/providers.dart';
import '../widgets/rewards_panel.dart';

class RewardsScreen extends ConsumerWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final rewards = ref.watch(waterRepositoryProvider).rewards;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.sectionRewards)),
      body: Container(
        decoration: AppTheme.backgroundFor(
          deepOcean: rewards.deepOcean,
          aurora: rewards.auroraGlow,
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            RewardsPanel(rewards: rewards),
          ],
        ),
      ),
    );
  }
}
