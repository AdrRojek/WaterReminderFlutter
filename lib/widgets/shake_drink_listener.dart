import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// Listens for a firm shake and fires [onShake] (with cooldown).
class ShakeDrinkListener extends StatefulWidget {
  const ShakeDrinkListener({
    super.key,
    required this.enabled,
    required this.onShake,
    required this.child,
  });

  final bool enabled;
  final VoidCallback onShake;
  final Widget child;

  @override
  State<ShakeDrinkListener> createState() => _ShakeDrinkListenerState();
}

class _ShakeDrinkListenerState extends State<ShakeDrinkListener> {
  static const _threshold = 18.0;
  static const _cooldown = Duration(milliseconds: 1600);

  StreamSubscription<AccelerometerEvent>? _sub;
  DateTime _lastShake = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  void initState() {
    super.initState();
    _sync();
  }

  @override
  void didUpdateWidget(covariant ShakeDrinkListener oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enabled != widget.enabled) _sync();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void _sync() {
    _sub?.cancel();
    _sub = null;
    if (!widget.enabled) return;

    _sub = accelerometerEventStream().listen((event) {
      final magnitude = math.sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );
      // Resting ~9.8; shake spikes well above threshold.
      if (magnitude < _threshold) return;

      final now = DateTime.now();
      if (now.difference(_lastShake) < _cooldown) return;
      _lastShake = now;
      HapticFeedback.heavyImpact();
      widget.onShake();
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
