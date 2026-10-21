import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../l10n/app_localizations.dart';

class ProgressRing extends StatefulWidget {
  const ProgressRing({
    super.key,
    required this.progress,
    required this.goal,
    this.size = 200,
    this.animated = false,
    this.aurora = false,
  });

  final int progress;
  final int goal;
  final double size;
  final bool animated;
  final bool aurora;

  @override
  State<ProgressRing> createState() => _ProgressRingState();
}

class _ProgressRingState extends State<ProgressRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spin;

  @override
  void initState() {
    super.initState();
    _spin = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
    if (widget.animated) _spin.repeat();
  }

  @override
  void didUpdateWidget(covariant ProgressRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animated && !_spin.isAnimating) {
      _spin.repeat();
    } else if (!widget.animated && _spin.isAnimating) {
      _spin.stop();
      _spin.value = 0;
    }
  }

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final fraction = (widget.progress / widget.goal).clamp(0.0, 1.0);
    final color = AppTheme.progressColor(
      widget.progress.toDouble(),
      widget.goal,
    );

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: widget.size * 0.92,
            height: widget.size * 0.92,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (widget.aurora ? AppTheme.accent : color)
                      .withValues(alpha: widget.aurora ? 0.35 : 0.25),
                  blurRadius: widget.aurora ? 48 : 40,
                  spreadRadius: widget.aurora ? 6 : 4,
                ),
              ],
            ),
          ),
          AnimatedBuilder(
            animation: _spin,
            builder: (context, _) {
              return Transform.rotate(
                angle: widget.animated ? _spin.value * math.pi * 2 : 0,
                child: CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: _RingPainter(fraction: fraction, color: color),
                ),
              );
            },
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShaderMask(
                shaderCallback: (bounds) =>
                    AppTheme.waterGradient.createShader(bounds),
                child: Text(
                  '${widget.progress}',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1,
                      ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.ofGoalMl(widget.goal),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white54,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                '${(fraction * 100).round()}%',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.fraction, required this.color});

  final double fraction;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * 0.075;
    final arcRect = Rect.fromLTWH(
      stroke / 2,
      stroke / 2,
      size.width - stroke,
      size.height - stroke,
    );
    const start = -math.pi / 2;

    final bgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.07)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    final fgPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          color.withValues(alpha: 0.35),
          color,
          color.withValues(alpha: 0.85),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(arcRect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(arcRect, 0, math.pi * 2, false, bgPaint);
    if (fraction > 0) {
      canvas.drawArc(arcRect, start, math.pi * 2 * fraction, false, fgPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.fraction != fraction || oldDelegate.color != color;
}
