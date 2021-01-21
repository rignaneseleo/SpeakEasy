import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyContainer extends StatelessWidget {
  final Widget header;
  final Widget body;
  final Widget footer;

  const MyContainer({Key key, this.header, this.body, this.footer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          header,
          Expanded(child: body),
          Divider(
            height: 10,
          ),
          footer,
        ],
      ),
    );
  }
}

class MyBottomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const MyBottomButton({Key key, this.text, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 50),
      ),
      onPressed: onPressed,
    );
  }
}
