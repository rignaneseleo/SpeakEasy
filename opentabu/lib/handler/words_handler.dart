import 'package:opentabu/model/word.dart';

class WordHandler {
  final List<Word> _words;
  int _wordIndex;

  WordHandler(this._words) {
    _words.shuffle();
    _wordIndex = 0;
  }

  get newWord {
    if (_wordIndex == _words.length) {
      _wordIndex = 0;
      _words.shuffle();
      print("Words are over, shuffling the list");
    }

    return _words[_wordIndex++];
  }
}
