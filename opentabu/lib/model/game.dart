/*
* OpenTabu is an Open Source game developed by Leonardo Rignanese <dev.rignanese@gmail.com>
* GNU Affero General Public License v3.0: https://choosealicense.com/licenses/agpl-3.0/
* GITHUB: https://github.com/rignaneseleo/OpenTabu
* */

import 'package:opentabu/model/word.dart';

class Game {
  final List<Word> _words;
  int _wordIndex = 0;
  final nSkips;

  List<int> _scores;
  List<int> _skips;

  Game(this._words, {int nTeams, this.nSkips}) {
    _words.shuffle();

    _scores = new List(nTeams);
    _skips = new List(nTeams);

    for (int i = 0; i < nTeams; i++) {
      //set every team score to 0
      _scores[i] = 0;

      //set every skip to nSkips
      _skips[i] = nSkips;
    }
  }

  get newWord {
    _wordIndex++;

    //TODO actually if it's the end, starts again from 0
    if (_wordIndex == _words.length) _wordIndex = 0;

    return _words[_wordIndex];
  }

  void rightAnswer(int teamNumber) {
    _scores[teamNumber]++;
  }

  void wrongAnswer(int teamNumber) {
    //TODO maybe it shouldn't go under 0
    _scores[teamNumber]--;
  }

  bool useSkip(int teamNumber) {
    if (_skips[teamNumber] == 0) return false;

    _skips[teamNumber]--;
    return true;
  }

  int getSkipLeft(int teamNumber) => _skips[teamNumber];

  void resetSkip() {
    //reset the skips of everyone
    for (int i = 0; i < _skips.length; i++) {
      //set every skip to nSkips
      _skips[i] = nSkips;
    }
  }

  get winner {
    int winner = 0;
    for (int i = 1; i < _scores.length; i++) {
      winner = _scores[i] > _scores[winner] ? i : winner;
    }
    return winner;
  }

  get scores => _scores;

  get numberOfPlayers => _scores.length;
}
