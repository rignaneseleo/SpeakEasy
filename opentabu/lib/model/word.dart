/*
* OpenTabu is an Open Source game developed by Leonardo Rignanese <dev.rignanese@gmail.com>
* GNU Affero General Public License v3.0: https://choosealicense.com/licenses/agpl-3.0/
* GITHUB: https://github.com/rignaneseleo/OpenTabu
* */

import '../utils/utils.dart';

class Word {
  late final String wordToGuess;
  late final List<String> taboos;

  int get nTabu => taboos.length;

  Word(String _wordToGuess, List<String> _taboos) {
    wordToGuess = capitalize(_wordToGuess.trim());
    taboos = [];
    addTabus(_taboos);

    //every time I load the game, the taboos will be in different order
    taboos.shuffle();

    assert(wordToGuess.isNotEmpty, "wordToGuess is empty");
    assert(taboos.isNotEmpty, "taboos is empty on $wordToGuess");
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
    if (tabu.isEmpty) return false;

    if (taboos.contains(tabu)) return false;

    if (wordToGuess.contains(tabu)) {
      print(
          "WARNING: $wordToGuess is a substring of the taboo $tabu");
    }

    taboos.add(tabu);
    return true;
  }
}
