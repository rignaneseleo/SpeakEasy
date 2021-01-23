/*
* OpenTabu is an Open Source game developed by Leonardo Rignanese <dev.rignanese@gmail.com>
* GNU Affero General Public License v3.0: https://choosealicense.com/licenses/agpl-3.0/
* GITHUB: https://github.com/rignaneseleo/OpenTabu
* */
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opentabu/model/settings.dart';
import 'package:opentabu/persistence/csv_data_reader.dart';
import 'package:opentabu/persistence/data_reader.dart';
import 'package:opentabu/theme/theme.dart';
import 'package:opentabu/utils/uppercase_text.dart';
import 'package:opentabu/view/widget/incremental_button.dart';
import 'package:opentabu/view/widget/my_scaffold.dart';
import 'package:opentabu/view/widget/my_title.dart';
import 'package:opentabu/view/widget/my_container.dart';
import 'package:opentabu/view/widget/big_button.dart';
import 'package:opentabu/view/widget/selector_button.dart';
import 'package:opentabu/view/widget/tiny_button.dart';

import 'game_page.dart';
import 'info_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  Settings _settings;

  bool _displayAdvancedPreferences = false;

  HomePageState() {
    _settings = new Settings();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: MyScaffold(
          widgets: <Widget>[
            MyTitle(),
            SelectorButton(
              indexSelected: 0,
              items: [
                "2 Teams",
                "3 Teams",
                "4 Teams",
                "5 Teams",
              ],
              onValueChanged: (i) {
                print("Team number set to ${i + 2}");
                _settings.nPlayers = i + 2;
              },
            ),
            Center(
              child: TinyButton(
                text:
                    "${_displayAdvancedPreferences ? "↓" : "↑"} ADVANCED PREFERENCES",
                textColor: txtGrey,
                onPressed: () => setState(() =>
                    _displayAdvancedPreferences = !_displayAdvancedPreferences),
              ),
            ),
            if (_displayAdvancedPreferences)
              SelectorButton(
                indexSelected: _settings.nTaboos - 3,
                items: [
                  "3 Taboos",
                  "4 Taboos",
                  "5 Taboos",
                ],
                onValueChanged: (i) {
                  print("Taboo number set to ${i + 3}");
                  _settings.nTaboos = i + 3;
                },
              ),
            if (_displayAdvancedPreferences)
              IncrementalButton(
                increment: 1,
                initialValue: _settings.nTurns,
                text: "Turns",
                min: 3,
                max: 20,
                onValueChanged: (i) {
                  _settings.nTurns = i;
                },
              ),
            if (_displayAdvancedPreferences)
              IncrementalButton(
                increment: 10,
                text: "Seconds",
                min: kReleaseMode ? 30 : 5,
                max: 180,
                initialValue: _settings.turnDurationInSeconds,
                onValueChanged: (i) {
                  _settings.turnDurationInSeconds = i;
                },
              ),
            if (_displayAdvancedPreferences)
              IncrementalButton(
                increment: 1,
                initialValue: _settings.nSkip,
                text: "Skips",
                min: 0,
                max: 10,
                onValueChanged: (i) {
                  _settings.nSkip = i;
                },
              ),
            BigButton(
              text: "start",
              bgColor: lightPurple,
              textColor: txtWhite,
              onPressed: () => Get.to(GamePage(_settings)),
            ),
          ],
        ),
        onVerticalDragUpdate: (details) {
          // Note: Sensitivity is integer used when you don't want to mess up vertical drag
          if (details.delta.dy > 10) {
            setState(() {
              _displayAdvancedPreferences = false;
            });
          } else if (details.delta.dy < -10) {
            setState(() {
              _displayAdvancedPreferences = true;
            });
          }
        });
  }
}
