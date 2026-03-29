import 'package:flutter/material.dart';

import 'package:speakeasy/theme/app_theme.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.widgets, super.key,
    this.topRightWidget,
    this.topLeftWidget,
  });

  final List<Widget> widgets;
  final Widget? topRightWidget;
  final Widget? topLeftWidget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  topLeftWidget ?? const SizedBox.shrink(),
                  topRightWidget ?? const SizedBox.shrink(),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
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

class SettingsLine extends StatelessWidget {
  const SettingsLine({
    required this.text, super.key,
    this.value,
    this.onTap,
  });

  final String text;
  final dynamic value;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: AppColors.txtWhite),
              ),
            ),
            if (value != null)
              Text(
                value.toString(),
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: AppColors.txtWhite),
              ),
          ],
        ),
      ),
    );
  }
}
