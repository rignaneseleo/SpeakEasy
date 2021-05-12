import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:opentabu/theme/theme.dart';
import 'package:opentabu/utils/toast.dart';
import 'package:opentabu/view/analytics_page.dart';
import 'package:opentabu/view/widget/my_scaffold.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoPage extends StatelessWidget {
  //TODO email da codificare con https://www.w3schools.com/tags/ref_urlencode.asp
  static const String emailLeo = "dev.rignaneseleo%2Btabu%40gmail.com";

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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Theme.of(context).canvasColor,
                    ),
                    onPressed: () => Get.back()),
              ),
              Container(height: 60),
              TextButton(
                onPressed: () => showToast("Soon available, but thanks! :)"),
                child: new Text(
                  "🌟  " + "Support".tr(),
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              TextButton(
                onPressed: () =>
                    Get.to(AnalyticsPage(), transition: Transition.upToDown),
                child: new Text(
                  "📊  " + "Analytics".tr(),
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              TextButton(
                onPressed: () =>
                    _launchURL("mailto:$emailLeo?subject=Bug%20tabu%20"),
                child: new Text(
                  "🤯  " + "report_bug".tr(),
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
            ],
          ),
        ),
        new AutoSizeText(
          "Made by",
          maxFontSize: Theme.of(context).textTheme.headline2.fontSize,
          style: Theme.of(context)
              .textTheme
              .headline1
              .copyWith(color: materialPurple),
          maxLines: 1,
        ),
        GestureDetector(
          child: new AutoSizeText(
            "Leonardo Rignanese",
            style: Theme.of(context).textTheme.headline1,
            maxLines: 2,
          ),
          onTap: () async =>
              await _launchURL("https://www.linkedin.com/in/rignaneseleo/"),
        ),
      ]),
    );
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
