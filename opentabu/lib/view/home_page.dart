/*
* OpenTabu is an Open Source game developed by Leonardo Rignanese <dev.rignanese@gmail.com>
* GNU Affero General Public License v3.0: https://choosealicense.com/licenses/agpl-3.0/
* GITHUB: https://github.com/rignaneseleo/OpenTabu
* */
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:speakeasy/controller/analytics_controller.dart';
import 'package:speakeasy/model/settings.dart';
import 'package:speakeasy/providers/shared_pref_provider.dart';
import 'package:speakeasy/theme/theme.dart';
import 'package:speakeasy/view/widget/big_button.dart';
import 'package:speakeasy/view/widget/incremental_button.dart';
import 'package:speakeasy/view/widget/my_scaffold.dart';
import 'package:speakeasy/view/widget/my_title.dart';
import 'package:speakeasy/view/widget/selector_button.dart';
import 'package:speakeasy/view/widget/tiny_button.dart';
import 'package:simple_animations/simple_animations.dart';

import '../main.dart';
import 'game_page.dart';
import 'settings_page.dart';

class HomePage extends ConsumerStatefulWidget {
  @override
createState() {
    return HomePageState();
  }
}

class HomePageState extends ConsumerState<HomePage> with AnimationMixin {
  late Settings _settings;

  late Animation<double> sizeMenuItems;
  bool _displayAdvancedPreferences = false;

  HomePageState() {
    _settings = new Settings();
  }

  @override
  void initState() {
    sizeMenuItems = Tween(begin: 0.00000001, end: 5000.0).animate(controller);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: MyScaffold(
        topLeftWidget: GestureDetector(
          child: Icon(
            Icons.settings,
            color: txtWhite,
            size: 28,
          ),
          onTap: () =>
              Get.to(() => SettingsPage(), transition: Transition.upToDown),
        ),
        topRightWidget: AnalyticsController.getStartedMatches() == 0 ||
                (ref.read(sharedPreferencesProvider).getBool("1000words") ?? false)
            ? null
            : GestureDetector(
                child: Text(
                  "More words".tr() + "?",
                  style: TextStyle(
                    color: txtWhite,
                    fontSize: 18,
                  ),
                ),
                onTap: () => Get.to(() => SettingsPage(openPaymentDialog: true),
                    transition: Transition.upToDown),
              ),
        widgets: <Widget>[
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ListView(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                children: [
                  MyTitle(),
                  SelectorButton(
                    indexSelected: 0,
                    items: [
                      '#Teams'.tr(args: ['2']),
                      '#Teams'.tr(args: ['3']),
                      '#Teams'.tr(args: ['4']),
                      '#Teams'.tr(args: ['5']),
                    ],
                    onValueChanged: (i) {
                      print("Team number set to ${i + 2}");
                      _settings.nPlayers = i + 2;
                    },
                  ),
                  Center(
                    child: TinyButton(
                      text: "advanced_preferences"
                          .tr(args: [_displayAdvancedPreferences ? "↓" : "↑"]),
                      textColor: txtGrey,
                      onPressed: () {
                        if (_displayAdvancedPreferences) {
                          controller.playReverse(
                              duration: Duration(milliseconds: 100));
                        } else {
                          controller.play(
                              duration: Duration(milliseconds: 100));
                        }
                        _displayAdvancedPreferences =
                            !_displayAdvancedPreferences;
                      },
                    ),
                  ),
                  SizedBox(
                    height: sizeMenuItems.value / 100,
                    child: SelectorButton(
                      indexSelected: _settings.nTaboos - 3,
                      items: [
                        '#Taboos'.tr(args: ['3']),
                        '#Taboos'.tr(args: ['4']),
                        '#Taboos'.tr(args: ['5']),
                      ],
                      onValueChanged: (i) {
                        print("Taboo number set to ${i + 3}");
                        _settings.nTaboos = i + 3;
                      },
                    ),
                  ),
                  SizedBox(
                    height: sizeMenuItems.value / 100,
                    child: IncrementalButton(
                      increment: 1,
                      initialValue: _settings.nTurns,
                      text: "Turns".tr(),
                      min: 3,
                      max: 20,
                      onValueChanged: (i) {
                        _settings.nTurns = i;
                      },
                    ),
                  ),
                  SizedBox(
                    height: sizeMenuItems.value / 100,
                    child: IncrementalButton(
                      increment: 10,
                      text: "Sec".tr(),
                      min: kReleaseMode ? 30 : 5,
                      max: 180,
                      initialValue: _settings.turnDurationInSeconds,
                      onValueChanged: (i) {
                        _settings.turnDurationInSeconds = i;
                      },
                    ),
                  ),
                  SizedBox(
                    height: sizeMenuItems.value / 100,
                    child: IncrementalButton(
                      increment: 1,
                      initialValue: _settings.nSkip,
                      text: "Skips".tr(),
                      min: 0,
                      max: 10,
                      onValueChanged: (i) {
                        _settings.nSkip = i;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          BigButton(
            text: "Start".tr(),
            bgColor: lightPurple,
            textColor: txtWhite,
            onPressed: () async {
              AnalyticsController.addNewMatch();
              await Get.to(() => GamePage(_settings),
                  transition: Transition.downToUp);
              return;
            },
          ),
        ],
      ),
      onVerticalDragUpdate: (details) {
        // Note: Sensitivity is integer used when you don't want to mess up vertical drag
        if (details.delta.dy > 10) {
          controller.playReverse(duration: Duration(milliseconds: 100));
        } else if (details.delta.dy < -10) {
          controller.play(duration: Duration(milliseconds: 100));
        }
      },
    );
  }
}
