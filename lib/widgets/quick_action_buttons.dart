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
              child: _ActionTile(
                icon: Icons.water_drop_rounded,
                label: '+$portionMl ml',
                gradient: const LinearGradient(
                  colors: [Color(0xFF26C6DA), Color(0xFF00ACC1)],
                ),
                onTap: onAdd250,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionTile(
                icon: Icons.local_drink_rounded,
                label: '+${portionMl * 2} ml',
                gradient: const LinearGradient(
                  colors: [Color(0xFF42A5F5), Color(0xFF1E88E5)],
                ),
                onTap: onAdd500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (boilerAmount >= portionMl)
          _ActionTile(
            icon: Icons.coffee_rounded,
            label: 'Bojler $portionMl ml',
            subtitle: 'Pozostało $boilerAmount ml',
            gradient: const LinearGradient(
              colors: [Color(0xFF7E57C2), Color(0xFF5E35B1)],
            ),
            onTap: onBoiler250,
            fullWidth: true,
          )
        else
          _ActionTile(
            icon: Icons.refresh_rounded,
            label: 'Uzupełnij bojler',
            subtitle: 'Pusty — naciśnij, aby napełnić',
            gradient: const LinearGradient(
              colors: [Color(0xFF66BB6A), Color(0xFF43A047)],
            ),
            onTap: onRefillBoiler,
            fullWidth: true,
          ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
    this.subtitle,
    this.fullWidth = false,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final LinearGradient gradient;
  final VoidCallback onTap;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: gradient.colors.first.withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: fullWidth ? 16 : 18,
              horizontal: 16,
            ),
            child: Row(
              mainAxisAlignment:
                  fullWidth ? MainAxisAlignment.start : MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: fullWidth
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.center,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
