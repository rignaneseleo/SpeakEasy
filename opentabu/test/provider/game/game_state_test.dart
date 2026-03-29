import 'package:flutter_test/flutter_test.dart';
import 'package:speakeasy/provider/game/game_state.dart';

void main() {
  group('GameState', () {
    group('defaults', () {
      test('has correct initial values', () {
        const state = GameState();
        expect(state.phase, GamePhase.initial);
        expect(state.scores, isEmpty);
        expect(state.skipsLeft, isEmpty);
        expect(state.currentTeam, 0);
        expect(state.currentTurn, 0);
        expect(state.totalTurns, 0);
        expect(state.nSkipsPerTeam, 0);
        expect(state.secondsPassed, 0);
        expect(state.words, isEmpty);
        expect(state.wordIndex, 0);
        expect(state.currentWord, isNull);
      });
    });

    group('numberOfPlayers', () {
      test('returns 0 when scores empty', () {
        const state = GameState();
        expect(state.numberOfPlayers, 0);
      });

      test('returns count from scores list', () {
        const state = GameState(scores: [0, 0, 0]);
        expect(state.numberOfPlayers, 3);
      });
    });

    group('nextTeam', () {
      test('returns next team index', () {
        const state = GameState(scores: [0, 0, 0]);
        expect(state.nextTeam, 1);
      });

      test('wraps around to 0', () {
        const state = GameState(scores: [0, 0, 0], currentTeam: 2);
        expect(state.nextTeam, 0);
      });

      test('works for 2 teams', () {
        const state = GameState(scores: [0, 0], currentTeam: 1);
        expect(state.nextTeam, 0);
      });
    });

    group('previousTeam', () {
      test('returns previous team index', () {
        const state = GameState(scores: [0, 0, 0], currentTeam: 2);
        expect(state.previousTeam, 1);
      });

      test('wraps around to last team', () {
        const state = GameState(scores: [0, 0, 0]);
        expect(state.previousTeam, 2);
      });
    });

    group('displayTurn', () {
      test('returns 1-based turn number', () {
        const state = GameState();
        expect(state.displayTurn, 1);
      });

      test('returns correct value for later turns', () {
        const state = GameState(currentTurn: 4);
        expect(state.displayTurn, 5);
      });
    });

    group('teamNames', () {
      test('returns empty for no players', () {
        const state = GameState();
        expect(state.teamNames, isEmpty);
      });

      test('generates names for 2 teams', () {
        const state = GameState(scores: [0, 0]);
        expect(state.teamNames, ['Team 1', 'Team 2']);
      });

      test('generates names for 5 teams', () {
        const state = GameState(scores: [0, 0, 0, 0, 0]);
        expect(state.teamNames.length, 5);
        expect(state.teamNames.last, 'Team 5');
      });
    });

    group('winners', () {
      test('returns empty when no scores', () {
        const state = GameState();
        expect(state.winners, isEmpty);
      });

      test('returns single winner', () {
        const state = GameState(scores: [5, 3, 1]);
        expect(state.winners, [1]); // 1-based index
      });

      test('returns all teams on tie', () {
        const state = GameState(scores: [3, 3, 3]);
        expect(state.winners, [1, 2, 3]);
      });

      test('returns multiple winners on partial tie', () {
        const state = GameState(scores: [5, 5, 3]);
        expect(state.winners, [1, 2]);
      });

      test('returns all on zero-zero tie', () {
        const state = GameState(scores: [0, 0]);
        expect(state.winners, [1, 2]);
      });

      test('handles single team', () {
        const state = GameState(scores: [10]);
        expect(state.winners, [1]);
      });
    });
  });

  group('GamePhase', () {
    test('has all expected values', () {
      expect(
          GamePhase.values,
          containsAll([
            GamePhase.initial,
            GamePhase.ready,
            GamePhase.countdown,
            GamePhase.playing,
            GamePhase.paused,
            GamePhase.ended,
          ]),);
    });

    test('has exactly 6 phases', () {
      expect(GamePhase.values.length, 6);
    });
  });
}
