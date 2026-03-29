import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:speakeasy/model/game_settings.dart';
import 'package:speakeasy/provider/analytics_provider.dart';
import 'package:speakeasy/provider/shared_preferences_provider.dart';
import 'package:speakeasy/theme/app_theme.dart';
import 'package:speakeasy/view/widget/app_scaffold.dart';
import 'package:speakeasy/view/widget/app_title.dart';
import 'package:speakeasy/view/widget/big_button.dart';
import 'package:speakeasy/view/widget/incremental_button.dart';
import 'package:speakeasy/view/widget/selector_button.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  GameSettings _settings = const GameSettings();
  bool _showAdvanced = false;
  late final AnimationController _animController;
  late final Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _expandAnimation = Tween<double>(begin: 0, end: 1).animate(_animController);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _toggleAdvanced() {
    setState(() => _showAdvanced = !_showAdvanced);
    if (_showAdvanced) {
      _animController.forward();
    } else {
      _animController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final analytics = ref.watch(analyticsControllerProvider);
    final sp = ref.read(sharedPreferencesProvider);
    final showMoreWords =
        analytics.matchesPlayed > 0 && !(sp.getBool('1000words') ?? false);

    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.delta.dy > 10) {
          _animController.reverse();
        } else if (details.delta.dy < -10) {
          _animController.forward();
        }
      },
      child: AppScaffold(
        topLeftWidget: GestureDetector(
          onTap: () => context.push('/settings'),
          child:
              const Icon(Icons.settings, color: AppColors.txtWhite, size: 28),
        ),
        topRightWidget: showMoreWords
            ? GestureDetector(
                onTap: () => context.push('/settings', extra: true),
                child: Text(
                  '${'More words'.tr()}?',
                  style: const TextStyle(
                    color: AppColors.txtWhite,
                    fontSize: 18,
                  ),
                ),
              )
            : null,
        widgets: [
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                children: [
                  const AppTitle(),
                  SelectorButton(
                    indexSelected: 0,
                    items: [
                      '#Teams'.tr(args: ['2']),
                      '#Teams'.tr(args: ['3']),
                      '#Teams'.tr(args: ['4']),
                      '#Teams'.tr(args: ['5']),
                    ],
                    onValueChanged: (i) {
                      _settings = _settings.copyWith(nPlayers: i + 2);
                    },
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: _toggleAdvanced,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10)
                            .copyWith(top: 15),
                        child: Text(
                          'advanced_preferences'.tr(
                            args: [if (_showAdvanced) '↓' else '↑'],
                          ).toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: AppColors.txtGrey),
                        ),
                      ),
                    ),
                  ),
                  AnimatedBuilder(
                    animation: _expandAnimation,
                    builder: (context, child) => SizeTransition(
                      sizeFactor: _expandAnimation,
                      child: child,
                    ),
                    child: Column(
                      children: [
                        SelectorButton(
                          indexSelected: _settings.nTaboos - 3,
                          items: [
                            '#Taboos'.tr(args: ['3']),
                            '#Taboos'.tr(args: ['4']),
                            '#Taboos'.tr(args: ['5']),
                          ],
                          onValueChanged: (i) {
                            _settings = _settings.copyWith(nTaboos: i + 3);
                          },
                        ),
                        IncrementalButton(
                          increment: 1,
                          initialValue: _settings.nTurns,
                          text: 'Turns'.tr(),
                          min: 3,
                          max: 20,
                          onValueChanged: (i) {
                            _settings = _settings.copyWith(nTurns: i);
                          },
                        ),
                        IncrementalButton(
                          increment: 10,
                          text: 'Sec'.tr(),
                          min: kReleaseMode ? 30 : 5,
                          max: 180,
                          initialValue: _settings.turnDurationInSeconds,
                          onValueChanged: (i) {
                            _settings =
                                _settings.copyWith(turnDurationInSeconds: i);
                          },
                        ),
                        IncrementalButton(
                          increment: 1,
                          initialValue: _settings.nSkip,
                          text: 'Skips'.tr(),
                          min: 0,
                          max: 10,
                          onValueChanged: (i) {
                            _settings = _settings.copyWith(nSkip: i);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          BigButton(
            text: 'Start'.tr(),
            bgColor: AppColors.lightPurple,
            textColor: AppColors.txtWhite,
            onPressed: () {
              ref.read(analyticsControllerProvider.notifier).addMatch();
              context.push('/game', extra: _settings);
            },
          ),
        ],
      ),
    );
  }
}
