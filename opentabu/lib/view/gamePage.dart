/*
* OpenTabu is an Open Source game developed by Leonardo Rignanese <dev.rignanese@gmail.com>
* GNU Affero General Public License v3.0: https://choosealicense.com/licenses/agpl-3.0/
* GITHUB: https://github.com/rignaneseleo/OpenTabu
* */
import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:opentabu/controller/gameController.dart';
import 'package:opentabu/model/settings.dart';
import 'package:opentabu/model/word.dart';
import 'package:opentabu/persistence/soundLoader.dart';
import 'package:opentabu/view/widget/myContainer.dart';
import 'package:vibration/vibration.dart';
import 'package:wakelock/wakelock.dart';

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
  final settings;

  Timer _turnTimer;
  Timer _countSecondsTimer;

  int _timerDuration;
  int _nTaboosToShow;

  //info to show:
  Map<String, int> matchInfo; //team name, score

  GamePageState(this.settings) {
    _timerDuration = settings.turnDurationInSeconds;
    _nTaboosToShow = settings.nTaboos;
  }

  @override
  void dispose() {
    _turnTimer.cancel();
    _countSecondsTimer.cancel();
    Wakelock.disable();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    //Init game

    //Needed to fix this: https://github.com/rrousselGit/river_pod/issues/177
    Future.delayed(Duration.zero, () {
      context.read(gameProvider).init(settings, words);

      _countSecondsTimer =
          new Timer.periodic(new Duration(seconds: 1), (timer) {
        if (_turnTimer.isActive) {
          GameController _gameController = context.read(gameProvider);
          _gameController.oneSecPassed();

          int secondsLeft = _timerDuration - _gameController.secondsPassed;
          if (secondsLeft <= 5 && secondsLeft > 0) {
            if (hasVibration) Vibration.vibrate(duration: 100);
            playTick();
          }
        }
      });

      initGame();
    });
  }

  void initGame() {
    //Start the turn
    context.read(gameProvider).startTurn();

    //Launch the timer
    setupTimer(_timerDuration);
  }

  void pauseGame() {
    //Cancel timer
    _turnTimer.cancel();

    //Pause game
    context.read(gameProvider).pauseGame();
  }

  void resumeGame() {
    GameController _gameController = context.read(gameProvider);

    //Launch the timer
    setupTimer(_timerDuration - _gameController.secondsPassed);

    //Resume the turn
    context.read(gameProvider).resumeGame();
  }

  void setupTimer(int seconds) {
    _turnTimer = new Timer(new Duration(seconds: seconds), () {
      //TIMEOUT
      if (hasVibration) Vibration.vibrate(duration: 1000);

      playTimeoutSound();
      context.read(gameProvider).changeTurn();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _body = Text("Loading");

    return WillPopScope(
      onWillPop: () async {
        GameController _gameController = context.read(gameProvider);

        switch (_gameController.gameState) {
          case GameState.init:
          case GameState.playing:
            pauseGame();
            break;
          case GameState.ready:
          case GameState.pause:
          case GameState.ended:
            return true;
        }

        return false;
      },
      child: new Scaffold(
          appBar: AppBar(
            actions: [
              Consumer(builder: (context, watch, child) {
                GameController _gameController = watch(gameProvider);
                if (_gameController.gameState == GameState.playing)
                  return IconButton(
                      icon: Icon(Icons.pause), onPressed: () => pauseGame());
                else
                  return Container();
              }),
            ],
          ),
          body: Consumer(
            builder: (context, watch, child) {
              GameController _gameController = watch(gameProvider);

              switch (_gameController.gameState) {
                case GameState.ready:
                  _body = readyBody();
                  Wakelock.enable();
                  break;
                case GameState.playing:
                  _body = playingBody();
                  Wakelock.enable();
                  break;
                case GameState.ended:
                  _body = endBody(_gameController.winners);
                  Wakelock.disable();
                  break;
                case GameState.pause:
                  _body = pauseBody();
                  Wakelock.disable();
                  break;
                case GameState.init:
                  break;
              }

              return Column(
                children: <Widget>[
                  GameInfoWidget(),
                  new Divider(height: 1.0),
                  Expanded(child: _body),
                ],
              );
            },
          )),
    );
  }

  Widget pauseBody() {
    return MyContainer(
      header: Column(
        children: [
          TurnWidget(),
          TimeWidget(_timerDuration),
        ],
      ),
      body: Center(
        child: Text(
          "PAUSE",
          style: TextStyle(fontSize: 50),
        ),
      ),
      footer: MyBottomButton(
        text: "RESUME",
        onPressed: () => resumeGame(),
      ),
    );
  }

  Widget playingBody() {
    return MyContainer(
      header: Column(
        children: [
          TurnWidget(),
          TimeWidget(_timerDuration),
        ],
      ),
      body: WordWidget(_nTaboosToShow),
      footer: Container(
        padding: new EdgeInsets.all(15.0),
        child: new Row(
          children: <Widget>[
            IncorrectAnswerButton(),
            SkipButton(),
            CorrectAnswerButton(),
          ],
        ),
      ),
    );

    return Column(
      children: <Widget>[
        TurnWidget(),
        TimeWidget(_timerDuration),
        Expanded(child: WordWidget(_nTaboosToShow)),
        new Divider(height: 10.0),
        new Container(
          padding: new EdgeInsets.all(15.0),
          child: new Row(
            children: <Widget>[
              IncorrectAnswerButton(),
              SkipButton(),
              CorrectAnswerButton(),
            ],
          ),
        )
      ],
    );
  }

  Widget readyBody() {
    return MyContainer(
      header: TurnWidget(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "TIME IS OVER :(",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          new Text("Pass the phone to the next player."),
        ],
      ),
      footer: MyBottomButton(
        text: "NEXT TURN",
        onPressed: () => initGame(),
      ),
    );
  }

  Widget endBody(List<int> winners) {
    String text;
    if (winners.length > 1) {
      text = "The winners are:\n";
      for (int team in winners) text += "Team $team\n";
    } else
      text = "${winners.first} is the winner!";

    return MyContainer(
      body: Text(
        text,
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      footer: MyBottomButton(
        text: "BACK HOME",
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}

class TurnWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    GameController _gameController = watch(gameProvider);
    return Center(
      child: new Text(
        "Turn " + (_gameController.currentTurn).toString(),
        style: new TextStyle(fontSize: 18.0, color: Colors.black54),
      ),
    );
  }
}

class TimeWidget extends ConsumerWidget {
  final _timerDuration;

  TimeWidget(this._timerDuration);

  @override
  Widget build(BuildContext context, watch) {
    //every second this is called
    GameController _gameController = watch(gameProvider);

    int secondsLeft = _timerDuration - _gameController.secondsPassed;

    return new Center(
      child: new Text(
        secondsLeft.toString(),
        style: new TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: _timerDuration - _gameController.secondsPassed < 8
                ? Colors.red
                : Colors.black),
      ),
    );
  }
}

class WordWidget extends ConsumerWidget {
  final _nTaboosToShow;

  WordWidget(this._nTaboosToShow);

  @override
  Widget build(BuildContext context, watch) {
    GameController _gameController = watch(gameProvider);

    List<Widget> taboos = new List<Widget>();

    List<String> _taboos = _gameController.currentWord.taboos;

    for (int i = 0; i < _nTaboosToShow; i++) {
      taboos.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.0),
        child: AutoSizeText(
          _taboos[i],
          maxFontSize: 35,
          style: new TextStyle(fontSize: 35.0, color: Colors.black54),
          maxLines: 1,
        ),
      ));
    }

    return Container(
      padding: new EdgeInsets.all(15.0),
      child: new Column(
        children: <Widget>[
          new Padding(
              padding: new EdgeInsets.symmetric(vertical: 30.0),
              child: new AutoSizeText(
                _gameController.currentWord.wordToGuess,
                style:
                    new TextStyle(fontSize: 56.0, fontWeight: FontWeight.w500),
                maxFontSize: 56,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )),
          new Column(children: taboos)
        ],
      ),
    );
  }
}

class GameInfoWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    GameController _gameController = watch(gameProvider);

    List<Widget> teams = new List<Widget>();

    for (int i = 0; i < _gameController.numberOfPlayers; i++) {
      bool isCurrentTeam = _gameController.currentTeam == i;

      teams.add(new Expanded(
        child: Opacity(
          child: new Column(
            children: <Widget>[
              new Text(
                "Team " + (i + 1).toString(),
                style: new TextStyle(
                    fontSize: 17.0,
                    fontWeight:
                        isCurrentTeam ? FontWeight.bold : FontWeight.normal,
                    color: isCurrentTeam ? Theme.of(context).primaryColor : Colors.black),
              ),
              new Text(
                _gameController.scores[i].toString(),
                style: new TextStyle(
                  fontSize: 22.0,
                  fontWeight:
                      isCurrentTeam ? FontWeight.bold : FontWeight.normal,
                ),
              )
            ],
          ),
          opacity: isCurrentTeam ? 1 : 0.2,
        ),
      ));
    }

    return new Container(
      height: 70.0,
      padding: new EdgeInsets.all(8.0),
      child: new Row(
        children: teams,
      ),
    );
  }
}

class SkipButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    GameController _gameController = watch(gameProvider);

    return new FlatButton(
        child: new Text(
          _gameController.skipLeftCurrentTeam.toString() + " SKIP",
          style: new TextStyle(fontSize: 20.0),
        ),
        onPressed: _gameController.skipLeftCurrentTeam == 0
            ? null
            : () {
                playSkipSound();
                _gameController.skipAnswer();
              });
  }
}

class IncorrectAnswerButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    GameController _gameController = watch(gameProvider);

    return new Expanded(
        child: new IconButton(
            icon: new Icon(Icons.close, color: Colors.red),
            iconSize: 70.0,
            onPressed: () {
              playWrongAnswerSound();
              _gameController.wrongAnswer();
            }));
  }
}

class CorrectAnswerButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    GameController _gameController = watch(gameProvider);

    return new Expanded(
        child: new IconButton(
            icon: new Icon(Icons.done, color: Colors.lightGreen),
            iconSize: 70.0,
            onPressed: () {
              playCorrectAnswerSound();
              _gameController.rightAnswer();
            }));
  }
}
