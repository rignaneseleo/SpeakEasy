import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:speakeasy/theme/theme.dart';
import 'package:speakeasy/utils/toast.dart';
import 'package:speakeasy/view/widget/my_scaffold.dart';
import 'package:url_launcher/url_launcher.dart';

class RulesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var txtStyle = Theme.of(context)
        .textTheme
        .bodyText1
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
              "rules".tr(),
              style: Theme.of(context).textTheme.headline2,
              maxLines: 2,
            ),
            Expanded(
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  Text(
                    "goal".tr(),
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Text(
                    "goalDescription".tr(),
                    style: txtStyle,
                  ),
                  Container(height: 30),
                  Text(
                    "preparation".tr(),
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Text(
                    "preparationDescription".tr(),
                    style: txtStyle,
                  ),
                  Container(height: 30),
                  Text(
                    "game".tr(),
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Text(
                    "gameDescription".tr(),
                    style: txtStyle,
                  ),
                  Container(height: 30),
                  Text(
                    "points".tr(),
                    style: Theme.of(context).textTheme.headline4,
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
}
