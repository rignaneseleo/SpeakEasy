import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../model/game_settings.dart';
import '../../model/word.dart';
import 'game_state.dart';

part 'game_controller.g.dart';

@riverpod
class GameController extends _$GameController {
  @override
  GameState build() => const GameState();

  void initialize(GameSettings settings, List<Word> words) {
    final shuffled = List.of(words)..shuffle();
    state = GameState(
      phase: GamePhase.ready,
      scores: List.filled(settings.nPlayers, 0),
      skipsLeft: List.filled(settings.nPlayers, settings.nSkip),
      nSkipsPerTeam: settings.nSkip,
      totalTurns: settings.nTurns,
      words: shuffled,
      currentWord: shuffled.first,
      wordIndex: 0,
    );
    WakelockPlus.enable();
  }

  Word _nextWord() {
    var idx = state.wordIndex + 1;
    var words = state.words;
    if (idx >= words.length) {
      words = List.of(words)..shuffle();
      idx = 0;
    }
    return words[idx];
  }

  void changeTurn() {
    var nextTeam = state.currentTeam + 1;
    var nextTurn = state.currentTurn;

    if (nextTeam >= state.numberOfPlayers) {
      nextTeam = 0;
      nextTurn++;
    }

    final nextWord = _nextWord();
    final newPhase =
        nextTurn >= state.totalTurns ? GamePhase.ended : GamePhase.ready;

    state = state.copyWith(
      phase: newPhase,
      currentTeam: nextTeam,
      currentTurn: nextTurn,
      skipsLeft: List.filled(state.numberOfPlayers, state.nSkipsPerTeam),
      secondsPassed: 0,
      currentWord: nextWord,
      wordIndex: state.wordIndex + 1,
    );
    _updateWakelock(newPhase);
  }

  void endTurn() {
    var nextTurn = state.currentTurn;
    if (state.currentTeam + 1 >= state.numberOfPlayers) {
      nextTurn++;
    }

    final newPhase =
        nextTurn >= state.totalTurns ? GamePhase.ended : GamePhase.ready;

    state = state.copyWith(phase: newPhase);
    _updateWakelock(newPhase);
  }

  void startCountdown() {
    state = state.copyWith(phase: GamePhase.countdown);
    WakelockPlus.enable();
  }

  void startTurn() {
    state = state.copyWith(phase: GamePhase.playing);
    WakelockPlus.enable();
  }

  void pauseGame() {
    state = state.copyWith(phase: GamePhase.paused);
    WakelockPlus.disable();
  }

  void resumeGame() {
    state = state.copyWith(phase: GamePhase.playing);
    WakelockPlus.enable();
  }

  void rightAnswer({int? team}) {
    final t = team ?? state.currentTeam;
    final newScores = List.of(state.scores);
    newScores[t]++;

    state = state.copyWith(
      scores: newScores,
      currentWord: team == null ? _nextWord() : state.currentWord,
      wordIndex: team == null ? state.wordIndex + 1 : state.wordIndex,
    );
  }

  void wrongAnswer({int? team}) {
    final t = team ?? state.currentTeam;
    final newScores = List.of(state.scores);
    if (newScores[t] > 0) newScores[t]--;

    state = state.copyWith(
      scores: newScores,
      currentWord: team == null ? _nextWord() : state.currentWord,
      wordIndex: team == null ? state.wordIndex + 1 : state.wordIndex,
    );
  }

  void skipAnswer() {
    final skips = List.of(state.skipsLeft);
    if (skips[state.currentTeam] <= 0) return;
    skips[state.currentTeam]--;

    state = state.copyWith(
      skipsLeft: skips,
      currentWord: _nextWord(),
      wordIndex: state.wordIndex + 1,
    );
  }

  void oneSecPassed() {
    state = state.copyWith(secondsPassed: state.secondsPassed + 1);
  }

  int get skipLeftCurrentTeam => state.skipsLeft.isEmpty
      ? 0
      : state.skipsLeft[state.currentTeam];

  void _updateWakelock(GamePhase phase) {
    if (phase == GamePhase.paused || phase == GamePhase.ended) {
      WakelockPlus.disable();
    } else {
      WakelockPlus.enable();
    }
  }
}
