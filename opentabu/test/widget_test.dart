/*
// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speakeasy/main.dart';

void main() {
  testWidgets('Testing the CSV read', (WidgetTester tester) async {
    words = await CSVDataReader.readWords('assets/words/it/min.csv');
    assert(words.length > 0);

    var wordTabusCount = {
      "libro": 18, //duplicate tabu
      "profondo": 8, //duplicate row
    };

    for (var wordTabus in wordTabusCount.entries) {
      var w =
          words.firstWhere((w) => w.wordToGuess.toLowerCase() == wordTabus.key);
      assert(w.nTabu == wordTabus.value,
          "The word ${w.wordToGuess} has ${w.nTabu} tabus, but ${wordTabus.value} were expected: ${w.taboos}");
    }
  });
}
*/
