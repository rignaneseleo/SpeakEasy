import 'package:flutter/material.dart';
import 'package:opentabu/theme/theme.dart';

class MyScaffold extends StatelessWidget {
  final List<Widget> widgets;
  final Widget topIcon;

  const MyScaffold({Key key, this.widgets, this.topIcon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        color: Theme.of(context).primaryColor,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 28,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: widgets,
              ),
            ),
            Positioned(
              child: SafeArea(child: topIcon ?? Container()),
              right: 10,
              top: 10,
            ),
          ],
        ),
      ),
    );
  }
}
