import 'package:freezed_annotation/freezed_annotation.dart';

part 'word.freezed.dart';

@freezed
class Word with _$Word {
  const factory Word({
    required String wordToGuess,
    required List<String> taboos,
  }) = _Word;
}
