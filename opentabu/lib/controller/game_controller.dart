/*
* OpenTabu is an Open Source game developed by Leonardo Rignanese <dev.rignanese@gmail.com>
* GNU Affero General Public License v3.0: https://choosealicense.com/licenses/agpl-3.0/
* GITHUB: https://github.com/rignaneseleo/OpenTabu
* */

import 'package:opentabu/handler/words_handler.dart';
import 'package:opentabu/controller/teams_controller.dart';
import 'package:opentabu/model/settings.dart';
import 'package:opentabu/model/team.dart';
import 'package:opentabu/model/word.dart';

class GameController {
  Settings settings;
  WordHandler _wordHandler;
  TeamsController _teamsController;

  bool _active = false;

  Word _currentWord;

  Word get currentWord => _currentWord;
  int _iCurrentTeam = 0;
  int _currentTurn = 0;

  int _secondsPassed = 0;

  GameController(this._wordHandler, this.settings) {
    _teamsController = new TeamsController(settings);
    _active = false;
  }

  start() {
    _currentWord = _wordHandler.newWord;
    _active = true;
  }

  end() {
    List winners = _teamsController.getWinner();
    //TODO
    _active = false;
  }

  pause() {
    _active = false;
  }

  restore() {
    _active = true;
  }

  /// Returns false if the game is over
  bool canChangeTurn() {
    return !(_currentTurn + 1 > settings.nTurns);
  }

  void startNewTurn() {
    _iCurrentTeam = _teamsController.changeTurn();
    _secondsPassed = 0;
    _currentWord = _wordHandler.newWord;
  }

  void rightAnswer() {
    _teamsController.rightAnswer();
    _currentWord = _wordHandler.newWord;
  }

  void wrongAnswer() {
    _teamsController.wrongAnswer();
    _currentWord = _wordHandler.newWord;
  }

  void skipAnswer() {
    bool effective = _teamsController.skip();
    if (effective)
      _currentWord = _wordHandler.newWord;
    else
      print("Skip finished");
  }

  int oneSecPassed() {
    if (_active) _secondsPassed++;
    return _secondsPassed;
  }

  int get iCurrentTeam => _iCurrentTeam;

  int get currentTurn => _currentTurn;

  int get secondsPassed => _secondsPassed;

  List<Team> get teams => _teamsController.teams;

  Team get currentTeam => _teamsController.currentTeam;
}
