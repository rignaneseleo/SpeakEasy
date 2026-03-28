import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BigButton extends StatelessWidget {
  const BigButton({
    super.key,
    required this.bgColor,
    required this.textColor,
    this.onPressed,
    this.onLongPressed,
    required this.text,
  });

  final Color bgColor;
  final Color textColor;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: MaterialButton(
        elevation: 0,
        minWidth: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        height: 90,
        color: bgColor,
        disabledColor: bgColor.withValues(alpha: 0.6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: onPressed,
        onLongPress: onLongPressed,
        child: AutoSizeText(
          text.toUpperCase(),
          maxLines: 1,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .displayMedium
              ?.copyWith(color: textColor),
        ),
      ),
    );
  }
}

class BigIconButton extends StatelessWidget {
  const BigIconButton({
    super.key,
    required this.bgColor,
    required this.onPressed,
    required this.icon,
    this.size = 90,
    this.smallScreen = false,
  });

  final Color bgColor;
  final VoidCallback onPressed;
  final SvgPicture icon;
  final double size;
  final bool smallScreen;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: MaterialButton(
        minWidth: double.infinity,
        height: smallScreen ? size - 18 : size,
        color: bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: onPressed,
        child: icon,
      ),
    );
  }
}
