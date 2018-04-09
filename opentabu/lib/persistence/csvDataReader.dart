/*
* OpenTabu is an Open Source game developed by Leonardo Rignanese <dev.rignanese@gmail.com>
* GNU Affero General Public License v3.0: https://choosealicense.com/licenses/agpl-3.0/
* GITHUB: https://github.com/rignaneseleo/OpenTabu
* */
import 'dart:async';

import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:opentabu/model/word.dart';
import 'package:opentabu/persistence/dataReader.dart';

class CSVDataReader extends DataReader {
  List<Word> _words;

  CSVDataReader() {
    _words = new List<Word>();

    _loadAsset().then((wordsCSV) {
      List<List<String>> words = const CsvToListConverter().convert(wordsCSV);

      words.forEach((row) => _words.add(_createWord(row)));
    });
  }

/*  Future<List<Word>> loadList() {
    _words = new List<Word>();
    var completer = new Completer();

    _loadAsset().then((wordsCSV) {
      List<List<String>> words = const CsvToListConverter().convert(wordsCSV);
      words.forEach((row) => _words.add(_createWord(row)));
      completer.complete(_words);

      return completer.future;
    });
  }*/

  Word _createWord(List<String> row) {
    return new Word(row[0], row.sublist(1));
  }

  Future<String> _loadAsset() async {
    return await rootBundle.loadString('csv/words.csv');
  }

  // TODO: implement words
  @override
  get words => _words;
}
