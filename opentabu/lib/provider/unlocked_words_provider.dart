import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'shared_preferences_provider.dart';

part 'unlocked_words_provider.g.dart';

@Riverpod(keepAlive: true)
int unlockedWordsCount(UnlockedWordsCountRef ref) {
  final sp = ref.watch(sharedPreferencesProvider);

  var limit = 200;
  if (sp.getBool('1000words') ?? false) {
    limit += 1000;
  } else {
    if (sp.getBool('100words') ?? false) limit += 100;
    if (sp.getBool('500words') ?? false) limit += 500;
  }

  return limit;
}
