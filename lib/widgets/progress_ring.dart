import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/theme.dart';

class ProgressRing extends StatelessWidget {
  const ProgressRing({
    super.key,
    required this.progress,
    required this.goal,
    this.size = 200,
  });

  final int progress;
  final int goal;
  final double size;

  @override
  Widget build(BuildContext context) {
    final fraction = (progress / goal).clamp(0.0, 1.0);
    final color = AppTheme.progressColor(progress.toDouble(), goal);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size * 0.92,
            height: size * 0.92,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.25),
                  blurRadius: 40,
                  spreadRadius: 4,
                ),
              ],
            ),
          ),
          CustomPaint(
            size: Size(size, size),
            painter: _RingPainter(fraction: fraction, color: color),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShaderMask(
                shaderCallback: (bounds) =>
                    AppTheme.waterGradient.createShader(bounds),
                child: Text(
                  '$progress',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1,
                      ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'z $goal ml',
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
