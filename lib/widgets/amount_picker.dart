import 'package:flutter/material.dart';

import '../core/theme.dart';

/// Kołowy wybór ilości ml z podglądem wybranej wartości i szybkimi skrótami.
class AmountPicker extends StatefulWidget {
  const AmountPicker({
    super.key,
    required this.value,
    required this.onChanged,
    this.values,
    this.quickValues = const [250, 500, 750, 1000],
    this.labelBuilder,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final List<int>? values;
  final List<int> quickValues;
  final String Function(int value)? labelBuilder;

  @override
  State<AmountPicker> createState() => _AmountPickerState();
}

class _AmountPickerState extends State<AmountPicker> {
  late final List<int> _values;
  late FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();
    _values = widget.values ??
        List.generate(20, (index) => (index + 1) * 50);
    final initialIndex = _values.indexOf(widget.value);
    _controller = FixedExtentScrollController(
      initialItem: initialIndex >= 0 ? initialIndex : 0,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _label(int v) => widget.labelBuilder?.call(v) ?? '$v ml';

  void _select(int index) {
    final v = _values[index];
    widget.onChanged(v);
    _controller.animateToItem(
      index,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: AppTheme.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.primary.withValues(alpha: 0.35),
            ),
          ),
          child: Column(
            children: [
              Text(
                'Wybrano',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.55),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _label(widget.value),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppTheme.primary,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            for (final quick in widget.quickValues)
              if (_values.contains(quick))
                ChoiceChip(
                  label: Text(_label(quick)),
                  selected: widget.value == quick,
                  onSelected: (_) => _select(_values.indexOf(quick)),
                  selectedColor: AppTheme.primary.withValues(alpha: 0.25),
                  labelStyle: TextStyle(
                    fontWeight: widget.value == quick
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: widget.value == quick
                        ? AppTheme.primary
                        : Colors.white70,
                  ),
                  side: BorderSide(
                    color: widget.value == quick
                        ? AppTheme.primary
                        : Colors.white24,
                  ),
                ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 160,
          child: Stack(
            alignment: Alignment.center,
            children: [
              ListWheelScrollView.useDelegate(
                controller: _controller,
                itemExtent: 44,
                diameterRatio: 1.4,
                perspective: 0.003,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: (index) {
                  widget.onChanged(_values[index]);
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: _values.length,
                  builder: (context, index) {
                    final v = _values[index];
                    final selected = v == widget.value;
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _select(index),
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 150),
                          style: TextStyle(
                            fontSize: selected ? 24 : 17,
                            fontWeight:
                                selected ? FontWeight.w800 : FontWeight.w400,
                            color: selected
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.35),
                          ),
                          child: Text(_label(v)),
                        ),
                      ),
                    );
                  },
                ),
              ),
              IgnorePointer(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 44,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: AppTheme.primary.withValues(alpha: 0.45),
                          ),
                          bottom: BorderSide(
                            color: AppTheme.primary.withValues(alpha: 0.45),
                          ),
                        ),
                        color: AppTheme.primary.withValues(alpha: 0.06),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
