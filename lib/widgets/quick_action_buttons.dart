import 'package:flutter/material.dart';

class QuickActionButtons extends StatelessWidget {
  const QuickActionButtons({
    super.key,
    required this.onAdd250,
    required this.onAdd500,
    required this.onBoiler250,
    required this.boilerAmount,
    required this.onRefillBoiler,
    required this.portionMl,
  });

  final VoidCallback onAdd250;
  final VoidCallback onAdd500;
  final VoidCallback onBoiler250;
  final VoidCallback onRefillBoiler;
  final int boilerAmount;
  final int portionMl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _ActionButton(
                label: 'Wypito $portionMl ml',
                color: Colors.green,
                onTap: onAdd250,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionButton(
                label: 'Wypito ${portionMl * 2} ml',
                color: Colors.orange,
                onTap: onAdd500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (boilerAmount >= portionMl)
          _ActionButton(
            label: 'Bojler $portionMl ml',
            color: Colors.blue,
            subtitle: 'Stan bojlera: $boilerAmount ml',
            onTap: onBoiler250,
          )
        else
          _ActionButton(
            label: 'Uzupełnij bojler',
            color: Colors.teal,
            onTap: onRefillBoiler,
          ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.color,
    required this.onTap,
    this.subtitle,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.85),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Column(
            children: [
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 11,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
