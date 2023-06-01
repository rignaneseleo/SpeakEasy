/*
* OpenTabu is an Open Source game developed by Leonardo Rignanese <dev.rignanese@gmail.com>
* GNU Affero General Public License v3.0: https://choosealicense.com/licenses/agpl-3.0/
* GITHUB: https://github.com/rignaneseleo/OpenTabu
* */
import 'dart:async';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:speakeasy/model/word.dart';

import '../main.dart';
import '../utils/toast.dart';

class CSVDataReader {
  static Future<List<Word>> loadWords() async {
    var localeName = sp.getString("saved_locale") ?? Platform.localeName;
    showToast("${sp.getString("saved_locale")}\r\n${Platform.localeName}");
    var words =
        await readWords('assets/words/${localeName.substring(0, 2)}/words.csv');

    //if not payed, limit to 200
    int wordsLimit = 200;

    if (!(sp.getBool("1000words") ?? false)) {
      if (sp.getBool("100words") ?? false) wordsLimit += 100;
      if (sp.getBool("500words") ?? false) wordsLimit += 500;
      if (words.length > wordsLimit) words = words.sublist(0, wordsLimit);
    }

    return words..shuffle();
    //_printWords(words);
  }

  static Future<List<Word>> readWords(String filePath) async {
    Map<String, Word> _words = {};

    String wordsCSV =
        await rootBundle.loadString(filePath, cache: kReleaseMode);

    List<List> rows = CsvToListConverter().convert(wordsCSV, eol: "\n");
    print("CSV READER: ${rows.length} rows");

    for (List row in rows) {
      var rowList = List<String>.from(row);
      String wordToGuess = rowList[0].toLowerCase().trim();
      if (wordToGuess.isEmpty) continue;
      if (_words.containsKey(wordToGuess)) {
        // if the row is already in the map, add the new tabu
        print(
            "WARNING: ${wordToGuess.toUpperCase()} already in the map, merging the tabus:");
        _words[wordToGuess]!.addTabus(rowList.sublist(1));
        print("Result: ${_words[wordToGuess]!.taboos}");
        //print("NEW: ${_words[wordToGuess]!.taboos}");
      } else {
        //new row
        _words[wordToGuess] = Word(rowList[0], rowList.sublist(1));
      }
    }

    print("Loaded ${_words.length} unique rows from ${filePath}");
    return _words.values.toList();
  }
}
