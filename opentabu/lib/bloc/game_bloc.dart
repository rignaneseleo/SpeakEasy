import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:opentabu/controller/game_controller.dart';
import 'package:opentabu/main.dart';
import './bloc.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final GameController controller;

  GameBloc(this.controller);

  @override
  GameState get initialState => InitialGameState();

  @override
  Stream<GameState> mapEventToState(
    GameEvent event,
  ) async* {
    //yield LoadingState();

    if (event is InitGame) {
      //controller = new GameController(event.settings, words);
      yield InitialGameState();
    } else if (event is StartGame) {
      controller.start();
      yield StartedGameState(controller);
    } else if (event is EndGame) {
      controller.end();
      yield EndedGameState(); //TODO passa i risultati
    } else if (event is OneSecondPassed) {
      int timeLeft = controller.oneSecPassed();
      yield UpdateGameState(controller);
    } else if (event is Pause) {
      controller.pause();
      yield PausedGameState();
    } else if (event is Restore) {
      controller.restore();
      yield RestoreGameState();
    } else if (event is Timeout) {
      controller.startNewTurn();
      yield UpdateGameState(controller);
    } else if (event is Answer) {
      switch (event.answerType) {
        case AnswerType.correct:
          controller.rightAnswer();
          break;
        case AnswerType.incorrect:
          controller.wrongAnswer();
          break;
        case AnswerType.skip:
          controller.skipAnswer();
          break;
      }
      yield UpdateGameState(controller);
    }
  }
}
