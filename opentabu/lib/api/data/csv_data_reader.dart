/*
* OpenTabu is an Open Source game developed by Leonardo Rignanese <dev.rignanese@gmail.com>
* GNU Affero General Public License v3.0: https://choosealicense.com/licenses/agpl-3.0/
* GITHUB: https://github.com/rignaneseleo/OpenTabu
* */
import 'dart:async';

import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:speakeasy/model/word.dart';

import 'data_reader.dart';

class CSVDataReader extends DataReader {
  @override
  Future<List<Word>> loadWords(int wordsLimit) async {
    //if not payed, limit to first 200
    List<Word> words = [];
    if (allWords!.length > wordsLimit) {
      words = allWords!.sublist(0, wordsLimit);
    } else {
      words = allWords!;
    }

    print("Loaded ${words.length} taboos in the app");

    return words..shuffle();
  }

  @override
  Future<bool> loadFile(String langCode) async {
    try {
      String csvRaw = "";
      try {
        csvRaw =
            await rootBundle.loadString('assets/words/$langCode/words.csv');
      } catch (_) {
        //if the language is not supported, return english
        print(
            "WARNING: Language $langCode not supported, loading english words");
        langCode = "en";
        csvRaw =
            await rootBundle.loadString('assets/words/$langCode/words.csv');
      }

      var csvRows = const CsvToListConverter().convert<String>(
        csvRaw,
        eol: "\n",
        shouldParseNumbers: false,
      );
      print("The file $langCode/words.csv contains ${csvRows.length} rows");

      allWords = await _convertCsvRowsIntoWords(csvRows);
      print(
          "There are ${allWords?.length} unique taboos in $langCode/words.csv");

      return true;
    } on Exception catch (e) {
      print("Error loading data file $langCode: $e");
      return false;
    }
  }

  Future<List<Word>> _convertCsvRowsIntoWords(List<List<String>> rows) async {
    Map<String, Word> _words = {};

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
