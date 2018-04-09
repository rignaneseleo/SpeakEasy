/*
* OpenTabu is an Open Source game developed by Leonardo Rignanese <dev.rignanese@gmail.com>
* GNU Affero General Public License v3.0: https://choosealicense.com/licenses/agpl-3.0/
* GITHUB: https://github.com/rignaneseleo/OpenTabu
* */

class Word {
  final String _wordToGuess;
  final List<String> _taboos;

  Word(this._wordToGuess, this._taboos);

  get wordToGuess => _wordToGuess;

  get taboos => _taboos;
}
