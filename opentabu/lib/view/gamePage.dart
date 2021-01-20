/*
* OpenTabu is an Open Source game developed by Leonardo Rignanese <dev.rignanese@gmail.com>
* GNU Affero General Public License v3.0: https://choosealicense.com/licenses/agpl-3.0/
* GITHUB: https://github.com/rignaneseleo/OpenTabu
* */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:opentabu/controller/gameController.dart';
import 'package:opentabu/model/settings.dart';
import 'package:opentabu/model/word.dart';

import '../main.dart';

class GamePage extends StatefulWidget {
  final Settings _settings;

  GamePage(this._settings);

  @override
  State<StatefulWidget> createState() {
    return new GamePageState(_settings);
  }
}

class GamePageState extends State<GamePage> {
  Widget _body;

  GameController _gameController;
  Timer _turnTimer;
  Timer _countSecondsTimer;
  int _timerDuration;
  int _nTaboosToShow;

  //info to show:
  Map<String, int> matchInfo; //team name, score

  GamePageState(Settings settings) {
    _gameController = new GameController(settings, words);
    _timerDuration = settings.turnDurationInSeconds;
    _nTaboosToShow = settings.nTaboos;

    initTimer();

    _countSecondsTimer = new Timer.periodic(
        new Duration(seconds: 1),
        (timer) => _turnTimer.isActive
            ? setState(() => _gameController.oneSecPassed())
            : null);
  }

  void initTimer() {
    _turnTimer = new Timer(new Duration(seconds: _timerDuration), timeOut);
  }

  @override
  Widget build(BuildContext context) {
    _body = new Container(
        height: 520.0,
        child: new Column(children: <Widget>[
          _turns,
          _time,
          _word,
          new Divider(height: 10.0),
          _buttons
        ]));

    return new Material(
      child: new Column(
        children: <Widget>[
          _gameInfo,
          new Divider(height: 1.0),
          _body,
        ],
      ),
    );
  }

  get _time {
    return new Center(
      child: new Text(
        (_timerDuration - _gameController.secondsPassed).toString(),
        style: new TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: _timerDuration - _gameController.secondsPassed < 8
                ? Colors.red
                : Colors.black),
      ),
    );
  }

  get _turns {
    return new Center(
      child: new Text(
        "Turn " + (_gameController.currentTurn).toString(),
        style: new TextStyle(fontSize: 18.0, color: Colors.black54),
      ),
    );
  }

  get _gameInfo {
    List<Widget> teams = new List<Widget>();

    for (int i = 0; i < _gameController.numberOfPlayers; i++) {
      teams.add(new Expanded(
          child: new Column(
        children: <Widget>[
          new Text(
            "Team " + (i + 1).toString(),
            style: new TextStyle(
                fontSize: _gameController.currentTeam == i ? 17.0 : 13.0,
                //fontWeight: _gameController.currentTeam == i ? FontWeight.bold : FontWeight.normal,
                color: _gameController.currentTeam == i
                    ? Colors.red
                    : Colors.black),
          ),
          new Text(
            _gameController.scores[i].toString(),
            style: new TextStyle(
              fontSize: _gameController.currentTeam == i ? 28.0 : 22.0,
            ),
          )
        ],
      )));
    }

    return new Container(
      height: 70.0,
      padding: new EdgeInsets.all(8.0),
      child: new Row(
        children: teams,
      ),
    );
  }

  get _word {
    List<Widget> taboos = new List<Widget>();

    List<String> _taboos = _gameController.currentWord.taboos;

    for (int i = 0; i < _nTaboosToShow; i++) {
      taboos.add(new Text(
        _taboos[i],
        style: new TextStyle(fontSize: 35.0, color: Colors.black54),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ));
    }

    return new Expanded(
        child: new Container(
      padding: new EdgeInsets.all(15.0),
      child: new Column(
        children: <Widget>[
          new Padding(
              padding: new EdgeInsets.symmetric(vertical: 20.0),
              child: new Text(
                _gameController.currentWord.wordToGuess,
                style: new TextStyle(fontSize: 56.0),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )),
          new Column(children: taboos)
        ],
      ),
    ));
  }

  get _buttons {
    return new Container(
      padding: new EdgeInsets.all(15.0),
      child: new Row(
        children: <Widget>[
          new Expanded(
              child: new IconButton(
                  icon: new Icon(Icons.close, color: Colors.red),
                  iconSize: 70.0,
                  onPressed: () => _buttonHandler(false))),
          new FlatButton(
              child: new Text(
                _gameController.skipLeftCurrentTeam.toString() + " SKIP",
                style: new TextStyle(fontSize: 20.0),
              ),
              onPressed: _gameController.skipLeftCurrentTeam == 0
                  ? null
                  : () => _buttonHandler(null)),
          new Expanded(
              child: new IconButton(
                  icon: new Icon(Icons.done, color: Colors.lightGreen),
                  iconSize: 70.0,
                  onPressed: () => _buttonHandler(true)))
        ],
      ),
    );
  }

  void _buttonHandler(bool isRight) {
    setState(() {
      if (isRight == null)
        _gameController.skipAnswer();
      else
        isRight ? _gameController.rightAnswer() : _gameController.wrongAnswer();
    });
  }

  void timeOut() {
    Text title;
    Text button;
    Text content;

    bool end = _gameController.changeTurn();

    //Check if it's the end

    if (end) {
      title = new Text("Team " + _gameController.winner.toString() + " win!");
      button = new Text('Main menu');
    } else {
      title = new Text("TIME IS OVER");
      content = new Text("Give the phone to the next player.");
      button = new Text('Start!');
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      child: new AlertDialog(title: title, content: content, actions: <Widget>[
        new FlatButton(
          child: button,
          onPressed: () {
            //Close the dialog
            Navigator.of(context).pop();

            //Check if it's the end
            if (end)
              Navigator.of(context).pop();
            else
              initTimer();
            setState(() {});
          },
        ),
      ]),
    );
  }
}
