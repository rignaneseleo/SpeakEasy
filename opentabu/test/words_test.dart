import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speakeasy/controller/words_controller.dart';
import 'package:speakeasy/providers/shared_pref_provider.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  final languages = ['it', 'en', "es"];

  for (final lang in languages) {
    await _defineTest(
      {
        "1000words": false,
        "100words": false,
        "500words": false,
        "saved_locale_langcode": lang,
      },
      200,
      'Loading 200',
    );

    await _defineTest(
      {
        "1000words": false,
        "100words": true,
        "500words": false,
        "saved_locale_langcode": lang,
      },
      300,
      'Loading 300',
    );

    await _defineTest(
      {
        "1000words": true,
        "100words": true,
        "500words": false,
        "saved_locale_langcode": lang,
      },
      1200,
      'Loading 1200',
    );
  }
}

Future<void> _defineTest(
  Map<String, Object> preferences,
  int expectedWords,
  String testName,
) async {
  SharedPreferences.setMockInitialValues(preferences);
  final container = ProviderContainer(overrides: [
    sharedPreferencesProvider
        .overrideWithValue(await SharedPreferences.getInstance()),
  ]);
  //container.invalidate(unlockedWordsCountProvider);

  var lang = preferences["saved_locale_langcode"];

  test('$testName $lang words', () async {
    final words = await container.read(wordsControllerProvider.future);
    expect(words.length, expectedWords,
        reason: 'Not $expectedWords $lang words loaded: ${words.length}');
    print('\n-----\n');
  });
}
