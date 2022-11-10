/*
* OpenTabu is an Open Source game developed by Leonardo Rignanese <dev.rignanese@gmail.com>
* GNU Affero General Public License v3.0: https://choosealicense.com/licenses/agpl-3.0/
* GITHUB: https://github.com/rignaneseleo/OpenTabu
* */
import 'dart:async';

import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:opentabu/model/word.dart';

class CSVDataReader {
  static Future<List<Word>> readData(String filePath) async {
    Map<String, Word> _words = {};

    String wordsCSV = await rootBundle.loadString(filePath);

    List<List> words = CsvToListConverter().convert(wordsCSV);

    for (List row in words) {
      var rowList = List<String>.from(row);
      String wordToGuess = rowList[0].toLowerCase().trim();
      if (_words.containsKey(wordToGuess)) {
        // if the word is already in the map, add the new tabu
        print("WARNING: ${wordToGuess.toUpperCase()} already in the map, merging the tabus:");
        print("OLD: ${_words[wordToGuess]!.taboos}");
        print("CURRENT: ${rowList.sublist(1)}");
        _words[wordToGuess]!.addTabus(rowList.sublist(1));
        print("NEW: ${_words[wordToGuess]!.taboos}");
      } else {
        //new word
        _words[wordToGuess] = _createWord(rowList);
      }
    }

    return _words.values.toList();
  }

  static Word _createWord(List<String> row) {
    //print("Read the word '${row[0]}'");
    return new Word(row[0], row.sublist(1));
  }
}
