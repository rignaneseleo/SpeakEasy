import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:speakeasy/main.dart';

class BigButton extends StatelessWidget {
  final Color bgColor;
  final Color textColor;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPressed;
  final String text;

  const BigButton(
      {Key? key,
      required this.bgColor,
      required this.textColor,
      this.onPressed,
      this.onLongPressed,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: MaterialButton(
        elevation: 0,
        minWidth: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        height: 90,
        child: AutoSizeText(
          text.toUpperCase(),
          maxLines: 1,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .displayMedium
              ?.copyWith(color: textColor),
        ),
        color: bgColor,
        disabledColor: bgColor.withOpacity(0.6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: onPressed,
        onLongPress: onLongPressed,
      ),
    );
  }
}

class BigIconButton extends StatelessWidget {
  final Color bgColor;
  final VoidCallback onPressed;
  final SvgPicture icon;
  final double size;

  const BigIconButton(
      {Key? key,
      required this.bgColor,
      required this.onPressed,
      required this.icon,
      this.size = 90})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: MaterialButton(
          minWidth: double.infinity,
          height: (smallScreen ? size - 18 : size),
          child: icon,
          color: bgColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          onPressed: onPressed),
    );
  }
}
