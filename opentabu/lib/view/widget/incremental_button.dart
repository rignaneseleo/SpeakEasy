import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:opentabu/main.dart';
import 'package:opentabu/theme/theme.dart';

import 'selector_button.dart';

class IncrementalButton extends StatefulWidget {
  final String text;
  final int increment;
  final int initialValue;
  final int min;
  final int max;
  final ValueChanged<int> onValueChanged;

  const IncrementalButton(
      {Key key,
      this.increment,
      this.onValueChanged,
      this.initialValue,
      this.text,
      this.min,
      this.max})
      : super(key: key);

  @override
  _IncrementalButtonState createState() =>
      _IncrementalButtonState(initialValue);
}

class _IncrementalButtonState extends State<IncrementalButton> {
  int _value;
  Timer incrementalTimer;

  _IncrementalButtonState(this._value);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: smallScreen ? 10.0 : 20),
      decoration: new BoxDecoration(
        color: midPurple,
        borderRadius: new BorderRadius.all(
          const Radius.circular(10.0),
        ),
      ),
      height: 32,
      padding: EdgeInsets.symmetric(horizontal: 3),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SelectionItem(
              text: "-${widget.increment}",
              highlighted: false,
              disabled: _value - widget.increment < widget.min,
              onPressed: () => decrementCounter(),
              onLongPressStart: (_) {
                incrementalTimer?.cancel();
                incrementalTimer = new Timer.periodic(
                    Duration(milliseconds: 100), (_) => decrementCounter());
              },
              onLongPressEnd: (_) {
                incrementalTimer?.cancel();
              },
            ),
          ),
          Expanded(
            child: SelectionItem(
              text: "$_value ${widget.text}",
              highlighted: true,
            ),
          ),
          Expanded(
            child: SelectionItem(
              text: "+${widget.increment}",
              highlighted: false,
              disabled: _value + widget.increment > widget.max,
              onPressed: () => incrementCounter(),
              onLongPressStart: (_) {
                incrementalTimer?.cancel();
                incrementalTimer = new Timer.periodic(
                    Duration(milliseconds: 100), (_) => incrementCounter());
              },
              onLongPressEnd: (_) {
                incrementalTimer?.cancel();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    incrementalTimer?.cancel();
    super.dispose();
  }

  void incrementCounter() {
    if (_value + widget.increment > widget.max) return;

    setState(() {
      _value += widget.increment;
      widget.onValueChanged(_value);
    });
  }

  void decrementCounter() {
    if (_value - widget.increment < widget.min) return;

    setState(() {
      _value -= widget.increment;
      widget.onValueChanged(_value);
    });
  }
}
