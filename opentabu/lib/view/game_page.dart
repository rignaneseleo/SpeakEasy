/*
* OpenTabu is an Open Source game developed by Leonardo Rignanese <dev.rignanese@gmail.com>
* GNU Affero General Public License v3.0: https://choosealicense.com/licenses/agpl-3.0/
* GITHUB: https://github.com/rignaneseleo/OpenTabu
* */
import 'dart:async';
import 'dart:math' as math;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:speakeasy/controller/analytics_controller.dart';
import 'package:speakeasy/controller/game_controller.dart';
import 'package:speakeasy/main.dart';
import 'package:speakeasy/model/settings.dart';
import 'package:speakeasy/persistence/sound_loader.dart';
import 'package:speakeasy/theme/theme.dart';
import 'package:speakeasy/utils/uppercase_text.dart';
import 'package:speakeasy/view/rules_page.dart';
import 'package:speakeasy/view/widget/big_button.dart';
import 'package:speakeasy/view/widget/blinking_text.dart';
import 'package:vibration/vibration.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class GamePage extends ConsumerStatefulWidget {
  final Settings _settings;

  GamePage(this._settings);

  @override
  createState() {
    return new GamePageState(_settings);
  }
}

class GamePageState extends ConsumerState<GamePage>
    with WidgetsBindingObserver {
  final Settings settings;

  Timer? _turnTimer;
  Timer? _countSecondsTimer;

  late int _timerDuration;
  late int _nTaboosToShow;

  //info to show:
  Map<String, int> matchInfo = {}; //team name, score

  GamePageState(this.settings) {
    _timerDuration = settings.turnDurationInSeconds;
    _nTaboosToShow = settings.nTaboos;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _turnTimer?.cancel();
    _countSecondsTimer?.cancel();
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    //Init game

    //Needed to fix this: https://github.com/rrousselGit/river_pod/issues/177
    Future.delayed(Duration.zero, () {
      ref.read(gameProvider).init(settings, words);

      _countSecondsTimer =
          new Timer.periodic(new Duration(seconds: 1), (timer) {
        if (_turnTimer?.isActive ?? false) {
          GameController _gameController = ref.read(gameProvider);
          _gameController.oneSecPassed();

          int secondsLeft = _timerDuration - _gameController.secondsPassed;
          if (secondsLeft <= 5 && secondsLeft > 0) {
            if (hasVibration) Vibration.vibrate(duration: 100);
            playTick();
          }
        }
      });

      initCountdown(3);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        pauseGame();
        break;
    }
  }

  void initCountdown(int seconds) {
    ref.read(gameProvider).startCountdown(seconds);
    Timer(Duration(seconds: seconds), () => initGame());
  }

  void initGame() {
    //Start the turn
    ref.read(gameProvider).startTurn();

    //Launch the timer
    setupTimer(_timerDuration);
  }

  void pauseGame() {
    GameController _gameController = ref.read(gameProvider);
    if (!(_gameController.gameState == GameState.playing) &&
        !(_gameController.gameState == GameState.init)) return;

    //Cancel timer
    _turnTimer?.cancel();

    //Pause game
    _gameController.pauseGame();
  }

  void resumeGame() {
    GameController _gameController = ref.read(gameProvider);

    //Launch the timer
    setupTimer(_timerDuration - _gameController.secondsPassed);

    //Resume the turn
    ref.read(gameProvider).resumeGame();
  }

  void setupTimer(int seconds) {
    _turnTimer = new Timer(new Duration(seconds: seconds), () {
      //TIMEOUT
      if (hasVibration) Vibration.vibrate(duration: 1000);

      playTimeoutSound();
      ref.read(gameProvider).changeTurn();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _body = Text("Loading".tr());

    return WillPopScope(
        onWillPop: () async {
          GameController _gameController = ref.read(gameProvider);

          switch (_gameController.gameState) {
            case GameState.init:
            case GameState.playing:
              pauseGame();
              break;
            case GameState.countdown:
            case GameState.ready:
            case GameState.pause:
            case GameState.ended:
              showDialogToExit();
              break;
          }

          return false;
        },
        child: Scaffold(
          body: Material(
            child: Container(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      if (!smallScreen) GameInfoWidget(),
                      if (smallScreen) GameInfoWidgetShrinked(),
                      Consumer(builder: (context, ref, child) {
                        GameController _gameController =
                            ref.watch(gameProvider);
                        if (_gameController.gameState != GameState.ended) {
                          return Positioned(
                              left: 10,
                              top: 10,
                              child: SafeArea(
                                child: GestureDetector(
                                  onTap: () {
                                    pauseGame();
                                    showDialogToExit();
                                  },
                                  child: Transform.rotate(
                                    angle: math.pi,
                                    child: Icon(
                                      Icons.exit_to_app,
                                      color: txtWhite,
                                    ),
                                  ),
                                ),
                              ));
                        }
                        return Container();
                      }),
                      Consumer(builder: (context, ref, child) {
                        GameController _gameController =
                            ref.watch(gameProvider);
                        if (_gameController.gameState == GameState.playing ||
                            _gameController.gameState == GameState.init) {
                          return Positioned(
                            right: 10,
                            top: 10,
                            child: SafeArea(
                              child: GestureDetector(
                                child: Icon(
                                  Icons.pause,
                                  color: txtWhite,
                                ),
                                onTap: () => pauseGame(),
                              ),
                            ),
                          );
                        } else if (_gameController.gameState ==
                                GameState.pause ||
                            _gameController.gameState == GameState.ended) {
                          return Positioned(
                            right: 10,
                            top: 10,
                            child: SafeArea(
                              child: GestureDetector(
                                child: Icon(
                                  Icons.book,
                                  color: txtWhite,
                                ),
                                onTap: () => Get.to(() => RulesPage(),
                                    transition: Transition.downToUp),
                              ),
                            ),
                          );
                        }

                        return Container();
                      }),
                      Positioned(
                        bottom: smallScreen ? -28 : -40,
                        child: TimeWidget(_timerDuration, () => pauseGame()),
                      ),
                    ],
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      GameController _gameController = ref.watch(gameProvider);

                      switch (_gameController.gameState) {
                        case GameState.ready:
                          _body = readyBody();
                          WakelockPlus.enable();
                          break;
                        case GameState.countdown:
                          _body = countDownBody();
                          WakelockPlus.enable();
                          break;
                        case GameState.playing:
                          _body = playingBody();
                          WakelockPlus.enable();
                          break;
                        case GameState.ended:
                          _body = endBody(_gameController.winners);
                          WakelockPlus.disable();
                          break;
                        case GameState.pause:
                          _body = pauseBody();
                          WakelockPlus.disable();
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

  void showDialogToExit() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'want_exit?'.tr(),
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(color: darkPurple),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('are_going_back_home'.tr()),
              Text('match_will_end'.tr()),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Nope'.tr(),
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: lightPurple)),
            onPressed: () {
              Get.back();
            },
          ),
          TextButton(
            child: Text('Yep'.tr(),
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: lightPurple)),
            onPressed: () async {
              Get.back(canPop: true);
              Get.back(canPop: true);

              if (await InAppReview.instance.isAvailable()) {
                if (await AnalyticsController.getStartedMatches() == 3 ||
                    await AnalyticsController.getStartedMatches() == 8 ||
                    await AnalyticsController.getStartedMatches() == 15)
                  InAppReview.instance.requestReview();
              }
            },
          ),
        ],
      ),
      useSafeArea: true,
    );
  }

  Widget pauseBody() {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: BlinkingText(
              UpperCaseText(
                "Pause".tr().toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .displayMedium
                    ?.copyWith(color: darkPurple),
              ),
            ),
          ),
        ),
        BigButton(
          text: "Resume".tr().toUpperCase(),
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
        //SkipTextWidget(),
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IncorrectAnswerButton(),
            SkipButton(),
            CorrectAnswerButton(),
          ],
        ),
      ],
    );
  }

  Widget countDownBody() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(child: CountDownWidget(seconds: 3)),
        //SkipTextWidget(),
        AbsorbPointer(
          absorbing: true,
          child: Opacity(
            opacity: 0.4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IncorrectAnswerButton(),
                SkipButton(),
                CorrectAnswerButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget readyBody() {
    GameController _gameController = ref.read(gameProvider);
    List<String> teams = _gameController.teams;
    int selectedIndex = _gameController.previousTeam;
    bool _isReady = false;

    return Column(
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UpperCaseAutoSizeText(
                "turn_is_over".tr().toUpperCase(),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .displayMedium
                    ?.copyWith(color: darkPurple),
                maxLines: 2,
                maxFontSize:
                    Theme.of(context).textTheme.displayMedium?.fontSize ?? 48,
              ),
              TextButton(
                child: Text(
                  "missed_point_fix_score".tr().toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: lightPurple),
                ),
                onPressed: () => Get.dialog(AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("adjust_score"
                            .tr(args: [(selectedIndex + 1).toString()])),
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
        Text(
          "pass_the_phone".tr(args: [teams[_gameController.currentTeam]]),
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: darkPurple),
        ),
        StatefulBuilder(builder: (context, setState) {
          Timer t = Timer(Duration(seconds: 1), () {
            setState(() => _isReady = true);
          });

          return BigButton(
            text: "Hold to start".tr(),
            bgColor: myYellow,
            textColor: txtBlack,
            onLongPressed: (!_isReady)
                ? null
                : () {
                    initCountdown(3);
                    t.cancel();
                  },
          );
        }),
      ],
    );
  }

  Widget endBody(List<int> winners) {
    String text;
    if (winners.length > 1) {
      text = "winners_are".tr();
      for (int team in winners) text += "Team".tr() + " $team\n";
    } else
      text = "#is_the_winner".tr(args: [winners.first.toString()]);

    return Column(
      children: [
        Expanded(
          child: Center(
            child: UpperCaseAutoSizeText(
              text,
              style: Theme.of(context)
                  .textTheme
                  .displayMedium
                  ?.copyWith(color: darkPurple),
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
          text: "back_home".tr().toUpperCase(),
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
  Widget build(BuildContext context, ref) {
    GameController _gameController = ref.watch(gameProvider);

    String turnText = "";
    switch (_gameController.gameState) {
      case GameState.countdown:
      case GameState.playing:
        turnText = "${"Turn".tr()} ${_gameController.currentTurn}";
        break;
      case GameState.init:
      case GameState.ready:
      case GameState.pause:
        turnText =
            "${"Turn".tr()} ${_gameController.currentTurn}/${_gameController.nTurns}";
        break;
      case GameState.ended:
        turnText = "End".tr();
        break;
    }

    return Center(
      child: new Text(
        turnText,
        style: Theme.of(context)
            .textTheme
            .headlineSmall
            ?.copyWith(color: txtWhite),
      ),
    );
  }
}

class TimeWidget extends ConsumerWidget {
  final _timerDuration;
  final onTap;

  TimeWidget(this._timerDuration, this.onTap);

  @override
  Widget build(BuildContext context, ref) {
    //every second this is called
    GameController _gameController = ref.watch(gameProvider);

    int secondsLeft = _timerDuration - _gameController.secondsPassed;

    return new Center(
      child: GestureDetector(
        child: Container(
          height: smallScreen ? 50 : 65,
          width: smallScreen ? 50 : 65,
          decoration: new BoxDecoration(
            color: lightPurple,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: new Text(
              secondsLeft.toString(),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: _timerDuration - _gameController.secondsPassed < 8
                        ? myRed
                        : txtWhite,
                  ),
            ),
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}

class CountDownWidget extends StatefulWidget {
  final int seconds;

  CountDownWidget({required this.seconds}) {}

  @override
  State<CountDownWidget> createState() => _CountDownWidgetState();
}

class _CountDownWidgetState extends State<CountDownWidget> {
  int secondsPassed = 0;
  List<String> countdownWords = ["ready?".tr(), "set".tr(), "go!".tr()];
  Timer? t;

  @override
  void initState() {
    t = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (secondsPassed < countdownWords.length - 1) secondsPassed++;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: new Text(
        countdownWords[secondsPassed].tr().toUpperCase(),
        style: Theme.of(context)
            .textTheme
            .displayMedium
            ?.copyWith(color: Colors.black87),
      ),
    );
  }
}

class WordWidget extends ConsumerWidget {
  final int _nTaboosToShow;

  WordWidget(this._nTaboosToShow);

  @override
  Widget build(BuildContext context, ref) {
    GameController _gameController = ref.watch(gameProvider);
    List<String> _taboos = _gameController.currentWord!.taboos;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      //physics: BouncingScrollPhysics(),
      children: <Widget>[
        Container(
          //width: double.infinity,
          height: 150,
          child: Center(
            child: new UpperCaseAutoSizeText(
              _gameController.currentWord!.wordToGuess,
              style: Theme.of(context)
                  .textTheme
                  .displayMedium
                  ?.copyWith(color: txtGrey),
              maxFontSize: 56,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        FittedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              for (int i = 0; i < _nTaboosToShow; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: UpperCaseAutoSizeText(
                    _taboos[i],
                    maxFontSize: 35.0,
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium
                        ?.copyWith(color: txtBlack),
                    maxLines: 1,
                  ),
                ),
            ],
          ),
        )

        /* Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: taboos,
          ),
        ),*/
      ],
    );

    if (_gameController.skipLeftCurrentTeam > 0) {
      playSkipSound();
      _gameController.skipAnswer();
    }
  }
}

class GameInfoWidget extends ConsumerWidget {
  final int clockOpacity;

  GameInfoWidget({this.clockOpacity = 1});

  @override
  Widget build(BuildContext context, ref) {
    GameController _gameController = ref.watch(gameProvider);

    List<Widget> teams = [];

    for (int i = 0; i < _gameController.numberOfPlayers; i++) {
      bool isCurrentTeam = _gameController.currentTeam == i;

      teams.add(Expanded(
        child: TeamItem(
            name: "Team".tr() + " ${i + 1}",
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

class GameInfoWidgetShrinked extends ConsumerWidget {
  final int clockOpacity;

  GameInfoWidgetShrinked({this.clockOpacity = 1});

  @override
  Widget build(BuildContext context, ref) {
    GameController _gameController = ref.watch(gameProvider);

    List<Widget> teams = [];

    for (int i = 0; i < _gameController.numberOfPlayers; i++) {
      bool isCurrentTeam = _gameController.currentTeam == i;

      teams.add(Expanded(
        child: TeamItem(
            name: "T".tr() + " ${i + 1}",
            score: _gameController.scores[i],
            disabled: !isCurrentTeam),
      ));
    }

    Widget playingTeamScore = AutoSizeText(
      "Team".tr() +
          " ${_gameController.currentTeam + 1}: " +
          _gameController.scores[_gameController.currentTeam].toString(),
      style: Theme.of(context)
          .textTheme
          .headlineSmall
          ?.copyWith(fontWeight: FontWeight.bold),
      maxLines: 1,
    );

    switch (_gameController.gameState) {
      case GameState.init:
      case GameState.playing:
      case GameState.countdown:
        return new Container(
          decoration: new BoxDecoration(
            color: darkPurple,
            borderRadius: new BorderRadius.vertical(
              bottom: const Radius.circular(20.0),
            ),
          ),
          padding: EdgeInsets.only(left: 50, right: 50, bottom: 28, top: 10),
          child: SafeArea(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                playingTeamScore,
                TurnWidget(),
              ],
            ),
          ),
        );
      case GameState.ready:
      case GameState.pause:
      case GameState.ended:
        return new Container(
          decoration: new BoxDecoration(
            color: darkPurple,
            borderRadius: new BorderRadius.vertical(
              bottom: const Radius.circular(20.0),
            ),
          ),
          padding: EdgeInsets.only(left: 50, right: 50, bottom: 28, top: 10),
          child: SafeArea(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: teams,
            ),
          ),
        );
    }
  }
}

class TeamItem extends StatelessWidget {
  final bool disabled;
  final String name;
  final int score;

  const TeamItem(
      {Key? key,
      required this.disabled,
      required this.name,
      required this.score})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disabled ? 0.4 : 1,
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: smallScreen ? 2 : 5, vertical: smallScreen ? 0 : 8),
        padding: EdgeInsets.symmetric(vertical: smallScreen ? 0 : 8),
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
                maxFontSize:
                    Theme.of(context).textTheme.headlineSmall?.fontSize ?? 20,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              UpperCaseAutoSizeText(
                score.toString(),
                maxFontSize:
                    Theme.of(context).textTheme.headlineMedium?.fontSize ?? 25,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SkipTextWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ref) {
    GameController _gameController = ref.watch(gameProvider);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: UpperCaseText(
        _gameController.skipLeftCurrentTeam.toString() +
            " " +
            "Skips".tr().toUpperCase(),
        style:
            Theme.of(context).textTheme.titleLarge?.copyWith(color: darkPurple),
      ),
    );
  }
}

class IncorrectAnswerButton extends ConsumerWidget {
  //This is used to fix the scores
  final int? customTeam;

  IncorrectAnswerButton({this.customTeam});

  @override
  Widget build(BuildContext context, ref) {
    GameController _gameController = ref.watch(gameProvider);

    return new Expanded(
        child: Container(
      margin: EdgeInsets.all(3),
      child: BigIconButton(
          bgColor: myRed,
          icon: SvgPicture.asset('assets/icons/cross.svg'),
          onPressed: () {
            playWrongAnswerSound();
            _gameController.wrongAnswer(team: customTeam);
            AnalyticsController.addWrongAnswer();
          }),
    ));
  }
}

class SkipButton extends ConsumerWidget {
  //This is used to fix the scores
  final int? customTeam;

  SkipButton({this.customTeam});

  @override
  Widget build(BuildContext context, ref) {
    GameController _gameController = ref.watch(gameProvider);

    return new Expanded(
      child: Opacity(
        opacity: _gameController.skipLeftCurrentTeam == 0 ? 0.3 : 1,
        child: Container(
          margin: EdgeInsets.all(smallScreen ? 0 : 3),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Container(
              margin: EdgeInsets.only(top: 20),
              child: MaterialButton(
                height: 80,
                minWidth: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SvgPicture.asset('assets/icons/skip.svg'),
                    Text(
                      _gameController.skipLeftCurrentTeam.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: txtBlack),
                    ),
                  ],
                ),
                color: myYellow,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: () {
                  if (_gameController.skipLeftCurrentTeam == 0) return;

                  playSkipSound();
                  _gameController.skipAnswer();
                  AnalyticsController.addNewSkip();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CorrectAnswerButton extends ConsumerWidget {
  //This is used to fix the scores
  final int? customTeam;

  CorrectAnswerButton({this.customTeam});

  @override
  Widget build(BuildContext context, ref) {
    GameController _gameController = ref.watch(gameProvider);

    return new Expanded(
      child: Container(
        margin: EdgeInsets.all(3),
        child: BigIconButton(
            bgColor: myGreen,
            icon: SvgPicture.asset('assets/icons/check.svg'),
            onPressed: () {
              playCorrectAnswerSound();
              _gameController.rightAnswer(team: customTeam);
              AnalyticsController.addCorrectAnswer();
            }),
      ),
    );
  }
}
