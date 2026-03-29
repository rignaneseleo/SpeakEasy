import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:speakeasy/provider/analytics_provider.dart';
import 'package:speakeasy/theme/app_theme.dart';
import 'package:speakeasy/view/widget/app_scaffold.dart';

class AnalyticsPage extends ConsumerWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.watch(analyticsControllerProvider);

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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  'Analytics'.tr(),
                  style: Theme.of(context).textTheme.displayMedium,
                  maxLines: 2,
                ),
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Text(
                        'Match'.tr().toUpperCase(),
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(color: AppColors.myYellow),
                      ),
                      SettingsLine(
                        text: '#Played'.tr(),
                        value: analytics.matchesPlayed,
                      ),
                      SettingsLine(
                        text: 'Correct'.tr(),
                        value: analytics.correctAnswers,
                      ),
                      SettingsLine(
                        text: 'Wrong'.tr(),
                        value: analytics.wrongAnswers,
                      ),
                      SettingsLine(
                        text: 'Skips'.tr(),
                        value: analytics.skipsUsed,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
