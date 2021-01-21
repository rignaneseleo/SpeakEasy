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
import 'package:opentabu/persistence/csvDataReader.dart';
import 'package:opentabu/persistence/dataReader.dart';
import 'package:opentabu/view/widget/myContainer.dart';

import 'gamePage.dart';
import 'infoPage.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
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
          new Divider(height: 20,thickness: 2),
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
      margin: EdgeInsets.only(left: 5,right: 8),
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
