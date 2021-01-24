import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(
        "Open\nTabu",
        style: Theme.of(context).textTheme.headline1,
      ),
    );
  }
}
