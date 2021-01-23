import 'package:flutter/material.dart';

class MyScaffold extends StatelessWidget {
  final List<Widget> widgets;

  const MyScaffold({Key key, this.widgets}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        color: Theme.of(context).primaryColor,
        child: Container(
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
      ),
    );
  }
}
