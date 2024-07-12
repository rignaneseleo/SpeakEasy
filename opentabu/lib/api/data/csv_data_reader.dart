/*
* OpenTabu is an Open Source game developed by Leonardo Rignanese <dev.rignanese@gmail.com>
* GNU Affero General Public License v3.0: https://choosealicense.com/licenses/agpl-3.0/
* GITHUB: https://github.com/rignaneseleo/OpenTabu
* */
import 'dart:async';

import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:speakeasy/model/word.dart';

import '../../main.dart';
import 'data_reader.dart';

class CSVDataReader extends DataReader {
  @override
  Future<List<Word>> loadWords(String langCode) async {
    //if the language is not supported, return english
    String csvRaw = "";
    try {
      csvRaw = await rootBundle.loadString('assets/words/$langCode/words.csv');
    } catch (_) {
      print("WARNING: Language $langCode not supported, loading english words");
      langCode = "en";
      csvRaw = await rootBundle.loadString('assets/words/$langCode/words.csv');
    }

    var words = await readWords(csvRaw);
    print("Loaded ${words.length} unique rows from $langCode words.csv");

    //if not payed, limit to first 200
    int wordsLimit = 200;

    if (!(sp.getBool("1000words") ?? false)) {
      if (sp.getBool("100words") ?? false) wordsLimit += 100;
      if (sp.getBool("500words") ?? false) wordsLimit += 500;
      if (words.length > wordsLimit) words = words.sublist(0, wordsLimit);
    }

    return words..shuffle();
    //_printWords(words);
  }

  Future<List<Word>> readWords(String wordsCSV) async {
    Map<String, Word> _words = {};

    var rows = const CsvToListConverter().convert(wordsCSV, eol: "\n");
    print("CSV READER: ${rows.length} rows");

    for (var row in rows) {
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

    return _words.values.toList();
  }
}
