import 'package:flutter/material.dart';

class WaterDrop extends StatelessWidget {
  const WaterDrop({
    super.key,
    required this.progress,
    required this.goal,
    this.size = 90,
  });

  final double progress;
  final int goal;
  final double size;

  @override
  Widget build(BuildContext context) {
    final fill = (progress / goal).clamp(0.0, 1.0);

    return SizedBox(
      width: size,
      height: size * 1.3,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Icon(
            Icons.water_drop_outlined,
            size: size * 1.3,
            color: Colors.white.withValues(alpha: 0.15),
          ),
          ClipRect(
            child: Align(
              alignment: Alignment.bottomCenter,
              heightFactor: fill,
              child: Icon(
                Icons.water_drop,
                size: size * 1.3,
                color: const Color(0xFF4FC3F7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
