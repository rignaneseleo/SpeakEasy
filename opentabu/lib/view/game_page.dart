/*
* OpenTabu is an Open Source game developed by Leonardo Rignanese <dev.rignanese@gmail.com>
* GNU Affero General Public License v3.0: https://choosealicense.com/licenses/agpl-3.0/
* GITHUB: https://github.com/rignaneseleo/OpenTabu
* */
import 'dart:async';
import 'dart:math' as math;

import 'package:animated_emoji/emoji.dart';
import 'package:animated_emoji/emojis.g.dart';
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
import 'package:speakeasy/controller/words_controller.dart';
import 'package:speakeasy/main.dart';
import 'package:speakeasy/model/settings.dart';
import 'package:speakeasy/theme/theme.dart';
import 'package:speakeasy/utils/uppercase_text.dart';
import 'package:speakeasy/view/rules_page.dart';
import 'package:speakeasy/view/widget/big_button.dart';
import 'package:speakeasy/view/widget/blinking_text.dart';
import 'package:vibration/vibration.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../api/sound/sound_loader.dart';
import '../utils/utils.dart';

class GamePage extends ConsumerStatefulWidget {
  GamePage(this._settings, {super.key});

  final Settings _settings;

  @override
  createState() {
    return new GamePageState(_settings);
  }
}

class GamePageState extends ConsumerState<GamePage>
    with WidgetsBindingObserver {
  //team name, score

  GamePageState(this.settings) {
    _timerDuration = settings.turnDurationInSeconds;
    _nTaboosToShow = settings.nTaboos;
  }

  final Settings settings;

  Timer? _turnTimer;
  Timer? _countSecondsTimer;

  late int _timerDuration;
  late int _nTaboosToShow;

  //info to show:
  Map<String, int> matchInfo = {};

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
    Future.delayed(Duration.zero, () async {
      final words = await ref.read(
          wordsControllerProvider(getSelectedLocale()!.languageCode).future);
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
    startTimer(_timerDuration);
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
    startTimer(_timerDuration - _gameController.secondsPassed);

    //Resume the turn
    ref.read(gameProvider).resumeGame();
  }

  void startTimer(int seconds) {
    _turnTimer = new Timer(new Duration(seconds: seconds), () {
      //TIMEOUT
      if (hasVibration) Vibration.vibrate(duration: 1000);

      playTimeoutSound();

      ref.read(gameProvider).endTurn();
    });
  }

  @override
  Widget build(BuildContext context) {
    GameController _gameController = ref.watch(gameProvider);

    return WillPopScope(
        onWillPop: () async {
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
                      GameInfoWidget(
                        shrinked: smallScreen,
                        highlightTeams: _gameController.winners,
                      ),
                      if (_gameController.gameState != GameState.ended)
                        Positioned(
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
                            )),
                      if (_gameController.gameState == GameState.playing ||
                          _gameController.gameState == GameState.init)
                        Positioned(
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
                        )
                      else if (_gameController.gameState == GameState.pause ||
                          _gameController.gameState == GameState.ended)
                        Positioned(
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
                        ),
                      if (![
                        GameState.ended,
                        GameState.ready,
                      ].contains(_gameController.gameState))
                        Positioned(
                          bottom: smallScreen ? -28 : -40,
                          child: TimeWidget(_timerDuration, () => pauseGame()),
                        ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 28),
                        child: switch (_gameController.gameState) {
                          GameState.ready => readyBody(_gameController),
                          GameState.countdown => countDownBody(_gameController),
                          GameState.playing => playingBody(_gameController),
                          GameState.ended => endBody(_gameController),
                          GameState.pause => pauseBody(_gameController),
                          GameState.init => Text("Loading".tr()),
                        }),
                  ),
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

  Widget pauseBody(GameController _gameController) {
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

  Widget playingBody(GameController _gameController) {
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

  Widget countDownBody(GameController _gameController) {
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

  Widget readyBody(GameController _gameController) {
    List<String> teams = _gameController.teams;
    int selectedIndex = _gameController.currentTeam;
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
                onPressed: () => Get.dialog(
                    barrierColor: Colors.black38,
                    AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("adjust_score"
                                .tr(args: [(selectedIndex + 1).toString()])),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IncorrectAnswerButton(
                                    customTeam: selectedIndex),
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
          "pass_the_phone".tr(args: [teams[_gameController.nextTeam]]),
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
                    ref.read(gameProvider).changeTurn();
                    initCountdown(3);
                    t.cancel();
                  },
          );
        }),
      ],
    );
  }

  Widget endBody(GameController _gameController) {
    String text;
    List<int> winners = _gameController.winners!;
    if (winners.length == _gameController.numberOfPlayers)
      text = "tie".tr();
    else if (winners.length > 1) {
      text = "winners_are".tr();
      for (int team in winners) text += "Team".tr() + " $team\n";
    } else
      text = "#is_the_winner".tr(args: [winners.first.toString()]);

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (winners.isEmpty)
                const AnimatedEmoji(
                  AnimatedEmojis.neutralFace,
                  size: 100,
                )
              else
                const AnimatedEmoji(
                  AnimatedEmojis.partyPopper,
                  size: 100,
                ),
              SizedBox(height: 20),
              Container(
                child: Center(
                  child: UpperCaseAutoSizeText(
                    text,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: darkPurple,
                          height: 1.3,
                        ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
        BigButton(
          text: "back_home".tr().toUpperCase(),
          bgColor: darkPurple,
          textColor: txtWhite,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

class TurnWidget extends ConsumerWidget {
  const TurnWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    GameController _gameController = ref.watch(gameProvider);

    String turnText = "";
    switch (_gameController.gameState) {
      case GameState.countdown:
      case GameState.playing:
        if (_gameController.currentTurn == _gameController.nTurns)
          turnText = "Final Turn".tr();
        else
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
  const TimeWidget(this._timerDuration, this.onTap, {super.key});

  final int _timerDuration;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //every second this is called
    final _gameController = ref.watch(gameProvider);

    final secondsLeft = _timerDuration - _gameController.secondsPassed;

    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: smallScreen ? 50 : 65,
          width: smallScreen ? 50 : 65,
          decoration: const BoxDecoration(
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
      ),
    );
  }
}

class CountDownWidget extends StatefulWidget {
  CountDownWidget({super.key, required this.seconds}) {}
  final int seconds;

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
  WordWidget(this._nTaboosToShow, {super.key});

  final int _nTaboosToShow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
  GameInfoWidget({
    super.key,
    this.clockOpacity = 1,
    this.highlightTeams,
    required this.shrinked,
  });

  final bool shrinked;
  final int clockOpacity;
  final List<int>? highlightTeams;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    GameController _gameController = ref.watch(gameProvider);

    List<Widget> teams = [];
    for (int i = 0; i < _gameController.numberOfPlayers; i++) {
      bool isCurrentTeam = _gameController.currentTeam == i;

      teams.add(Expanded(
        child: TeamItem(
          name: shrinked ? "T".tr() + " ${i + 1}" : "Team".tr() + " ${i + 1}",
          score: _gameController.scores[i],
          disabled: highlightTeams == null
              ? !isCurrentTeam
              : !highlightTeams!.contains(i + 1),
        ),
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

    if (shrinked) {
      // Shrinked Widget Logic
      switch (_gameController.gameState) {
        case GameState.init:
        case GameState.playing:
        case GameState.countdown:
          return _buildShrinkedContainer(
              [TurnWidget(), playingTeamScore], context);
        case GameState.ready:
        case GameState.pause:
        case GameState.ended:
          return _buildShrinkedContainer(teams, context);
      }
    } else {
      // Normal Widget Logic
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

  Widget _buildShrinkedContainer(List<Widget> children, BuildContext context) {
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }
}

class TeamItem extends StatelessWidget {
  const TeamItem(
      {Key? key,
      required this.disabled,
      required this.name,
      required this.score})
      : super(key: key);
  final bool disabled;
  final String name;
  final int score;

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
  const SkipTextWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
  IncorrectAnswerButton({super.key, this.customTeam});

  //This is used to fix the scores
  final int? customTeam;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
  SkipButton({super.key, this.customTeam});

  //This is used to fix the scores
  final int? customTeam;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
  CorrectAnswerButton({super.key, this.customTeam});

  //This is used to fix the scores
  final int? customTeam;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
