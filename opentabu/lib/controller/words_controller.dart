import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:speakeasy/api/data/data_reader_provider.dart';
import 'package:speakeasy/model/word.dart';
import 'package:speakeasy/providers/saved_locale_provider.dart';
import 'package:speakeasy/providers/unlocked_words_provider.dart';

part 'words_controller.g.dart';

@Riverpod(keepAlive: true)
class WordsController extends _$WordsController {
  @override
  FutureOr<List<Word>> build() async {
    //this reads the saved locale
    final lang = ref.watch(savedLocaleProvider);

    //this reads the correspondent file
    final dataReader =
        await ref.watch(dataReaderProvider(lang.languageCode).future);

    //this reads the unlocked words count
    final unlockedWords = ref.watch(unlockedWordsCountProvider);

    //this loads the correct amount of words
    return dataReader.loadWords(unlockedWords);
  }
}
