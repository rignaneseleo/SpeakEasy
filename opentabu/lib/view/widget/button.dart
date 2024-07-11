import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:speakeasy/main.dart';
import 'package:speakeasy/theme/theme.dart';
import 'package:speakeasy/utils/uppercase_text.dart';

class Button extends StatelessWidget {
  final Color bgColor;
  final Color textColor;
  final VoidCallback onPressed;
  final String text;
  final Icon icon;

  const Button({
    Key? key,
    required this.bgColor,
    required this.textColor,
    required this.onPressed,
    required this.text,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: MaterialButton(
          elevation: 0,
          minWidth: double.infinity,
          height: 40,
          child: Column(
            children: [
              if (icon != null) icon,
              AutoSizeText(
                text.toUpperCase(),
                maxLines: 1,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: textColor),
              ),
            ],
          ),
          color: bgColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          onPressed: onPressed),
    );
  }
}
