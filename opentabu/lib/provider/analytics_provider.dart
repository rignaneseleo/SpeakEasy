import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'shared_preferences_provider.dart';

part 'analytics_provider.freezed.dart';
part 'analytics_provider.g.dart';

@freezed
class Analytics with _$Analytics {
  const factory Analytics({
    @Default(0) int matchesPlayed,
    @Default(0) int correctAnswers,
    @Default(0) int wrongAnswers,
    @Default(0) int skipsUsed,
  }) = _Analytics;
}

@Riverpod(keepAlive: true)
class AnalyticsController extends _$AnalyticsController {
  static const _kMatches = 'started_matches';
  static const _kCorrect = 'correct_answers';
  static const _kWrong = 'wrong_answers';
  static const _kSkips = 'skip_used';

  @override
  Analytics build() {
    final sp = ref.watch(sharedPreferencesProvider);
    return Analytics(
      matchesPlayed: sp.getInt(_kMatches) ?? 0,
      correctAnswers: sp.getInt(_kCorrect) ?? 0,
      wrongAnswers: sp.getInt(_kWrong) ?? 0,
      skipsUsed: sp.getInt(_kSkips) ?? 0,
    );
  }

  Future<void> addMatch() => _increment(_kMatches);
  Future<void> addCorrectAnswer() => _increment(_kCorrect);
  Future<void> addWrongAnswer() => _increment(_kWrong);
  Future<void> addSkip() => _increment(_kSkips);

  Future<void> _increment(String key) async {
    final sp = ref.read(sharedPreferencesProvider);
    await sp.setInt(key, (sp.getInt(key) ?? 0) + 1);
    ref.invalidateSelf();
  }
}
