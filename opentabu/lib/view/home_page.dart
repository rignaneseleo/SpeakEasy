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
import 'package:opentabu/view/widget/my_bigbutton.dart';
import 'package:opentabu/view/widget/my_selector_button.dart';
import 'package:opentabu/view/widget/my_tiny_button.dart';

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
            MySelectorButton(
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
              child: MyTinyButton(
                text:
                    "${_displayAdvancedPreferences ? "↓" : "↑"} ADVANCED PREFERENCES",
                textColor: txtGrey,
                onPressed: () => setState(() =>
                    _displayAdvancedPreferences = !_displayAdvancedPreferences),
              ),
            ),
            if (_displayAdvancedPreferences)
              MySelectorButton(
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
            MyBigButton(
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

class HomePageStateOld extends State<HomePage> {
  Settings _settings;

  HomePageState() {
    _settings = new Settings();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Tabu"),
          actions: [
            IconButton(
                icon: Icon(Icons.info),
                onPressed: () {
                  Get.to(InfoPage());
                })
          ],
        ),
        body: MyContainer(
          header: Text(
            "Game preferences",
            style: new TextStyle(fontSize: 30.0),
          ),
          body: _settingsContainer,
          footer: Column(
            children: <Widget>[
              MyBottomButton(
                text: "START",
                onPressed: () => Get.to(GamePage(_settings)),
              ),
            ],
          ),
        ));
  }

  get _settingsContainer {
    return new Container(
      padding: new EdgeInsets.all(15.0),
      child: new ListView(
        children: <Widget>[
          buildItem(
              title: "👥 Teams",
              value: _settings.nPlayers.toDouble(),
              divisions: 3,
              min: 2.0,
              max: 5.0,
              onChanged: (value) {
                setState(() {
                  _settings.nPlayers = value.toInt();
                });
              }),
          buildItem(
            title: "🗣 Turns",
            value: _settings.nTurns.toDouble(),
            divisions: 17,
            min: 3.0,
            max: 20.0,
            onChanged: (value) {
              setState(() {
                _settings.nTurns = value.toInt();
              });
            },
          ),
          new Divider(height: 20, thickness: 2),
          buildItem(
              title: "🙊 Taboos",
              value: _settings.nTaboos.toDouble(),
              divisions: 3,
              min: 3.0,
              max: 5.0,
              onChanged: (value) {
                setState(() {
                  _settings.nTaboos = value.toInt();
                });
              }),
          buildItem(
            title: "🔛 Skips per turn",
            value: _settings.nSkip.toDouble(),
            divisions: 10,
            min: 0.0,
            max: 10.0,
            onChanged: (value) {
              setState(() {
                _settings.nSkip = value.toInt();
              });
            },
          ),
          buildItem(
            title: "⏱ Seconds per turn",
            value: _settings.turnDurationInSeconds.toDouble(),
            min: kReleaseMode ? 30 : 5,
            max: 180,
            divisions: 15,
            onChanged: (value) {
              setState(() {
                _settings.turnDurationInSeconds = value.toInt();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget buildItem(
      {String title,
      ValueChanged<double> onChanged,
      double value,
      double min,
      double max,
      int divisions}) {
    return Container(
      margin: EdgeInsets.only(left: 5, right: 8),
      height: 100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              title,
              style: new TextStyle(fontSize: 22.0),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 2,
                  fit: FlexFit.loose,
                  child: AutoSizeText(
                    value.toInt().toString(),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: TextStyle(fontSize: 35),
                    maxFontSize: 50,
                  ),
                ),
                Flexible(
                  flex: 6,
                  fit: FlexFit.tight,
                  child: SliderTheme(
                    data: SliderThemeData(
                      trackShape: CustomTrackShape(),
                    ),
                    child: Slider(
                      value: value,
                      divisions: divisions,
                      min: min,
                      max: max,
                      onChanged: (value) => onChanged(value),
                    ),
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

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
