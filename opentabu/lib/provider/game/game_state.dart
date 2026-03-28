import 'package:freezed_annotation/freezed_annotation.dart';

import '../../model/word.dart';

part 'game_state.freezed.dart';

enum GamePhase { initial, ready, countdown, playing, paused, ended }

@freezed
class GameState with _$GameState {
  const GameState._();

  const factory GameState({
    @Default(GamePhase.initial) GamePhase phase,
    @Default([]) List<int> scores,
    @Default([]) List<int> skipsLeft,
    @Default(0) int currentTeam,
    @Default(0) int currentTurn,
    @Default(0) int totalTurns,
    @Default(0) int nSkipsPerTeam,
    @Default(0) int secondsPassed,
    @Default([]) List<Word> words,
    @Default(0) int wordIndex,
    Word? currentWord,
  }) = _GameState;

  int get numberOfPlayers => scores.length;

  int get nextTeam =>
      currentTeam + 1 >= numberOfPlayers ? 0 : currentTeam + 1;

  int get previousTeam =>
      currentTeam - 1 >= 0 ? currentTeam - 1 : numberOfPlayers - 1;

  int get displayTurn => currentTurn + 1;

  List<String> get teamNames =>
      List.generate(numberOfPlayers, (i) => 'Team ${i + 1}');

  List<int> get winners {
    if (scores.isEmpty) return [];
    final maxScore = scores.reduce((a, b) => a > b ? a : b);
    if (scores.every((s) => s == maxScore)) {
      return List.generate(numberOfPlayers, (i) => i + 1);
    }
    return [
      for (int i = 0; i < scores.length; i++)
        if (scores[i] == maxScore) i + 1,
    ];
  }
}
