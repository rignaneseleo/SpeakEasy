import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/csv_word_repository.dart';
import '../model/word.dart';
import 'locale_provider.dart';
import 'unlocked_words_provider.dart';

part 'words_provider.g.dart';

@Riverpod(keepAlive: true)
Future<CsvWordRepository> wordRepository(
  WordRepositoryRef ref,
  String langCode,
) async {
  final repo = CsvWordRepository();
  await repo.loadFile(langCode);
  return repo;
}

@Riverpod(keepAlive: true)
class WordsController extends _$WordsController {
  @override
  FutureOr<List<Word>> build() async {
    final lang = ref.watch(savedLocaleProvider);
    final repo =
        await ref.watch(wordRepositoryProvider(lang.languageCode).future);
    final limit = ref.watch(unlockedWordsCountProvider);
    return repo.loadWords(limit);
  }
}
