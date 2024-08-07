/*
* OpenTabu is an Open Source game developed by Leonardo Rignanese <dev.rignanese@gmail.com>
* GNU Affero General Public License v3.0: https://choosealicense.com/licenses/agpl-3.0/
* GITHUB: https://github.com/rignaneseleo/OpenTabu
* */

import '../../model/word.dart';

abstract class DataReader {
  List<Word>? allWords;

  Future<bool> loadFile(String langCode);

  Future<List<Word>> loadWords(int wordsNumber);
}
