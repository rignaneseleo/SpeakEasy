import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:speakeasy/theme/theme.dart';
import 'package:speakeasy/utils/uppercase_text.dart';

class TinyButton extends StatelessWidget {
  final Color textColor;
  final VoidCallback onPressed;
  final String text;

  const TinyButton({
    Key? key,
    required this.textColor,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.only(top: 15),
      child: Center(
        child: GestureDetector(
          child: UpperCaseText(
            text,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: textColor),
          ),
          onTap: onPressed,
        ),
      ),
    );
  }
}
