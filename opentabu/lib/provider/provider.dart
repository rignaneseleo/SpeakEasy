import 'package:opentabu/model/word.dart';

abstract class WordProvider {
  Future<List<Word>> readData();
}
