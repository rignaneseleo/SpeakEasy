/*
* OpenTabu is an Open Source game developed by Leonardo Rignanese <dev.rignanese@gmail.com>
* GNU Affero General Public License v3.0: https://choosealicense.com/licenses/agpl-3.0/
* GITHUB: https://github.com/rignaneseleo/OpenTabu
* *//*

import 'package:speakeasy/model/word.dart';
import 'data_reader.dart';

class FakeDataReader extends DataReader {
  @override
  Future<List<Word>> loadWords(String langCode) async {
    return [
      new Word("Train", ["Fast", "Rails", "Station"]),
      new Word("Boat", ["Slow", "Sea", "Harbor"])
    ];
  }
}
*/
