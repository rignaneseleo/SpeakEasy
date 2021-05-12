import 'package:opentabu/main.dart';

class AnalyticsController {
  static const String kStartedMatchesKey = "started_matches";

  static Future<int> getStartedMatches() async =>
      await _getVal(kStartedMatchesKey);

  static Future addNewMatch() async => await _increaseSP(kStartedMatchesKey);

  //---------

  static const String kSkipUsedKey = "skip_used";

  static Future<int> getSkipUsed() async => await _getVal(kSkipUsedKey);

  static Future addNewSkip() async => await _increaseSP(kSkipUsedKey);

  //---------

  static const String kCorrectAnswersKey = "correct_answers";

  static Future<int> getCorrectAnswers() async =>
      await _getVal(kCorrectAnswersKey);

  static Future addCorrectAnswer() async =>
      await _increaseSP(kCorrectAnswersKey);

  //---------

  static const String kWrongAnswersKey = "wrong_answers";

  static Future<int> getWrongAnswers() async => await _getVal(kWrongAnswersKey);

  static Future addWrongAnswer() async => await _increaseSP(kWrongAnswersKey);

  //---------

  static Future<int> _getVal(String key) async {
    return prefs.getInt(key) ?? 0;
  }

  static Future _increaseSP(String key) async {
    await prefs.setInt(key, (prefs.getInt(key) ?? 0) + 1);
  }

  static Future _decreaseSP(String key) async {
    await prefs.setInt(key, (prefs.getInt(key) ?? 0) + 1);
  }
}
