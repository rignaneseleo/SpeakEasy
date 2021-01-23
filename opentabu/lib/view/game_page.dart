/*
* OpenTabu is an Open Source game developed by Leonardo Rignanese <dev.rignanese@gmail.com>
* GNU Affero General Public License v3.0: https://choosealicense.com/licenses/agpl-3.0/
* GITHUB: https://github.com/rignaneseleo/OpenTabu
* */
import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:get/get.dart';
import 'package:opentabu/controller/game_controller.dart';
import 'package:opentabu/model/settings.dart';
import 'package:opentabu/model/word.dart';
import 'package:opentabu/persistence/sound_loader.dart';
import 'package:opentabu/theme/theme.dart';
import 'package:opentabu/utils/uppercase_text.dart';
import 'package:opentabu/view/widget/big_button.dart';
import 'package:opentabu/view/widget/blinking_text.dart';
import 'package:opentabu/view/widget/my_scaffold.dart';
import 'package:opentabu/view/widget/selector_button.dart';
import 'package:opentabu/view/widget/tiny_button.dart';
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
    _turnTimer?.cancel();
    _countSecondsTimer?.cancel();
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
        child: Scaffold(
          body: Material(
            child: Container(
              width: double.infinity,
              /* padding: EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 28,
              ),*/
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Stack(
                    overflow: Overflow.visible,
                    alignment: Alignment.center,
                    children: [
                      GameInfoWidget(),
                      Positioned(
                        bottom: -40,
                        child: TimeWidget(_timerDuration),
                      ),
                    ],
                  ),
                  Consumer(
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

                      return Expanded(
                          child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 28,
                        ),
                        child: _body,
                      ));
                    },
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget pauseBody() {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: BlinkingText(
              UpperCaseText(
                "PAUSE",
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    .copyWith(color: darkPurple),
              ),
            ),
          ),
        ),
        BigButton(
          text: "RESUME",
          bgColor: myYellow,
          textColor: txtBlack,
          onPressed: () => resumeGame(),
        ),
      ],
    );
  }

  Widget playingBody() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(child: WordWidget(_nTaboosToShow)),
        SkipButton(),
        new Row(
          children: <Widget>[
            IncorrectAnswerButton(),
            CorrectAnswerButton(),
          ],
        ),
      ],
    );
  }

  Widget readyBody() {
    GameController _gameController = context.read(gameProvider);
    List<String> teams = _gameController.teams;
    int selectedIndex = _gameController.previousTeam;

    return Column(
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UpperCaseAutoSizeText(
                "YOUR TIME IS OVER :(",
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    .copyWith(color: darkPurple),
                maxLines: 1,
                maxFontSize: Theme.of(context).textTheme.headline2.fontSize,
              ),
              Text("Pass the phone to the next player."),
              TextButton(
                child: Text(
                  "MISSED A POINT? FIX SCORE",
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: lightPurple),
                ),
                onPressed: () => Get.dialog(AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("ADJUST TEAM ${selectedIndex + 1} SCORE:"),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IncorrectAnswerButton(customTeam: selectedIndex),
                            CorrectAnswerButton(customTeam: selectedIndex),
                          ],
                        ),
                      ],
                    ))),
              ),
            ],
          ),
        ),
        BigButton(
          text: "NEXT TURN",
          bgColor: myYellow,
          textColor: txtBlack,
          onPressed: () => initGame(),
        ),
      ],
    );
  }

  Widget endBody(List<int> winners) {
    String text;
    if (winners.length > 1) {
      text = "The winners are:\n";
      for (int team in winners) text += "Team $team\n";
    } else
      text = "${winners.first} is the winner!";

    return Column(
      children: [
        Expanded(
          child: Center(
            child: UpperCaseAutoSizeText(
              text,
              style: Theme.of(context)
                  .textTheme
                  .headline2
                  .copyWith(color: darkPurple),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ),
        ),
        /* BigButton(
          text: "PLAY AGAIN",
          bgColor: myGreen,
          textColor: txtBlack,
          //onPressed: () => resumeGame(),
        ),*/
        BigButton(
          text: "BACK HOME",
          bgColor: lightPurple,
          textColor: txtWhite,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

class TurnWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    GameController _gameController = watch(gameProvider);

    return Center(
      child: new Text(
        _gameController.gameState == GameState.ended
            ? "End"
            : "Turn " + (_gameController.currentTurn).toString(),
        style: Theme.of(context).textTheme.headline5.copyWith(color: txtWhite),
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
      child: Container(
        height: 65,
        width: 65,
        decoration: new BoxDecoration(
          color: lightPurple,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: new Text(
            secondsLeft.toString(),
            style: Theme.of(context).textTheme.headline4.copyWith(
                  color: _timerDuration - _gameController.secondsPassed < 8
                      ? myRed
                      : txtWhite,
                ),
          ),
        ),
      ),
    );
  }
}

class WordWidget extends ConsumerWidget {
  final int _nTaboosToShow;

  WordWidget(this._nTaboosToShow);

  @override
  Widget build(BuildContext context, watch) {
    GameController _gameController = watch(gameProvider);

    List<Widget> taboos = new List<Widget>();

    List<String> _taboos = _gameController.currentWord.taboos;

    for (int i = 0; i < _nTaboosToShow; i++) {
      taboos.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: UpperCaseAutoSizeText(
          _taboos[i],
          maxFontSize: 35.0,
          style:
              Theme.of(context).textTheme.headline2.copyWith(color: txtBlack),
          maxLines: 1,
        ),
      ));
    }

    return GestureDetector(
      child: Container(
        padding: new EdgeInsets.all(15.0),
        child: new Column(
          children: <Widget>[
            new Padding(
                padding: new EdgeInsets.symmetric(vertical: 30.0),
                child: new UpperCaseAutoSizeText(
                  _gameController.currentWord.wordToGuess,
                  style: Theme.of(context)
                      .textTheme
                      .headline2
                      .copyWith(color: txtGrey),
                  maxFontSize: 56,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )),
            new Column(children: taboos)
          ],
        ),
      ),
      onHorizontalDragStart: (details) {
        // Note: Sensitivity is integer used when you don't want to mess up vertical drag
        if (_gameController.skipLeftCurrentTeam >
            0)  {
          playSkipSound();
          _gameController.skipAnswer();
        }
      },
    );
  }
}

class GameInfoWidget extends ConsumerWidget {
  final int clockOpacity;

  GameInfoWidget({this.clockOpacity = 1});

  @override
  Widget build(BuildContext context, watch) {
    GameController _gameController = watch(gameProvider);

    List<Widget> teams = new List<Widget>();

    for (int i = 0; i < _gameController.numberOfPlayers; i++) {
      bool isCurrentTeam = _gameController.currentTeam == i;

      teams.add(Expanded(
        child: TeamItem(
            name: "Team ${i + 1}",
            score: _gameController.scores[i],
            disabled: !isCurrentTeam),
      ));
    }

    return new Container(
      decoration: new BoxDecoration(
        color: darkPurple,
        borderRadius: new BorderRadius.vertical(
          bottom: const Radius.circular(20.0),
        ),
      ),
      padding: EdgeInsets.only(left: 28, right: 28, bottom: 28, top: 8),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TurnWidget(),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: new BoxDecoration(
                color: lightPurple,
                borderRadius: new BorderRadius.all(
                  const Radius.circular(10.0),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: teams,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TeamItem extends StatelessWidget {
  final bool disabled;
  final String name;
  final int score;

  const TeamItem({Key key, this.disabled, this.name, this.score})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disabled ? 0.4 : 1,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: new BoxDecoration(
          color: darkPurple,
          borderRadius: new BorderRadius.all(
            const Radius.circular(10.0),
          ),
        ),
        child: Center(
          child: Column(
            children: [
              UpperCaseAutoSizeText(
                name,
                maxFontSize: Theme.of(context).textTheme.headline5.fontSize,
                style: Theme.of(context).textTheme.headline6,
              ),
              UpperCaseAutoSizeText(
                score.toString(),
                maxFontSize: Theme.of(context).textTheme.headline4.fontSize,
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SkipButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    GameController _gameController = watch(gameProvider);

    return new TinyButton(
        text: _gameController.skipLeftCurrentTeam.toString() + " SKIP",
        textColor: lightPurple,
        onPressed: _gameController.skipLeftCurrentTeam == 0
            ? null
            : () {
                playSkipSound();
                _gameController.skipAnswer();
              });
  }
}

class IncorrectAnswerButton extends ConsumerWidget {
  //This is used to fix the scores
  final int customTeam;

  IncorrectAnswerButton({this.customTeam});

  @override
  Widget build(BuildContext context, watch) {
    GameController _gameController = watch(gameProvider);

    return new Expanded(
        child: Container(
      margin: EdgeInsets.all(3),
      child: BigIconButton(
          bgColor: myRed,
          icon: Image.asset('assets/icons/cross.png'),
          onPressed: () {
            playWrongAnswerSound();
            _gameController.wrongAnswer(team: customTeam);
          }),
    ));
  }
}

class CorrectAnswerButton extends ConsumerWidget {
  //This is used to fix the scores
  final int customTeam;

  CorrectAnswerButton({this.customTeam});

  @override
  Widget build(BuildContext context, watch) {
    GameController _gameController = watch(gameProvider);

    return new Expanded(
      child: Container(
        margin: EdgeInsets.all(3),
        child: BigIconButton(
            bgColor: myGreen,
            icon: Image.asset('assets/icons/check.png'),
            onPressed: () {
              playCorrectAnswerSound();
              _gameController.rightAnswer(team: customTeam);
            }),
      ),
    );
  }
}
