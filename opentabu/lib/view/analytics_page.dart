import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:speakeasy/controller/analytics_controller.dart';
import 'package:speakeasy/theme/theme.dart';
import 'package:speakeasy/view/widget/my_scaffold.dart';

class AnalyticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        int sensitivity = 8;
        if (details.delta.dy < -sensitivity) {
          // Up Swipe
          Get.back();
        }
      },
      child: MyScaffold(
          topLeftWidget: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Theme.of(context).canvasColor,
            ),
            onPressed: () => Get.back(),
          ),
          widgets: [
            //new Text("VERSIONE ${Weco.AppVersion}"),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  new AutoSizeText(
                    "Analytics".tr(),
                    style: Theme.of(context).textTheme.displayMedium,
                    maxLines: 2,
                  ),
                  Expanded(
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      children: [
                        Text(
                          "Match".tr().toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(color: myYellow),
                        ),
                        buildLine(
                          context,
                          text: "#Played".tr(),
                          value: AnalyticsController.getStartedMatches(),
                        ),
                        buildLine(
                          context,
                          text: "Correct".tr(),
                          value: AnalyticsController.getCorrectAnswers(),
                        ),
                        buildLine(
                          context,
                          text: "Wrong".tr(),
                          value: AnalyticsController.getWrongAnswers(),
                        ),
                        buildLine(
                          context,
                          text: "Skips".tr(),
                          value: AnalyticsController.getSkipUsed(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]),
    );
  }
}
