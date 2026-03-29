import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:speakeasy/data/csv_word_repository.dart';
import 'package:speakeasy/model/word.dart';
import 'package:speakeasy/provider/locale_provider.dart';
import 'package:speakeasy/provider/unlocked_words_provider.dart';

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
