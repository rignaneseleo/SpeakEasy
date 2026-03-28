import 'package:flutter_test/flutter_test.dart';
import 'package:speakeasy/model/word.dart';

void main() {
  group('Word', () {
    test('creates with required fields', () {
      const word = Word(wordToGuess: 'Apple', taboos: ['Fruit', 'Red', 'Pie']);
      expect(word.wordToGuess, 'Apple');
      expect(word.taboos, ['Fruit', 'Red', 'Pie']);
    });

    test('equality works via Freezed', () {
      const w1 = Word(wordToGuess: 'Apple', taboos: ['Fruit']);
      const w2 = Word(wordToGuess: 'Apple', taboos: ['Fruit']);
      const w3 = Word(wordToGuess: 'Banana', taboos: ['Fruit']);

      expect(w1, equals(w2));
      expect(w1, isNot(equals(w3)));
    });

    test('copyWith works', () {
      const word = Word(wordToGuess: 'Apple', taboos: ['Fruit']);
      final updated = word.copyWith(wordToGuess: 'Banana');

      expect(updated.wordToGuess, 'Banana');
      expect(updated.taboos, ['Fruit']);
    });

    test('taboos can be empty list', () {
      const word = Word(wordToGuess: 'Test', taboos: []);
      expect(word.taboos, isEmpty);
    });

    test('toString contains all fields', () {
      const word = Word(wordToGuess: 'Apple', taboos: ['Fruit']);
      final str = word.toString();
      expect(str, contains('Apple'));
      expect(str, contains('Fruit'));
    });
  });
}
