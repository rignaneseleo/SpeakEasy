import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speakeasy/provider/shared_preferences_provider.dart';
import 'package:speakeasy/provider/words_provider.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  final languages = ['it', 'en'];

  for (final lang in languages) {
    await _defineTest(
      prefs: {
        '1000words': false,
        '100words': false,
        '500words': false,
        'saved_locale_langcode': lang,
      },
      unlockedLimit: 200,
      lang: lang,
    );

    await _defineTest(
      prefs: {
        '1000words': false,
        '100words': true,
        '500words': false,
        'saved_locale_langcode': lang,
      },
      unlockedLimit: 300,
      lang: lang,
    );

    await _defineTest(
      prefs: {
        '1000words': true,
        '100words': true,
        '500words': false,
        'saved_locale_langcode': lang,
      },
      unlockedLimit: 1200,
      lang: lang,
    );
  }
}

Future<void> _defineTest({
  required Map<String, Object> prefs,
  required int unlockedLimit,
  required String lang,
}) async {
  SharedPreferences.setMockInitialValues(prefs);
  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider
          .overrideWithValue(await SharedPreferences.getInstance()),
    ],
  );

  test('Loads words with limit=$unlockedLimit for $lang', () async {
    final words = await container.read(wordsControllerProvider.future);
    // Words returned = min(unlockedLimit, totalAvailableWords).
    // Asset CSVs may have fewer words than the IAP limit unlocks.
    expect(words.length, lessThanOrEqualTo(unlockedLimit));
    expect(words.length, greaterThan(0));
    expect(
      words.length,
      greaterThanOrEqualTo(100),
      reason: 'Expected at least 100 $lang words, got ${words.length}',
    );
  });
}
