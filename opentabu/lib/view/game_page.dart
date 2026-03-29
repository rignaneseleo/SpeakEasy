import 'dart:async';
import 'dart:math' as math;

import 'package:animated_emoji/emoji.dart';
import 'package:animated_emoji/emojis.g.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:speakeasy/model/game_settings.dart';
import 'package:speakeasy/provider/analytics_provider.dart';
import 'package:speakeasy/provider/device_provider.dart';
import 'package:speakeasy/provider/game/game_controller.dart';
import 'package:speakeasy/provider/game/game_state.dart';
import 'package:speakeasy/provider/sound_provider.dart';
import 'package:speakeasy/provider/words_provider.dart';
import 'package:speakeasy/theme/app_theme.dart';
import 'package:speakeasy/view/widget/big_button.dart';
import 'package:speakeasy/view/widget/blinking_text.dart';
import 'package:vibration/vibration.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class GamePage extends ConsumerStatefulWidget {
  const GamePage({required this.settings, super.key});

  final GameSettings settings;

  @override
  ConsumerState<GamePage> createState() => _GamePageState();
}

class _GamePageState extends ConsumerState<GamePage>
    with WidgetsBindingObserver {
  Timer? _turnTimer;
  Timer? _countSecondsTimer;

  int get _timerDuration => widget.settings.turnDurationInSeconds;
  int get _nTaboosToShow => widget.settings.nTaboos;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final words = await ref.read(wordsControllerProvider.future);
      ref
          .read(gameControllerProvider.notifier)
          .initialize(widget.settings, words);

      _countSecondsTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_turnTimer?.isActive ?? false) {
          final controller = ref.read(gameControllerProvider.notifier);
          controller.oneSecPassed();

          final game = ref.read(gameControllerProvider);
          final secondsLeft = _timerDuration - game.secondsPassed;
          if (secondsLeft <= 5 && secondsLeft > 0) {
            final device = ref.read(deviceInfoProvider);
            if (device.hasVibration) Vibration.vibrate(duration: 100);
            ref.read(soundServiceProvider.notifier).playTick();
          }
        }
      });

      _initCountdown(3);
    });
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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      _pauseGame();
    }
  }

  void _initCountdown(int seconds) {
    ref.read(gameControllerProvider.notifier).startCountdown();
    Timer(Duration(seconds: seconds), _startGame);
  }

  void _startGame() {
    ref.read(gameControllerProvider.notifier).startTurn();
    _startTimer(_timerDuration);
  }

  void _pauseGame() {
    final game = ref.read(gameControllerProvider);
    if (game.phase != GamePhase.playing && game.phase != GamePhase.initial) {
      return;
    }
    _turnTimer?.cancel();
    ref.read(gameControllerProvider.notifier).pauseGame();
  }

  void _resumeGame() {
    final game = ref.read(gameControllerProvider);
    _startTimer(_timerDuration - game.secondsPassed);
    ref.read(gameControllerProvider.notifier).resumeGame();
  }

  void _startTimer(int seconds) {
    _turnTimer = Timer(Duration(seconds: seconds), () {
      final device = ref.read(deviceInfoProvider);
      if (device.hasVibration) Vibration.vibrate(duration: 1000);
      ref.read(soundServiceProvider.notifier).playTimeout();
      ref.read(gameControllerProvider.notifier).endTurn();
    });
  }

  void _showExitDialog() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'want_exit?'.tr(),
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(color: AppColors.darkPurple),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text('are_going_back_home'.tr()),
              Text('match_will_end'.tr()),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Nope'.tr(),
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: AppColors.lightPurple),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              if (context.mounted) context.pop();

              if (await InAppReview.instance.isAvailable()) {
                final analytics = ref.read(analyticsControllerProvider);
                final matches = analytics.matchesPlayed;
                if (matches == 3 || matches == 8 || matches == 15) {
                  InAppReview.instance.requestReview();
                }
              }
            },
            child: Text(
              'Yep'.tr(),
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: AppColors.lightPurple),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final game = ref.watch(gameControllerProvider);
    final device = ref.watch(deviceInfoProvider);
    final smallScreen = device.isSmallScreen;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        switch (game.phase) {
          case GamePhase.initial:
          case GamePhase.playing:
            _pauseGame();
          case GamePhase.countdown:
          case GamePhase.ready:
          case GamePhase.paused:
          case GamePhase.ended:
            _showExitDialog();
        }
      },
      child: Scaffold(
        body: Material(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    _GameInfoWidget(
                      smallScreen: smallScreen,
                      highlightTeams:
                          game.phase == GamePhase.ended ? game.winners : null,
                    ),
                    if (game.phase != GamePhase.ended)
                      Positioned(
                        left: 10,
                        top: 10,
                        child: SafeArea(
                          child: GestureDetector(
                            onTap: () {
                              _pauseGame();
                              _showExitDialog();
                            },
                            child: Transform.rotate(
                              angle: math.pi,
                              child: const Icon(
                                Icons.exit_to_app,
                                color: AppColors.txtWhite,
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (game.phase == GamePhase.playing ||
                        game.phase == GamePhase.initial)
                      Positioned(
                        right: 10,
                        top: 10,
                        child: SafeArea(
                          child: GestureDetector(
                            onTap: _pauseGame,
                            child: const Icon(
                              Icons.pause,
                              color: AppColors.txtWhite,
                            ),
                          ),
                        ),
                      )
                    else if (game.phase == GamePhase.paused ||
                        game.phase == GamePhase.ended)
                      Positioned(
                        right: 10,
                        top: 10,
                        child: SafeArea(
                          child: GestureDetector(
                            onTap: () => context.push('/rules'),
                            child: const Icon(
                              Icons.book,
                              color: AppColors.txtWhite,
                            ),
                          ),
                        ),
                      ),
                    if (game.phase != GamePhase.ended &&
                        game.phase != GamePhase.ready)
                      Positioned(
                        bottom: smallScreen ? -28 : -40,
                        child: _TimeWidget(
                          timerDuration: _timerDuration,
                          onTap: _pauseGame,
                          smallScreen: smallScreen,
                        ),
                      ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: switch (game.phase) {
                      GamePhase.ready => _readyBody(game),
                      GamePhase.countdown => _countdownBody(),
                      GamePhase.playing => _playingBody(game),
                      GamePhase.ended => _endBody(game),
                      GamePhase.paused => _pauseBody(),
                      GamePhase.initial => Text('Loading'.tr()),
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _pauseBody() {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: BlinkingText(
              child: Text(
                'Pause'.tr().toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .displayMedium
                    ?.copyWith(color: AppColors.darkPurple),
              ),
            ),
          ),
        ),
        BigButton(
          text: 'Resume'.tr(),
          bgColor: AppColors.myYellow,
          textColor: AppColors.txtBlack,
          onPressed: _resumeGame,
        ),
      ],
    );
  }

  Widget _playingBody(GameState game) {
    return Column(
      children: [
        Expanded(child: _WordWidget(nTaboos: _nTaboosToShow)),
        const Row(
          children: [
            _IncorrectAnswerButton(),
            _SkipButton(),
            _CorrectAnswerButton(),
          ],
        ),
      ],
    );
  }

  Widget _countdownBody() {
    return const Column(
      children: [
        Expanded(child: _CountDownWidget(seconds: 3)),
        AbsorbPointer(
          child: Opacity(
            opacity: 0.4,
            child: Row(
              children: [
                _IncorrectAnswerButton(),
                _SkipButton(),
                _CorrectAnswerButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _readyBody(GameState game) {
    var isReady = false;

    return Column(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AutoSizeText(
                'turn_is_over'.tr().toUpperCase(),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .displayMedium
                    ?.copyWith(color: AppColors.darkPurple),
                maxLines: 2,
              ),
              TextButton(
                onPressed: () => _showScoreAdjustDialog(game.currentTeam),
                child: Text(
                  'missed_point_fix_score'.tr().toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: AppColors.lightPurple),
                ),
              ),
            ],
          ),
        ),
        Text(
          'pass_the_phone'.tr(args: [game.teamNames[game.nextTeam]]),
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: AppColors.darkPurple),
        ),
        StatefulBuilder(
          builder: (context, setInnerState) {
            final t = Timer(const Duration(seconds: 1), () {
              setInnerState(() => isReady = true);
            });

            return BigButton(
              text: 'Hold to start'.tr(),
              bgColor: AppColors.myYellow,
              textColor: AppColors.txtBlack,
              onLongPressed: !isReady
                  ? null
                  : () {
                      ref.read(gameControllerProvider.notifier).changeTurn();
                      _initCountdown(3);
                      t.cancel();
                    },
            );
          },
        ),
      ],
    );
  }

  void _showScoreAdjustDialog(int teamIndex) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black38,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('adjust_score'.tr(args: [(teamIndex + 1).toString()])),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _IncorrectAnswerButton(customTeam: teamIndex),
                _CorrectAnswerButton(customTeam: teamIndex),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _endBody(GameState game) {
    final winners = game.winners;
    String text;
    if (winners.length == game.numberOfPlayers) {
      text = 'tie'.tr();
    } else if (winners.length > 1) {
      text = 'winners_are'.tr();
      for (final team in winners) {
        text += '${'Team'.tr()} $team\n';
      }
    } else {
      text = '#is_the_winner'.tr(args: [winners.first.toString()]);
    }

    return Column(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedEmoji(
                winners.isEmpty
                    ? AnimatedEmojis.neutralFace
                    : AnimatedEmojis.partyPopper,
                size: 100,
              ),
              const SizedBox(height: 20),
              Center(
                child: AutoSizeText(
                  text.toUpperCase(),
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: AppColors.darkPurple,
                        height: 1.3,
                      ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
        BigButton(
          text: 'back_home'.tr(),
          bgColor: AppColors.darkPurple,
          textColor: AppColors.txtWhite,
          onPressed: () => context.pop(),
        ),
      ],
    );
  }
}

// --- Sub-widgets ---

class _TurnWidget extends ConsumerWidget {
  const _TurnWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameControllerProvider);

    final turnText = switch (game.phase) {
      GamePhase.countdown ||
      GamePhase.playing =>
        game.displayTurn == game.totalTurns
            ? 'Final Turn'.tr()
            : '${'Turn'.tr()} ${game.displayTurn}',
      GamePhase.ended => 'End'.tr(),
      _ => '${'Turn'.tr()} ${game.displayTurn}/${game.totalTurns}',
    };

    return Center(
      child: Text(
        turnText,
        style: Theme.of(context)
            .textTheme
            .headlineSmall
            ?.copyWith(color: AppColors.txtWhite),
      ),
    );
  }
}

class _TimeWidget extends ConsumerWidget {
  const _TimeWidget({
    required this.timerDuration,
    required this.onTap,
    required this.smallScreen,
  });

  final int timerDuration;
  final VoidCallback onTap;
  final bool smallScreen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameControllerProvider);
    final secondsLeft = timerDuration - game.secondsPassed;

    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: smallScreen ? 50 : 65,
          width: smallScreen ? 50 : 65,
          decoration: const BoxDecoration(
            color: AppColors.lightPurple,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              secondsLeft.toString(),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color:
                        secondsLeft < 8 ? AppColors.myRed : AppColors.txtWhite,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CountDownWidget extends StatefulWidget {
  const _CountDownWidget({required this.seconds});
  final int seconds;

  @override
  State<_CountDownWidget> createState() => _CountDownWidgetState();
}

class _CountDownWidgetState extends State<_CountDownWidget> {
  int _step = 0;
  Timer? _timer;

  List<String> get _words => ['ready?'.tr(), 'set'.tr(), 'go!'.tr()];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_step < _words.length - 1) setState(() => _step++);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        _words[_step].toUpperCase(),
        style: Theme.of(context)
            .textTheme
            .displayMedium
            ?.copyWith(color: Colors.black87),
      ),
    );
  }
}

class _WordWidget extends ConsumerWidget {
  const _WordWidget({required this.nTaboos});
  final int nTaboos;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameControllerProvider);
    final word = game.currentWord;
    if (word == null) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 150,
          child: Center(
            child: AutoSizeText(
              word.wordToGuess.toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .displayMedium
                  ?.copyWith(color: AppColors.txtGrey),
              maxFontSize: 56,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        FittedBox(
          child: Column(
            children: [
              for (int i = 0; i < nTaboos && i < word.taboos.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: AutoSizeText(
                    word.taboos[i].toUpperCase(),
                    maxFontSize: 35,
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium
                        ?.copyWith(color: AppColors.txtBlack),
                    maxLines: 1,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GameInfoWidget extends ConsumerWidget {
  const _GameInfoWidget({
    required this.smallScreen, this.highlightTeams,
  });

  final bool smallScreen;
  final List<int>? highlightTeams;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameControllerProvider);

    final teamWidgets = <Widget>[
      for (int i = 0; i < game.numberOfPlayers; i++)
        Expanded(
          child: _TeamItem(
            name: smallScreen
                ? '${'T'.tr()} ${i + 1}'
                : '${'Team'.tr()} ${i + 1}',
            score: game.scores[i],
            disabled: highlightTeams == null
                ? game.currentTeam != i
                : !highlightTeams!.contains(i + 1),
            smallScreen: smallScreen,
          ),
        ),
    ];

    if (smallScreen) {
      final showScoreboard = game.phase == GamePhase.ready ||
          game.phase == GamePhase.paused ||
          game.phase == GamePhase.ended;

      return _buildContainer(
        showScoreboard
            ? teamWidgets
            : [
                const _TurnWidget(),
                AutoSizeText(
                  '${'Team'.tr()} ${game.currentTeam + 1}: '
                  '${game.scores[game.currentTeam]}',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 1,
                ),
              ],
        padding:
            const EdgeInsets.only(left: 50, right: 50, bottom: 28, top: 10),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.darkPurple,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      padding: const EdgeInsets.only(left: 28, right: 28, bottom: 28, top: 8),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _TurnWidget(),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: const BoxDecoration(
                color: AppColors.lightPurple,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: teamWidgets,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContainer(List<Widget> children, {EdgeInsets? padding}) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.darkPurple,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      padding: padding ??
          const EdgeInsets.only(left: 50, right: 50, bottom: 28, top: 10),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: children,
        ),
      ),
    );
  }
}

class _TeamItem extends StatelessWidget {
  const _TeamItem({
    required this.disabled,
    required this.name,
    required this.score,
    required this.smallScreen,
  });

  final bool disabled;
  final String name;
  final int score;
  final bool smallScreen;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disabled ? 0.4 : 1,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: smallScreen ? 2 : 5,
          vertical: smallScreen ? 0 : 8,
        ),
        padding: EdgeInsets.symmetric(vertical: smallScreen ? 0 : 8),
        decoration: const BoxDecoration(
          color: AppColors.darkPurple,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Center(
          child: Column(
            children: [
              AutoSizeText(
                name.toUpperCase(),
                maxFontSize:
                    Theme.of(context).textTheme.headlineSmall?.fontSize ?? 20,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              AutoSizeText(
                score.toString().toUpperCase(),
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

class _IncorrectAnswerButton extends ConsumerWidget {
  const _IncorrectAnswerButton({this.customTeam});
  final int? customTeam;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(3),
        child: BigIconButton(
          bgColor: AppColors.myRed,
          icon: SvgPicture.asset('assets/icons/cross.svg'),
          onPressed: () {
            ref.read(soundServiceProvider.notifier).playWrong();
            ref
                .read(gameControllerProvider.notifier)
                .wrongAnswer(team: customTeam);
            ref.read(analyticsControllerProvider.notifier).addWrongAnswer();
          },
        ),
      ),
    );
  }
}

class _SkipButton extends ConsumerWidget {
  const _SkipButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameControllerProvider);
    final device = ref.watch(deviceInfoProvider);
    final skipsLeft =
        game.skipsLeft.isEmpty ? 0 : game.skipsLeft[game.currentTeam];

    return Expanded(
      child: Opacity(
        opacity: skipsLeft == 0 ? 0.3 : 1,
        child: Container(
          margin: EdgeInsets.all(device.isSmallScreen ? 0 : 3),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              child: MaterialButton(
                height: 80,
                minWidth: double.infinity,
                color: AppColors.myYellow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onPressed: () {
                  if (skipsLeft == 0) return;
                  ref.read(soundServiceProvider.notifier).playSkip();
                  ref.read(gameControllerProvider.notifier).skipAnswer();
                  ref.read(analyticsControllerProvider.notifier).addSkip();
                },
                child: Column(
                  children: [
                    SvgPicture.asset('assets/icons/skip.svg'),
                    Text(
                      skipsLeft.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: AppColors.txtBlack),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CorrectAnswerButton extends ConsumerWidget {
  const _CorrectAnswerButton({this.customTeam});
  final int? customTeam;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(3),
        child: BigIconButton(
          bgColor: AppColors.myGreen,
          icon: SvgPicture.asset('assets/icons/check.svg'),
          onPressed: () {
            ref.read(soundServiceProvider.notifier).playCorrect();
            ref
                .read(gameControllerProvider.notifier)
                .rightAnswer(team: customTeam);
            ref.read(analyticsControllerProvider.notifier).addCorrectAnswer();
          },
        ),
      ),
    );
  }
}
