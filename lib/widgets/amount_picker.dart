import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme.dart';
import '../l10n/app_localizations.dart';

/// Quick presets 250–2000 ml + custom amount field.
class AmountPicker extends StatefulWidget {
  const AmountPicker({
    super.key,
    required this.value,
    required this.onChanged,
    this.presets = const [250, 500, 750, 1000, 1250, 1500, 1750, 2000],
    this.maxMl = 10000,
    this.allowZero = false,
    this.valueLabel,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final List<int> presets;
  final int maxMl;
  final bool allowZero;
  final String Function(int value)? valueLabel;

  @override
  State<AmountPicker> createState() => _AmountPickerState();
}

class _AmountPickerState extends State<AmountPicker> {
  late final TextEditingController _controller;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '${widget.value}');
  }

  @override
  void didUpdateWidget(AmountPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && !_focusNode.hasFocus) {
      _controller.text = '${widget.value}';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String _displayLabel(int v) => widget.valueLabel?.call(v) ?? '$v ml';

  void _setValue(int v) {
    final min = widget.allowZero ? 0 : 1;
    final clamped = v.clamp(min, widget.maxMl);
    widget.onChanged(clamped);
    if (!_focusNode.hasFocus) {
      _controller.text = '$clamped';
    }
  }

  void _onTextChanged(String text) {
    final parsed = int.tryParse(text);
    if (parsed == null) return;
    final min = widget.allowZero ? 0 : 1;
    widget.onChanged(parsed.clamp(min, widget.maxMl));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isPreset = widget.presets.contains(widget.value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final preset in widget.presets)
              _PresetChip(
                label: _displayLabel(preset),
                selected: widget.value == preset,
                onTap: () => _setValue(preset),
              ),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            labelText: l10n.customAmountMl,
            hintText: l10n.customAmountHint,
            suffixText: 'ml',
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.06),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppTheme.primary, width: 2),
            ),
          ),
          onChanged: _onTextChanged,
        ),
        if (!isPreset && widget.value > 0) ...[
          const SizedBox(height: 8),
          Text(
            l10n.selectedAmount(_displayLabel(widget.value)),
            style: const TextStyle(
              color: AppTheme.primary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ],
    );
  }
}

class _PresetChip extends StatelessWidget {
  const _PresetChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: selected
                ? AppTheme.primary
                : Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? AppTheme.primary
                  : Colors.white.withValues(alpha: 0.15),
              width: selected ? 2 : 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.75),
            ),
          ),
        ),
      ),
    );
  }
}
