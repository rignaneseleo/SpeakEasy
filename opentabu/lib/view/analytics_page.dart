import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:opentabu/controller/analytics_controller.dart';
import 'package:opentabu/main.dart';
import 'package:opentabu/theme/theme.dart';
import 'package:opentabu/utils/toast.dart';
import 'package:opentabu/view/widget/my_scaffold.dart';
import 'package:url_launcher/url_launcher.dart';

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
      child: MyScaffold(widgets: [
        //new Text("VERSIONE ${Weco.AppVersion}"),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Theme.of(context).canvasColor,
                      ),
                      onPressed: () => Get.back()),
                ),
              ),
              Container(height: 60),
              new AutoSizeText(
                "Analytics",
                style: Theme.of(context).textTheme.headline2,
                maxLines: 1,
              ),
              Container(height: 60),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "Match".tr().toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .headline3
                        ?.copyWith(color: myYellow),
                  ),
                  buildFutureLine(
                    context,
                    name: "#Played".tr(),
                    value: AnalyticsController.getStartedMatches(),
                  ),
                  buildFutureLine(
                    context,
                    name: "Correct".tr(),
                    value: AnalyticsController.getCorrectAnswers(),
                  ),
                  buildFutureLine(
                    context,
                    name: "Wrong".tr(),
                    value: AnalyticsController.getWrongAnswers(),
                  ),
                  buildFutureLine(
                    context,
                    name: "Skips".tr(),
                    value: AnalyticsController.getSkipUsed(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget buildLine(context, {required String name, value}) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: new Text(
            name.tr(),
            style: Theme.of(context)
                .textTheme
                .headline4
                ?.copyWith(color: txtWhite),
          ),
        ),
        Text(value.toString(),
            style: Theme.of(context)
                .textTheme
                .headline4
                ?.copyWith(color: txtWhite)),
      ],
    );
  }

  Widget buildFutureLine(context,
      {required String name, required Future<int> value}) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: AutoSizeText(
            name,
            maxFontSize: Theme.of(context).textTheme.headline4?.fontSize ?? 25,
            style: Theme.of(context)
                .textTheme
                .headline4
                ?.copyWith(color: txtWhite),
          ),
        ),
        FutureBuilder(
          future: value,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      ?.copyWith(color: txtWhite));
            }
            return Text("...",
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    ?.copyWith(color: txtWhite));
          },
        )
      ],
    );
  }
}
