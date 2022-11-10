/*
* OpenTabu is an Open Source game developed by Leonardo Rignanese <dev.rignanese@gmail.com>
* GNU Affero General Public License v3.0: https://choosealicense.com/licenses/agpl-3.0/
* GITHUB: https://github.com/rignaneseleo/OpenTabu
* */

import '../utils/utils.dart';

class Word {
  late String _wordToGuess;
  List<String> _taboos = [];

  String get wordToGuess => _wordToGuess;

  List<String> get taboos => _taboos;

  int get nTabu => _taboos.length;

  Word(String wordToGuess, List<String> taboos) {
    _wordToGuess = capitalize(wordToGuess.trim());
    addTabus(taboos);

    //every time I load the game, the taboos will be in different order
    _taboos.shuffle();

    assert(_wordToGuess.isNotEmpty);
    assert(_taboos.isNotEmpty);
  }

  bool addTabus(List<String> taboos) {
    bool success = true;
    for (String taboo in taboos) {
      if (!addTabu(taboo)) success = false;
    }
    return success;
  }

  bool addTabu(String tabu) {
    tabu = capitalize(tabu.trim());
    if (tabu.length == 0) return false;

    if (_taboos.contains(tabu)) return false;
    _taboos.add(tabu);
    return true;
  }
}
