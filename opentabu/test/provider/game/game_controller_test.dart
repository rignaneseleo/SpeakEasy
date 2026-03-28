import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speakeasy/model/game_settings.dart';
import 'package:speakeasy/model/word.dart';
import 'package:speakeasy/provider/game/game_controller.dart';
import 'package:speakeasy/provider/game/game_state.dart';

import 'package:flutter/services.dart';

/// Test words fixture.
List<Word> _testWords([int count = 20]) => List.generate(
      count,
      (i) => Word(wordToGuess: 'Word$i', taboos: ['Taboo${i}a', 'Taboo${i}b']),
    );

const _defaultSettings = GameSettings(
  nPlayers: 2,
  turnDurationInSeconds: 60,
  nSkip: 3,
  nTurns: 2,
  nTaboos: 5,
);

ProviderContainer _createContainer() => ProviderContainer();

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Stub WakelockPlus platform channel to avoid errors in tests.
  // Pigeon-generated APIs expect a List response envelope.
  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler(
      'dev.flutter.pigeon.wakelock_plus_platform_interface.WakelockPlusApi.toggle',
      (message) async {
        // Return a Pigeon success envelope: [null] means void success
        return const StandardMessageCodec().encodeMessage(<Object?>[null]);
      },
    );
  });

  group('GameController', () {
    late ProviderContainer container;
    late GameController controller;

    setUp(() {
      container = _createContainer();
      controller = container.read(gameControllerProvider.notifier);
    });

    tearDown(() => container.dispose());

    group('build (initial state)', () {
      test('returns default GameState', () {
        final state = container.read(gameControllerProvider);
        expect(state.phase, GamePhase.initial);
        expect(state.scores, isEmpty);
      });
    });

    group('initialize', () {
      test('sets up game state correctly', () {
        controller.initialize(_defaultSettings, _testWords());
        final state = container.read(gameControllerProvider);

        expect(state.phase, GamePhase.ready);
        expect(state.scores, [0, 0]);
        expect(state.skipsLeft, [3, 3]);
        expect(state.nSkipsPerTeam, 3);
        expect(state.totalTurns, 2);
        expect(state.words.length, 20);
        expect(state.currentWord, isNotNull);
        expect(state.wordIndex, 0);
      });

      test('shuffles words', () {
        final words = _testWords();
        controller.initialize(_defaultSettings, words);
        final state = container.read(gameControllerProvider);

        // Shuffled words may differ from input order
        // Just verify same set of words
        expect(state.words.toSet(), words.toSet());
      });

      test('works with custom player count', () {
        final settings = _defaultSettings.copyWith(nPlayers: 4);
        controller.initialize(settings, _testWords());
        final state = container.read(gameControllerProvider);

        expect(state.scores, [0, 0, 0, 0]);
        expect(state.skipsLeft, [3, 3, 3, 3]);
      });
    });

    group('phase transitions', () {
      setUp(() {
        controller.initialize(_defaultSettings, _testWords());
      });

      test('startCountdown transitions from ready to countdown', () {
        controller.startCountdown();
        expect(container.read(gameControllerProvider).phase, GamePhase.countdown);
      });

      test('startTurn transitions to playing', () {
        controller.startCountdown();
        controller.startTurn();
        expect(container.read(gameControllerProvider).phase, GamePhase.playing);
      });

      test('pauseGame transitions to paused', () {
        controller.startCountdown();
        controller.startTurn();
        controller.pauseGame();
        expect(container.read(gameControllerProvider).phase, GamePhase.paused);
      });

      test('resumeGame transitions back to playing', () {
        controller.startCountdown();
        controller.startTurn();
        controller.pauseGame();
        controller.resumeGame();
        expect(container.read(gameControllerProvider).phase, GamePhase.playing);
      });
    });

    group('rightAnswer', () {
      setUp(() {
        controller.initialize(_defaultSettings, _testWords());
        controller.startCountdown();
        controller.startTurn();
      });

      test('increments current team score', () {
        controller.rightAnswer();
        final state = container.read(gameControllerProvider);
        expect(state.scores[0], 1);
        expect(state.scores[1], 0);
      });

      test('advances to next word', () {
        final wordBefore = container.read(gameControllerProvider).currentWord;
        controller.rightAnswer();
        final wordAfter = container.read(gameControllerProvider).currentWord;
        expect(wordAfter, isNot(equals(wordBefore)));
      });

      test('increments wordIndex', () {
        expect(container.read(gameControllerProvider).wordIndex, 0);
        controller.rightAnswer();
        expect(container.read(gameControllerProvider).wordIndex, 1);
      });

      test('accumulates multiple correct answers', () {
        controller.rightAnswer();
        controller.rightAnswer();
        controller.rightAnswer();
        expect(container.read(gameControllerProvider).scores[0], 3);
      });

      test('with team override scores for specified team', () {
        controller.rightAnswer(team: 1);
        final state = container.read(gameControllerProvider);
        expect(state.scores[0], 0);
        expect(state.scores[1], 1);
      });

      test('with team override does not change word', () {
        final wordBefore = container.read(gameControllerProvider).currentWord;
        controller.rightAnswer(team: 1);
        final wordAfter = container.read(gameControllerProvider).currentWord;
        expect(wordAfter, equals(wordBefore));
      });
    });

    group('wrongAnswer', () {
      setUp(() {
        controller.initialize(_defaultSettings, _testWords());
        controller.startCountdown();
        controller.startTurn();
      });

      test('decrements current team score', () {
        // First get a point so we can lose one
        controller.rightAnswer();
        expect(container.read(gameControllerProvider).scores[0], 1);

        controller.wrongAnswer();
        expect(container.read(gameControllerProvider).scores[0], 0);
      });

      test('does not go below zero', () {
        controller.wrongAnswer();
        expect(container.read(gameControllerProvider).scores[0], 0);
      });

      test('advances to next word', () {
        final wordBefore = container.read(gameControllerProvider).currentWord;
        controller.wrongAnswer();
        final wordAfter = container.read(gameControllerProvider).currentWord;
        expect(wordAfter, isNot(equals(wordBefore)));
      });

      test('with team override decrements specified team', () {
        controller.rightAnswer(team: 1); // give team 1 a point
        controller.wrongAnswer(team: 1);
        expect(container.read(gameControllerProvider).scores[1], 0);
      });
    });

    group('skipAnswer', () {
      setUp(() {
        controller.initialize(_defaultSettings, _testWords());
        controller.startCountdown();
        controller.startTurn();
      });

      test('decrements skip count for current team', () {
        expect(container.read(gameControllerProvider).skipsLeft[0], 3);
        controller.skipAnswer();
        expect(container.read(gameControllerProvider).skipsLeft[0], 2);
      });

      test('advances to next word', () {
        final wordBefore = container.read(gameControllerProvider).currentWord;
        controller.skipAnswer();
        final wordAfter = container.read(gameControllerProvider).currentWord;
        expect(wordAfter, isNot(equals(wordBefore)));
      });

      test('does nothing when no skips left', () {
        controller.skipAnswer();
        controller.skipAnswer();
        controller.skipAnswer();
        final stateBefore = container.read(gameControllerProvider);
        expect(stateBefore.skipsLeft[0], 0);

        controller.skipAnswer();
        final stateAfter = container.read(gameControllerProvider);
        expect(stateAfter.skipsLeft[0], 0);
        expect(stateAfter.wordIndex, stateBefore.wordIndex);
      });

      test('does not affect score', () {
        controller.skipAnswer();
        expect(container.read(gameControllerProvider).scores[0], 0);
      });
    });

    group('skipLeftCurrentTeam', () {
      test('returns 0 when skips empty', () {
        expect(controller.skipLeftCurrentTeam, 0);
      });

      test('returns correct count after initialize', () {
        controller.initialize(_defaultSettings, _testWords());
        expect(controller.skipLeftCurrentTeam, 3);
      });

      test('decrements correctly', () {
        controller.initialize(_defaultSettings, _testWords());
        controller.startCountdown();
        controller.startTurn();
        controller.skipAnswer();
        expect(controller.skipLeftCurrentTeam, 2);
      });
    });

    group('oneSecPassed', () {
      setUp(() {
        controller.initialize(_defaultSettings, _testWords());
        controller.startCountdown();
        controller.startTurn();
      });

      test('increments secondsPassed', () {
        controller.oneSecPassed();
        expect(container.read(gameControllerProvider).secondsPassed, 1);
      });

      test('increments multiple times', () {
        for (int i = 0; i < 10; i++) {
          controller.oneSecPassed();
        }
        expect(container.read(gameControllerProvider).secondsPassed, 10);
      });
    });

    group('changeTurn', () {
      setUp(() {
        controller.initialize(_defaultSettings, _testWords());
        controller.startCountdown();
        controller.startTurn();
      });

      test('moves to next team', () {
        controller.changeTurn();
        expect(container.read(gameControllerProvider).currentTeam, 1);
      });

      test('wraps to team 0 and increments turn', () {
        controller.changeTurn(); // team 0 -> team 1
        controller.changeTurn(); // team 1 -> team 0, turn 0 -> turn 1
        final state = container.read(gameControllerProvider);
        expect(state.currentTeam, 0);
        expect(state.currentTurn, 1);
      });

      test('resets seconds to 0', () {
        controller.oneSecPassed();
        controller.oneSecPassed();
        controller.changeTurn();
        expect(container.read(gameControllerProvider).secondsPassed, 0);
      });

      test('resets skips for all teams', () {
        controller.skipAnswer(); // use a skip
        controller.changeTurn();
        final state = container.read(gameControllerProvider);
        expect(state.skipsLeft, [3, 3]);
      });

      test('ends game when all turns exhausted', () {
        // 2 players, 2 turns = 4 changeTurns to end
        controller.changeTurn(); // P1 done, -> P2 T0
        controller.changeTurn(); // P2 done, -> P0 T1
        controller.changeTurn(); // P0 done, -> P1 T1
        controller.changeTurn(); // P1 done, -> T2 >= totalTurns
        expect(container.read(gameControllerProvider).phase, GamePhase.ended);
      });

      test('sets phase to ready when game continues', () {
        controller.changeTurn();
        expect(container.read(gameControllerProvider).phase, GamePhase.ready);
      });

      test('advances word', () {
        final idxBefore = container.read(gameControllerProvider).wordIndex;
        controller.changeTurn();
        expect(container.read(gameControllerProvider).wordIndex, idxBefore + 1);
      });
    });

    group('endTurn', () {
      setUp(() {
        controller.initialize(_defaultSettings, _testWords());
        controller.startCountdown();
        controller.startTurn();
      });

      test('sets phase to ready when game continues', () {
        controller.endTurn();
        expect(container.read(gameControllerProvider).phase, GamePhase.ready);
      });

      test('keeps current team unchanged', () {
        controller.endTurn();
        expect(container.read(gameControllerProvider).currentTeam, 0);
      });

      test('ends game when last team of last turn', () {
        // Team 0 turn 0
        controller.changeTurn(); // -> Team 1, turn 0
        controller.changeTurn(); // -> Team 0, turn 1
        controller.changeTurn(); // -> Team 1, turn 1 (last turn for last team)
        // Now team 1 on turn 1. endTurn should check: nextTurn = 1, but
        // currentTeam+1 (2) >= nPlayers (2) => nextTurn++ = 2 >= totalTurns (2)
        controller.endTurn();
        expect(container.read(gameControllerProvider).phase, GamePhase.ended);
      });
    });

    group('word cycling', () {
      test('cycles through all words and reshuffles', () {
        final words = _testWords(3); // only 3 words
        controller.initialize(
          _defaultSettings.copyWith(nTurns: 100),
          words,
        );
        controller.startCountdown();
        controller.startTurn();

        // Use more answers than words to force reshuffle
        final seenWords = <String>{};
        for (int i = 0; i < 10; i++) {
          final word = container.read(gameControllerProvider).currentWord;
          seenWords.add(word!.wordToGuess);
          controller.rightAnswer();
        }

        // Should have seen all 3 original words
        expect(seenWords.length, 3);
      });
    });

    group('full game flow', () {
      test('2 teams, 1 turn, team 1 wins', () {
        final settings = _defaultSettings.copyWith(nTurns: 1);
        controller.initialize(settings, _testWords());

        // Team 0 plays
        controller.startCountdown();
        controller.startTurn();
        controller.rightAnswer(); // score: [1, 0]
        controller.changeTurn();

        // Team 1 plays
        controller.startCountdown();
        controller.startTurn();
        controller.rightAnswer();
        controller.rightAnswer(); // score: [1, 2]
        controller.changeTurn();

        final state = container.read(gameControllerProvider);
        expect(state.phase, GamePhase.ended);
        expect(state.scores, [1, 2]);
        expect(state.winners, [2]); // 1-based
      });

      test('tie game', () {
        final settings = _defaultSettings.copyWith(nTurns: 1);
        controller.initialize(settings, _testWords());

        // Team 0
        controller.startCountdown();
        controller.startTurn();
        controller.rightAnswer();
        controller.changeTurn();

        // Team 1
        controller.startCountdown();
        controller.startTurn();
        controller.rightAnswer();
        controller.changeTurn();

        final state = container.read(gameControllerProvider);
        expect(state.phase, GamePhase.ended);
        expect(state.scores, [1, 1]);
        expect(state.winners, [1, 2]);
      });
    });
  });
}
