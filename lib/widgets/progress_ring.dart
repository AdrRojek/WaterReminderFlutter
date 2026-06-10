import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/theme.dart';

class ProgressRing extends StatelessWidget {
  const ProgressRing({
    super.key,
    required this.progress,
    required this.goal,
    this.size = 180,
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
          CustomPaint(
            size: Size(size, size),
            painter: _RingPainter(fraction: fraction, color: color),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$progress',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                '/ $goal ml',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
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
    final stroke = size.width * 0.08;
    final rect = Offset.zero & size;
    final start = -math.pi / 2;

    final bgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    final fgPaint = Paint()
      ..shader = SweepGradient(
        colors: [color.withValues(alpha: 0.4), color],
        startAngle: 0,
        endAngle: math.pi * 2 * fraction,
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromLTWH(stroke / 2, stroke / 2, size.width - stroke,
          size.height - stroke),
      0,
      math.pi * 2,
      false,
      bgPaint,
    );

    canvas.drawArc(
      Rect.fromLTWH(stroke / 2, stroke / 2, size.width - stroke,
          size.height - stroke),
      start,
      math.pi * 2 * fraction,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.fraction != fraction || oldDelegate.color != color;
}
