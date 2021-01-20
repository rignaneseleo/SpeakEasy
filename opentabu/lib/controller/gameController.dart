/*
* OpenTabu is an Open Source game developed by Leonardo Rignanese <dev.rignanese@gmail.com>
* GNU Affero General Public License v3.0: https://choosealicense.com/licenses/agpl-3.0/
* GITHUB: https://github.com/rignaneseleo/OpenTabu
* */

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:opentabu/model/game.dart';
import 'package:opentabu/model/settings.dart';
import 'package:opentabu/model/word.dart';

final gameProvider =
    ChangeNotifierProvider.autoDispose((ref) => GameController());

enum GameState {
  init, //Initial state, not ready
  ready, //Ready to start state
  playing, //While a team is playing
  pause, //In pause
  ended, //When there is a winner
}

class GameController extends ChangeNotifier {
  Game _game;
  GameState gameState = GameState.init;

  int _numbersOfTurns;

  Word _currentWord;
  int _currentTeam = 0; //the team that starts
  int _currentTurn = 0;

  int _secondsPassed = 0;

  void init(Settings settings, List<Word> words) {
    _game = new Game(words, nTeams: settings.nPlayers, nSkips: settings.nSkip);
    _currentWord = _game.newWord;
    _numbersOfTurns = settings.nTurns;

    gameState = GameState.ready;
    notifyListeners();
  }

  //returns true if the game is over
  void changeTurn() {
    _currentTeam++;
    if (_currentTeam == _game.numberOfPlayers) {
      _currentTeam = 0;
      _currentTurn++;
    }

    _game.resetSkip();
    _secondsPassed = 0;

    _currentWord = _game.newWord;

    gameState = GameState.ready;

    //Check if it's the end
    if (_currentTurn >= _numbersOfTurns) gameState = GameState.ended;

    notifyListeners();
  }

  void startTurn() {
    if (gameState == GameState.ready) {
      gameState = GameState.playing;
      notifyListeners();
    } else
      throw Exception("Start turn with a state $gameState");
  }

  void pauseGame() {
    if (gameState == GameState.playing) {
      gameState = GameState.pause;
      notifyListeners();
    } else
      throw Exception("Pause game from a state $gameState");
  }

  void resumeGame() {
    if (gameState == GameState.pause) {
      gameState = GameState.playing;
      notifyListeners();
    } else
      throw Exception("Resume game from a state $gameState");
  }

  void rightAnswer() {
    _game.rightAnswer(_currentTeam);
    _currentWord = _game.newWord;
    notifyListeners();
  }

  void wrongAnswer() {
    _game.wrongAnswer(_currentTeam);
    _currentWord = _game.newWord;
    notifyListeners();
  }

  void skipAnswer() {
    if (_game.useSkip(_currentTeam)) _currentWord = _game.newWord;
    notifyListeners();
  }

  void oneSecPassed() {
    _secondsPassed++;
    notifyListeners();
  }

  List<int> get winners => _game.winners;

  int get currentTurn => _currentTurn + 1;

  int get skipLeftCurrentTeam => _game.getSkipLeft(_currentTeam);

  Word get currentWord => _currentWord;

  List<int> get scores => _game.scores;

  int get numberOfPlayers => _game?.numberOfPlayers ?? 0;

  int get currentTeam => _currentTeam;

  int get secondsPassed => _secondsPassed;
}
