import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/app_localizations.dart';

/// Water action that optionally requires a ~0.8s hold to confirm.
class HoldActionTile extends StatefulWidget {
  const HoldActionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onConfirm,
    this.subtitle,
    this.fullWidth = false,
    this.requireHold = false,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final LinearGradient gradient;
  final VoidCallback onConfirm;
  final bool fullWidth;
  final bool requireHold;

  @override
  State<HoldActionTile> createState() => _HoldActionTileState();
}

class _HoldActionTileState extends State<HoldActionTile>
    with SingleTickerProviderStateMixin {
  static const _holdDuration = Duration(milliseconds: 800);

  late final AnimationController _progress;
  bool _holding = false;

  @override
  void initState() {
    super.initState();
    _progress = AnimationController(vsync: this, duration: _holdDuration)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          HapticFeedback.mediumImpact();
          widget.onConfirm();
          _reset();
        }
      });
  }

  @override
  void dispose() {
    _progress.dispose();
    super.dispose();
  }

  void _reset() {
    _progress.reset();
    if (_holding) setState(() => _holding = false);
  }

  void _onTap() {
    if (widget.requireHold) {
      HapticFeedback.selectionClick();
      return;
    }
    widget.onConfirm();
  }

  void _onHoldStart() {
    if (!widget.requireHold) return;
    setState(() => _holding = true);
    HapticFeedback.lightImpact();
    _progress.forward(from: 0);
  }

  void _onHoldEnd() {
    if (!widget.requireHold) return;
    if (_progress.status != AnimationStatus.completed) {
      _progress.stop();
      _reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final subtitle = widget.requireHold && widget.subtitle == null
        ? l10n.confirmHoldHint
        : widget.subtitle;

    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: _onTap,
        onLongPressStart: (_) => _onHoldStart(),
        onLongPressEnd: (_) => _onHoldEnd(),
        onLongPressCancel: _onHoldEnd,
        child: Ink(
          decoration: BoxDecoration(
            gradient: widget.gradient,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: widget.gradient.colors.first.withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              if (widget.requireHold)
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _progress,
                    builder: (context, _) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            widthFactor: _progress.value,
                            heightFactor: 1,
                            child: ColoredBox(
                              color: Colors.white.withValues(alpha: 0.22),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: widget.fullWidth ? 16 : 18,
                  horizontal: 16,
                ),
                child: Row(
                  mainAxisAlignment: widget.fullWidth
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.center,
                  children: [
                    Icon(widget.icon, color: Colors.white, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: widget.fullWidth
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.label,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              subtitle,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (widget.requireHold && _holding)
                      const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
