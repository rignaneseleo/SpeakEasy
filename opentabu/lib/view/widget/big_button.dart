import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:opentabu/theme/theme.dart';
import 'package:opentabu/utils/uppercase_text.dart';

class BigButton extends StatelessWidget {
  final Color bgColor;
  final Color textColor;
  final VoidCallback onPressed;
  final String text;

  const BigButton(
      {Key key, this.bgColor, this.textColor, this.onPressed, this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: MaterialButton(
          elevation: 0,
          minWidth: double.infinity,
          height: 90,
          child: UpperCaseText(
            text,
            style: Theme.of(context)
                .textTheme
                .headline2
                .copyWith(color: textColor),
          ),
          color: bgColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          onPressed: onPressed),
    );
  }
}

class BigIconButton extends StatelessWidget {
  final Color bgColor;
  final VoidCallback onPressed;
  final Image icon;
  final double size;

  const BigIconButton(
      {Key key, this.bgColor, this.onPressed, this.icon, this.size = 90})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: MaterialButton(
          minWidth: double.infinity,
          height: size,
          child: icon,
          color: bgColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          onPressed: onPressed),
    );
  }
}
