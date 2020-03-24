import 'package:equatable/equatable.dart';
import 'package:opentabu/controller/game_controller.dart';
import 'package:opentabu/model/word.dart';

abstract class GameState extends Equatable {
  const GameState();
}

class LoadingState extends GameState {
  @override
  List<Object> get props => [];
}

class InitialGameState extends GameState {
  @override
  List<Object> get props => [];
}

class StartedGameState extends GameState {
  final GameController game;

  const StartedGameState(this.game);

  @override
  List<Object> get props => [game];
}

class EndedGameState extends GameState {
  @override
  List<Object> get props => [];
}

class PausedGameState extends GameState {
  @override
  List<Object> get props => [];
}

class RestoreGameState extends GameState {
  @override
  List<Object> get props => [];
}

class UpdateTimeState extends GameState {
  final int time;

  const UpdateTimeState(this.time);

  @override
  List<Object> get props => [time];
}

class UpdateGameState extends GameState {
  final GameController game;

  const UpdateGameState(this.game);

  @override
  List<Object> get props => [game];
}
