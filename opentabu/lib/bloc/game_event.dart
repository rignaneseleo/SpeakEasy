import 'package:equatable/equatable.dart';
import 'package:opentabu/model/settings.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();
}

class InitGame extends GameEvent {
  final Settings settings;

  const InitGame(this.settings);

  @override
  List<Object> get props => [settings];
}

class StartGame extends GameEvent {
  @override
  List<Object> get props => [];
}

class EndGame extends GameEvent {
  @override
  List<Object> get props => [];
}

class Pause extends GameEvent {
  @override
  List<Object> get props => [];
}

class Restore extends GameEvent {
  const Restore();

  @override
  List<Object> get props => [];
}

class Timeout extends GameEvent {
  const Timeout();

  @override
  List<Object> get props => [];
}

class OneSecondPassed extends GameEvent {
  @override
  List<Object> get props => [];
}

enum AnswerType { correct, incorrect, skip }

class Answer extends GameEvent {
  final AnswerType answerType;

  const Answer(this.answerType);

  @override
  List<Object> get props => [answerType];
}
