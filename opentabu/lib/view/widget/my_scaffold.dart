import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class MyScaffold extends StatelessWidget {
  final List<Widget> widgets;
  Widget? topRightWidget;
  Widget? topLeftWidget;

  MyScaffold({
    Key? key,
    required this.widgets,
    this.topRightWidget,
    this.topLeftWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  topLeftWidget ?? Container(),
                  topRightWidget ?? Container(),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 28,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: widgets,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildLine(context, {required String text, dynamic value, onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: new Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: txtWhite),
            ),
          ),
          if (value != null)
            Text(value.toString(),
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: txtWhite)),
        ],
      ),
    ),
  );
}
