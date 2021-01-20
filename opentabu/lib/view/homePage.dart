/*
* OpenTabu is an Open Source game developed by Leonardo Rignanese <dev.rignanese@gmail.com>
* GNU Affero General Public License v3.0: https://choosealicense.com/licenses/agpl-3.0/
* GITHUB: https://github.com/rignaneseleo/OpenTabu
* */
import 'package:flutter/material.dart';
import 'package:opentabu/model/settings.dart';
import 'package:opentabu/persistence/csvDataReader.dart';
import 'package:opentabu/persistence/dataReader.dart';

import 'gamePage.dart';

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
        ),
        body: new Container(
          padding: new EdgeInsets.all(5.0),
          child: new Column(
            children: <Widget>[
              new Text(
                "Set your preferences: ",
                style: new TextStyle(fontSize: 30.0),
              ),
              _settingsContainer,
              new MaterialButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GamePage(_settings)),
                  );
                },
                child: new Text(
                  "START",
                  style: new TextStyle(fontSize: 30.0),
                ),
              ),
              new Text(
                "ALPHA Version 3",
                style: new TextStyle(fontSize: 12.0),
              )
            ],
          ),
        ));
  }

  get _settingsContainer {
    return new Container(
      padding: new EdgeInsets.all(15.0),
      child: new Column(
        children: <Widget>[
          _numberOfTeamsSelector,
          _numberOfTurnsSelector,
          new Divider(),
          _numberOfTaboosSelector,
          _numberOfSkipSelector,
          _secondsPerTurnSelector
        ],
      ),
    );
  }

  get _numberOfTeamsSelector {
    return new Row(
      children: <Widget>[
        new Expanded(
            child: new Text("Teams: ", style: new TextStyle(fontSize: 18.0))),
        new Slider(
            value: _settings.nPlayers.toDouble(),
            divisions: 3,
            min: 2.0,
            max: 5.0,
            onChanged: (value) {
              setState(() {
                _settings.nPlayers = value.toInt();
              });
            }),
        new Container(
          width: 24.0,
          child: new Text(
            _settings.nPlayers.toString(),
          ),
        )
      ],
    );
  }

  get _numberOfTaboosSelector {
    return new Row(
      children: <Widget>[
        new Expanded(
            child: new Text("Taboos: ", style: new TextStyle(fontSize: 18.0))),
        new Slider(
            value: _settings.nTaboos.toDouble(),
            divisions: 3,
            min: 3.0,
            max: 5.0,
            onChanged: (value) {
              setState(() {
                _settings.nTaboos = value.toInt();
              });
            }),
        new Container(
          width: 24.0,
          child: new Text(
            _settings.nTaboos.toString(),
          ),
        )
      ],
    );
  }

  get _numberOfSkipSelector {
    return new Row(
      children: <Widget>[
        new Expanded(
            child: new Text("Skips per turn: ",
                style: new TextStyle(fontSize: 18.0))),
        new Slider(
            value: _settings.nSkip.toDouble(),
            divisions: 10,
            min: 0.0,
            max: 10.0,
            onChanged: (value) {
              setState(() {
                _settings.nSkip = value.toInt();
              });
            }),
        new Container(
          width: 24.0,
          child: new Text(
            _settings.nSkip.toString(),
          ),
        )
      ],
    );
  }

  get _numberOfTurnsSelector {
    return new Row(
      children: <Widget>[
        new Expanded(
            child: new Text("Turns: ", style: new TextStyle(fontSize: 18.0))),
        new Slider(
            value: _settings.nTurns.toDouble(),
            divisions: 17,
            min: 3.0,
            max: 20.0,
            onChanged: (value) {
              setState(() {
                _settings.nTurns = value.toInt();
              });
            }),
        new Container(
          width: 24.0,
          child: new Text(
            _settings.nTurns.toString(),
          ),
        )
      ],
    );
  }

  get _secondsPerTurnSelector {
    return new Row(
      children: <Widget>[
        new Expanded(
            child: new Text("Seconds per turn: ",
                style: new TextStyle(fontSize: 18.0))),
        new Slider(
            value: _settings.turnDurationInSeconds.toDouble(),
            divisions: 15,
            min: 30.0,
            max: 180.0,
            onChanged: (value) {
              setState(() {
                _settings.turnDurationInSeconds = value.toInt();
              });
            }),
        new Container(
          width: 24.0,
          child: new Text(
            _settings.turnDurationInSeconds.toString(),
          ),
        )
      ],
    );
  }
}
