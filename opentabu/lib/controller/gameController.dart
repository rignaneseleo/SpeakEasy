/*
* OpenTabu is an Open Source game developed by Leonardo Rignanese <dev.rignanese@gmail.com>
* GNU Affero General Public License v3.0: https://choosealicense.com/licenses/agpl-3.0/
* GITHUB: https://github.com/rignaneseleo/OpenTabu
* */

import 'package:Tabu/model/game.dart';
import 'package:Tabu/model/settings.dart';
import 'package:Tabu/model/word.dart';

class GameController {
  Game _game;
  int _numbersOfTurns;

  Word _currentWord;
  int _currentTeam = 0; //the team that starts
  int _currentTurn = 0;

  int _secondsPassed = 0;

  GameController(Settings settings, List<Word> words) {
    _game = new Game(words, nTeams: settings.nPlayers, nSkips: settings.nSkip);
    _currentWord = _game.newWord;
    _numbersOfTurns = settings.nTurns;
  }

  //returns true if the game is over
  bool changeTurn() {
    _currentTeam++;
    if (_currentTeam == _game.numberOfPlayers) {
      _currentTeam = 0;
      _currentTurn++;
    }

    _game.resetSkip();
    _secondsPassed = 0;

    _currentWord = _game.newWord;

    return _currentTurn >= _numbersOfTurns;
  }

  void rightAnswer() {
    _game.rightAnswer(_currentTeam);
    _currentWord = _game.newWord;
  }

  void wrongAnswer() {
    _game.wrongAnswer(_currentTeam);
    _currentWord = _game.newWord;
  }

  void skipAnswer() {
    if (_game.useSkip(_currentTeam)) _currentWord = _game.newWord;
  }

  void oneSecPassed() => _secondsPassed++;

  get winner => _game.winner + 1;

  get currentTurn => _currentTurn + 1;

  get skipLeftCurrentTeam => _game.getSkipLeft(_currentTeam);

  get currentWord => _currentWord;

  get scores => _game.scores;

  get numberOfPlayers => _game.numberOfPlayers;

  get currentTeam => _currentTeam;

  get secondsPassed => _secondsPassed;
}
