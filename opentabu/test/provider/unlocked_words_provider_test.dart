import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speakeasy/provider/shared_preferences_provider.dart';
import 'package:speakeasy/provider/unlocked_words_provider.dart';

Future<ProviderContainer> _createContainer(Map<String, Object> prefs) async {
  SharedPreferences.setMockInitialValues(prefs);
  final sp = await SharedPreferences.getInstance();
  return ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(sp)],
  );
}

void main() {
  group('unlockedWordsCount', () {
    test('returns 200 with no purchases', () async {
      final container = await _createContainer({
        '1000words': false,
        '100words': false,
        '500words': false,
      });
      addTearDown(container.dispose);

      expect(container.read(unlockedWordsCountProvider), 200);
    });

    test('returns 300 with 100words purchased', () async {
      final container = await _createContainer({
        '1000words': false,
        '100words': true,
        '500words': false,
      });
      addTearDown(container.dispose);

      expect(container.read(unlockedWordsCountProvider), 300);
    });

    test('returns 700 with 500words purchased', () async {
      final container = await _createContainer({
        '1000words': false,
        '100words': false,
        '500words': true,
      });
      addTearDown(container.dispose);

      expect(container.read(unlockedWordsCountProvider), 700);
    });

    test('returns 800 with 100+500 words purchased', () async {
      final container = await _createContainer({
        '1000words': false,
        '100words': true,
        '500words': true,
      });
      addTearDown(container.dispose);

      expect(container.read(unlockedWordsCountProvider), 800);
    });

    test('returns 1200 with 1000words purchased (overrides others)', () async {
      final container = await _createContainer({
        '1000words': true,
        '100words': false,
        '500words': false,
      });
      addTearDown(container.dispose);

      expect(container.read(unlockedWordsCountProvider), 1200);
    });

    test('1000words ignores 100words and 500words', () async {
      final container = await _createContainer({
        '1000words': true,
        '100words': true,
        '500words': true,
      });
      addTearDown(container.dispose);

      // 1000words = true means 200 + 1000 = 1200, ignoring other packs
      expect(container.read(unlockedWordsCountProvider), 1200);
    });

    test('returns 200 when preferences are missing', () async {
      final container = await _createContainer({});
      addTearDown(container.dispose);

      expect(container.read(unlockedWordsCountProvider), 200);
    });
  });
}
