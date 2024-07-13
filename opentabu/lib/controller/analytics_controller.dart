import 'package:shared_preferences/shared_preferences.dart';
import 'package:speakeasy/main.dart';

class AnalyticsController {
  static const String kStartedMatchesKey = "started_matches";

  static int getStartedMatches() => _getVal(kStartedMatchesKey);

  static Future addNewMatch() async => await _increaseSP(kStartedMatchesKey);

  //---------

  static const String kSkipUsedKey = "skip_used";

  static int getSkipUsed() => _getVal(kSkipUsedKey);

  static Future addNewSkip() async => await _increaseSP(kSkipUsedKey);

  //---------

  static const String kCorrectAnswersKey = "correct_answers";

  static int getCorrectAnswers() => _getVal(kCorrectAnswersKey);

  static Future addCorrectAnswer() async =>
      await _increaseSP(kCorrectAnswersKey);

  //---------

  static const String kWrongAnswersKey = "wrong_answers";

  static int getWrongAnswers() => _getVal(kWrongAnswersKey);

  static Future addWrongAnswer() async => await _increaseSP(kWrongAnswersKey);

  //---------

  static int _getVal(String key) {
   /* final sp=await SharedPreferences.getInstance();

    return sp.getInt(key) ?? 0;*/
    return 0;
  }

  static Future _increaseSP(String key) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setInt(key, (sp.getInt(key) ?? 0) + 1);
  }

  static Future _decreaseSP(String key) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setInt(key, (sp.getInt(key) ?? 0) + 1);
  }
}
