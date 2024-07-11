import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:speakeasy/theme/theme.dart';
import 'package:speakeasy/view/widget/my_scaffold.dart';

class RulesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var txtStyle = Theme.of(context)
        .textTheme
        .bodyLarge
        ?.copyWith(color: txtWhite, height: 1.8, fontWeight: FontWeight.normal);

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
            new AutoSizeText(
              "Rules".tr(),
              style: Theme.of(context).textTheme.displayMedium,
              maxLines: 2,
            ),
            Expanded(
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  Text(
                    "goal".tr(),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    "goalDescription".tr(),
                    style: txtStyle,
                  ),
                  Container(height: 30),
                  Text(
                    "preparation".tr(),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    "preparationDescription".tr(),
                    style: txtStyle,
                  ),
                  Container(height: 30),
                  Text(
                    "game".tr(),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    "gameDescription".tr(),
                    style: txtStyle,
                  ),
                  Container(height: 30),
                  Text(
                    "points".tr(),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    "pointsDescription".tr(),
                    style: txtStyle,
                  ),
                ],
              ),
            ),
          ]),
    );
  }

 /* Widget buildLine(BuildContext context,
      {required String name, required String value}) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: new Text(
            name.tr(),
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: txtWhite),
          ),
        ),
        Text(value.toString(),
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: txtWhite)),
      ],
    );
  }*/
}
