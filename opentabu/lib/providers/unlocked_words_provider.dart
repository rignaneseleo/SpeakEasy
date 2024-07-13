import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'shared_pref_provider.dart';

part 'unlocked_words_provider.g.dart';

@Riverpod(keepAlive: true) //Enable cache
int unlockedWordsCount(UnlockedWordsCountRef ref) {
  final sp = ref.watch(sharedPreferencesProvider);

  var wordsLimit = 200;
  if (sp.getBool("1000words") ?? false) {
    wordsLimit = 1000;
  } else {
    if (sp.getBool("100words") ?? false) wordsLimit += 100;
    if (sp.getBool("500words") ?? false) wordsLimit += 500;
  }

  return wordsLimit;
}
