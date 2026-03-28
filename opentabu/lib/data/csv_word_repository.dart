import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../model/word.dart';
import '../util/extensions.dart';

class CsvWordRepository {
  List<Word>? _allWords;

  Future<void> loadFile(String langCode) async {
    String csvRaw;
    try {
      csvRaw =
          await rootBundle.loadString('assets/words/$langCode/words.csv');
    } catch (_) {
      langCode = 'en';
      csvRaw =
          await rootBundle.loadString('assets/words/$langCode/words.csv');
    }

    final csvRows = const CsvToListConverter().convert<String>(
      csvRaw,
      eol: '\n',
      shouldParseNumbers: false,
    );

    _allWords = _convertCsvRows(csvRows);
  }

  List<Word> loadWords(int limit) {
    final words = _allWords!;
    final limited = words.length > limit ? words.sublist(0, limit) : words;
    return List.of(limited)..shuffle();
  }

  List<Word> _convertCsvRows(List<List<String>> rows) {
    final wordsMap = <String, List<String>>{};

    for (final row in rows) {
      final wordToGuess = row[0].trim().toLowerCase();
      if (wordToGuess.isEmpty) continue;

      final taboos = row
          .sublist(1)
          .map((t) => t.trim().capitalized)
          .where((t) => t.isNotEmpty)
          .toList();

      if (wordsMap.containsKey(wordToGuess)) {
        final existing = wordsMap[wordToGuess]!;
        for (final taboo in taboos) {
          if (!existing.contains(taboo)) existing.add(taboo);
        }
      } else {
        wordsMap[wordToGuess] = taboos;
      }
    }

    return wordsMap.entries.map((e) {
      final taboos = List.of(e.value)..shuffle();
      return Word(wordToGuess: e.key.capitalized, taboos: taboos);
    }).toList();
  }
}
