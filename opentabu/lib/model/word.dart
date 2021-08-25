/*
* OpenTabu is an Open Source game developed by Leonardo Rignanese <dev.rignanese@gmail.com>
* GNU Affero General Public License v3.0: https://choosealicense.com/licenses/agpl-3.0/
* GITHUB: https://github.com/rignaneseleo/OpenTabu
* */

class Word {
  String _wordToGuess;
  List<String> _taboos;

  Word(this._wordToGuess, this._taboos) {
    _wordToGuess = _capitalize(_wordToGuess.trim());

    for (int i = 0; i < _taboos.length; i++) {
      if (_taboos[i].length == 0) //if the string is empty
        _taboos.removeAt(i--); //remove it
      else
        _taboos[i] = _capitalize(_taboos[i].trim());
    }

    //every time I load the game, the taboos will be in different order
    _taboos.shuffle();
  }

  String get wordToGuess => _wordToGuess;

  List<String> get taboos {
    return _taboos;
  }

  String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);
}
