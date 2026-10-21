import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../l10n/app_localizations.dart';
import '../models/rewards_state.dart';

class RewardsPanel extends StatelessWidget {
  const RewardsPanel({super.key, required this.rewards});

  final RewardsState rewards;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = [
      _RewardItem(
        id: RewardIds.streak7,
        title: l10n.rewardStreak7Title,
        subtitle: l10n.rewardStreak7Desc,
        icon: Icons.diamond_rounded,
      ),
      _RewardItem(
        id: RewardIds.streak14,
        title: l10n.rewardStreak14Title,
        subtitle: l10n.rewardStreak14Desc,
        icon: Icons.waves_rounded,
      ),
      _RewardItem(
        id: RewardIds.streak30,
        title: l10n.rewardStreak30Title,
        subtitle: l10n.rewardStreak30Desc,
        icon: Icons.motion_photos_on_rounded,
      ),
      _RewardItem(
        id: RewardIds.firstCatchUp,
        title: l10n.rewardCatchUpTitle,
        subtitle: l10n.rewardCatchUpDesc,
        icon: Icons.speed_rounded,
      ),
      _RewardItem(
        id: RewardIds.confirms50,
        title: l10n.rewardConfirms50Title,
        subtitle: l10n.rewardConfirms50Desc,
        icon: Icons.touch_app_rounded,
      ),
      _RewardItem(
        id: RewardIds.confirms100,
        title: l10n.rewardConfirms100Title,
        subtitle: l10n.rewardConfirms100Desc,
        icon: Icons.verified_rounded,
      ),
      _RewardItem(
        id: RewardIds.goalStreak3,
        title: l10n.rewardGoal3Title,
        subtitle: l10n.rewardGoal3Desc,
        icon: Icons.auto_awesome_rounded,
      ),
      _RewardItem(
        id: RewardIds.ironMonth,
        title: l10n.rewardIronTitle,
        subtitle: l10n.rewardIronDesc,
        icon: Icons.workspace_premium_rounded,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.sectionRewards,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.rewardsHint,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.4),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 12),
        for (final item in items) ...[
          _RewardTile(
            item: item,
            unlocked: rewards.has(item.id),
          ),
          const SizedBox(height: 8),
        ],
        Text(
          l10n.rewardsProgress(
            rewards.confirmCount,
            rewards.catchUpCount,
            rewards.maxStreak,
          ),
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.45),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _RewardItem {
  const _RewardItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
}

class _RewardTile extends StatelessWidget {
  const _RewardTile({required this.item, required this.unlocked});

  final _RewardItem item;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: unlocked
            ? AppTheme.primary.withValues(alpha: 0.12)
            : Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: unlocked
              ? AppTheme.primary.withValues(alpha: 0.45)
              : Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        children: [
          Icon(
            item.icon,
            color: unlocked ? AppTheme.primary : Colors.white38,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: unlocked ? Colors.white : Colors.white54,
                  ),
                ),
                Text(
                  item.subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.45),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            unlocked ? Icons.lock_open_rounded : Icons.lock_outline_rounded,
            size: 18,
            color: unlocked ? const Color(0xFF69F0AE) : Colors.white24,
          ),
        ],
      ),
    );
  }
}
