import 'dart:async';

import 'package:flutter/material.dart';

class BlinkingText extends StatefulWidget {
  const BlinkingText({super.key, required this.child});

  final Text child;

  @override
  State<BlinkingText> createState() => _BlinkingTextState();
}

class _BlinkingTextState extends State<BlinkingText> {
  bool _visible = true;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 800), (_) {
      setState(() => _visible = !_visible);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = _visible
        ? widget.child.style
        : widget.child.style?.copyWith(color: Colors.transparent);
    return Text(widget.child.data!, style: style);
  }
}
