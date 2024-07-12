import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:speakeasy/api/data/csv_data_reader.dart';
import 'package:speakeasy/api/data/data_reader.dart';
import 'package:speakeasy/model/word.dart';

part 'words_controller.g.dart';

@Riverpod(keepAlive: true)
class WordsController extends _$WordsController {
  @override
  FutureOr<List<Word>> build(String langCode) async {
    final DataReader dataReader = CSVDataReader();
    return dataReader.loadWords(langCode);
  }
}
