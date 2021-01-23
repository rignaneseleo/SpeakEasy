import 'dart:async';

import 'package:flutter/material.dart';

class BlinkingText extends StatefulWidget {
  final Text _target;

  BlinkingText(this._target);

  @override
  BlinkingTextState createState() => BlinkingTextState();
}

class BlinkingTextState extends State<BlinkingText> {
  bool _show = true;
  Timer _timer;

  @override
  void initState() {
    _timer = Timer.periodic(Duration(milliseconds: 800), (_) {
      setState(() => _show = !_show);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style;

    if (_show)
      style = widget._target.style;
    else
      style = widget._target.style.copyWith(color: Colors.transparent);

    return Text(widget._target.data, style: style);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
