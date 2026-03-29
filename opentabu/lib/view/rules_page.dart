import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:speakeasy/theme/app_theme.dart';
import 'package:speakeasy/view/widget/app_scaffold.dart';

class RulesPage extends StatelessWidget {
  const RulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final txtStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: AppColors.txtWhite,
          height: 1.8,
          fontWeight: FontWeight.normal,
        );

    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.delta.dy < -8) context.pop();
      },
      child: AppScaffold(
        topLeftWidget: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Theme.of(context).canvasColor,
          ),
          onPressed: () => context.pop(),
        ),
        widgets: [
          AutoSizeText(
            'Rules'.tr(),
            style: Theme.of(context).textTheme.displayMedium,
            maxLines: 2,
          ),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                Text(
                  'goal'.tr(),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text('goalDescription'.tr(), style: txtStyle),
                const SizedBox(height: 30),
                Text(
                  'preparation'.tr(),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text('preparationDescription'.tr(), style: txtStyle),
                const SizedBox(height: 30),
                Text(
                  'game'.tr(),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text('gameDescription'.tr(), style: txtStyle),
                const SizedBox(height: 30),
                Text(
                  'points'.tr(),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text('pointsDescription'.tr(), style: txtStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
