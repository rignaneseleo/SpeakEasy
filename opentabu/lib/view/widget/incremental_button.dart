import 'dart:async';

import 'package:flutter/material.dart';

import 'package:speakeasy/theme/app_theme.dart';
import 'package:speakeasy/view/widget/selector_button.dart';

class IncrementalButton extends StatefulWidget {
  const IncrementalButton({
    required this.increment,
    required this.onValueChanged,
    required this.initialValue,
    required this.text,
    required this.min,
    required this.max,
    super.key,
    this.smallScreen = false,
  });

  final String text;
  final int increment;
  final int initialValue;
  final int min;
  final int max;
  final bool smallScreen;
  final ValueChanged<int> onValueChanged;

  @override
  State<IncrementalButton> createState() => _IncrementalButtonState();
}

class _IncrementalButtonState extends State<IncrementalButton> {
  late int _value = widget.initialValue;
  Timer? _incrementalTimer;

  @override
  void dispose() {
    _incrementalTimer?.cancel();
    super.dispose();
  }

  void _increment() {
    if (_value + widget.increment > widget.max) return;
    setState(() {
      _value += widget.increment;
      widget.onValueChanged(_value);
    });
  }

  void _decrement() {
    if (_value - widget.increment < widget.min) return;
    setState(() {
      _value -= widget.increment;
      widget.onValueChanged(_value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: widget.smallScreen ? 10.0 : 20),
      decoration: const BoxDecoration(
        color: AppColors.midPurple,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Row(
        children: [
          Expanded(
            child: SelectionItem(
              text: '-${widget.increment}',
              disabled: _value - widget.increment < widget.min,
              onPressed: _decrement,
              onLongPressStart: (_) {
                _incrementalTimer?.cancel();
                _incrementalTimer = Timer.periodic(
                  const Duration(milliseconds: 100),
                  (_) => _decrement(),
                );
              },
              onLongPressEnd: (_) => _incrementalTimer?.cancel(),
            ),
          ),
          Expanded(
            child: SelectionItem(
              text: '$_value ${widget.text}',
              highlighted: true,
            ),
          ),
          Expanded(
            child: SelectionItem(
              text: '+${widget.increment}',
              disabled: _value + widget.increment > widget.max,
              onPressed: _increment,
              onLongPressStart: (_) {
                _incrementalTimer?.cancel();
                _incrementalTimer = Timer.periodic(
                  const Duration(milliseconds: 100),
                  (_) => _increment(),
                );
              },
              onLongPressEnd: (_) => _incrementalTimer?.cancel(),
            ),
          ),
        ],
      ),
    );
  }
}
