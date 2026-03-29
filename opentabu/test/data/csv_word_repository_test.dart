import 'package:flutter_test/flutter_test.dart';
import 'package:speakeasy/data/csv_word_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CsvWordRepository', () {
    late CsvWordRepository repo;

    setUp(() {
      repo = CsvWordRepository();
    });

    group('loadFile', () {
      test('loads English words', () async {
        await repo.loadFile('en');
        final words = repo.loadWords(9999);
        expect(words, isNotEmpty);
      });

      test('loads Italian words', () async {
        await repo.loadFile('it');
        final words = repo.loadWords(9999);
        expect(words, isNotEmpty);
      });

      test('falls back to English for unknown language', () async {
        await repo.loadFile('xx');
        final words = repo.loadWords(9999);
        expect(words, isNotEmpty);
      });
    });

    group('loadWords', () {
      setUp(() async {
        await repo.loadFile('en');
      });

      test('returns shuffled words', () {
        final words1 = repo.loadWords(100);
        final words2 = repo.loadWords(100);

        // Same set of words, just reordered
        expect(words1.length, words2.length);
        // With 100 words, extremely unlikely to be in same order
        final sameOrder = List.generate(
          words1.length,
          (i) => words1[i].wordToGuess == words2[i].wordToGuess,
        ).every((e) => e);
        // This could technically fail with probability ~1/100!, but it won't
        if (words1.length > 1) {
          expect(sameOrder, isFalse, reason: 'Words should be shuffled');
        }
      });

      test('respects limit', () {
        final words = repo.loadWords(5);
        expect(words.length, 5);
      });

      test('returns all words when limit exceeds total', () {
        final allWords = repo.loadWords(999999);
        final limited = repo.loadWords(allWords.length + 100);
        expect(limited.length, allWords.length);
      });
    });

    group('word structure', () {
      setUp(() async {
        await repo.loadFile('en');
      });

      test('words have non-empty wordToGuess', () {
        final words = repo.loadWords(9999);
        for (final word in words) {
          expect(word.wordToGuess, isNotEmpty);
        }
      });

      test('words have non-empty taboos', () {
        final words = repo.loadWords(9999);
        for (final word in words) {
          expect(word.taboos, isNotEmpty,
              reason: '${word.wordToGuess} has no taboos',);
        }
      });

      test('wordToGuess is capitalized', () {
        final words = repo.loadWords(9999);
        for (final word in words) {
          expect(word.wordToGuess[0], word.wordToGuess[0].toUpperCase(),
              reason: '${word.wordToGuess} is not capitalized',);
        }
      });

      test('taboos are capitalized', () {
        final words = repo.loadWords(9999);
        for (final word in words) {
          for (final taboo in word.taboos) {
            expect(taboo[0], taboo[0].toUpperCase(),
                reason: '$taboo in ${word.wordToGuess} is not capitalized',);
          }
        }
      });

      test('no duplicate wordToGuess entries', () {
        final words = repo.loadWords(9999);
        final allWords = words.map((w) => w.wordToGuess.toLowerCase()).toList();
        final uniqueWords = allWords.toSet();
        expect(allWords.length, uniqueWords.length,
            reason: 'Found duplicate words',);
      });
    });
  });
}
