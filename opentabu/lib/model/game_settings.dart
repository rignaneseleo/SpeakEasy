import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_settings.freezed.dart';

@freezed
class GameSettings with _$GameSettings {
  const factory GameSettings({
    @Default(2) int nPlayers,
    @Default(90) int turnDurationInSeconds,
    @Default(3) int nSkip,
    @Default(10) int nTurns,
    @Default(5) int nTaboos,
  }) = _GameSettings;
}
