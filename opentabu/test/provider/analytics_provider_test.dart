import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speakeasy/provider/analytics_provider.dart';
import 'package:speakeasy/provider/shared_preferences_provider.dart';

Future<ProviderContainer> _createContainer([
  Map<String, Object> prefs = const {},
]) async {
  SharedPreferences.setMockInitialValues(prefs);
  final sp = await SharedPreferences.getInstance();
  return ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(sp)],
  );
}

void main() {
  group('AnalyticsController', () {
    test('initializes with zeros when no stored data', () async {
      final container = await _createContainer();
      addTearDown(container.dispose);

      final analytics = container.read(analyticsControllerProvider);
      expect(analytics.matchesPlayed, 0);
      expect(analytics.correctAnswers, 0);
      expect(analytics.wrongAnswers, 0);
      expect(analytics.skipsUsed, 0);
    });

    test('initializes from stored preferences', () async {
      final container = await _createContainer({
        'started_matches': 5,
        'correct_answers': 42,
        'wrong_answers': 10,
        'skip_used': 7,
      });
      addTearDown(container.dispose);

      final analytics = container.read(analyticsControllerProvider);
      expect(analytics.matchesPlayed, 5);
      expect(analytics.correctAnswers, 42);
      expect(analytics.wrongAnswers, 10);
      expect(analytics.skipsUsed, 7);
    });

    test('addMatch increments matchesPlayed', () async {
      final container = await _createContainer();
      addTearDown(container.dispose);

      final ctrl = container.read(analyticsControllerProvider.notifier);
      await ctrl.addMatch();

      final analytics = container.read(analyticsControllerProvider);
      expect(analytics.matchesPlayed, 1);
    });

    test('addCorrectAnswer increments correctAnswers', () async {
      final container = await _createContainer();
      addTearDown(container.dispose);

      final ctrl = container.read(analyticsControllerProvider.notifier);
      await ctrl.addCorrectAnswer();
      await ctrl.addCorrectAnswer();

      final analytics = container.read(analyticsControllerProvider);
      expect(analytics.correctAnswers, 2);
    });

    test('addWrongAnswer increments wrongAnswers', () async {
      final container = await _createContainer();
      addTearDown(container.dispose);

      final ctrl = container.read(analyticsControllerProvider.notifier);
      await ctrl.addWrongAnswer();

      final analytics = container.read(analyticsControllerProvider);
      expect(analytics.wrongAnswers, 1);
    });

    test('addSkip increments skipsUsed', () async {
      final container = await _createContainer();
      addTearDown(container.dispose);

      final ctrl = container.read(analyticsControllerProvider.notifier);
      await ctrl.addSkip();
      await ctrl.addSkip();
      await ctrl.addSkip();

      final analytics = container.read(analyticsControllerProvider);
      expect(analytics.skipsUsed, 3);
    });

    test('persists data to SharedPreferences', () async {
      final container = await _createContainer();
      addTearDown(container.dispose);

      final ctrl = container.read(analyticsControllerProvider.notifier);
      await ctrl.addMatch();
      await ctrl.addCorrectAnswer();

      final sp = container.read(sharedPreferencesProvider);
      expect(sp.getInt('started_matches'), 1);
      expect(sp.getInt('correct_answers'), 1);
    });

    test('increments on top of existing values', () async {
      final container = await _createContainer({
        'started_matches': 10,
      });
      addTearDown(container.dispose);

      final ctrl = container.read(analyticsControllerProvider.notifier);
      await ctrl.addMatch();

      final analytics = container.read(analyticsControllerProvider);
      expect(analytics.matchesPlayed, 11);
    });
  });

  group('Analytics model', () {
    test('equality works', () {
      const a = Analytics(matchesPlayed: 1, correctAnswers: 2);
      const b = Analytics(matchesPlayed: 1, correctAnswers: 2);
      const c = Analytics(matchesPlayed: 3);

      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('copyWith works', () {
      const analytics = Analytics(matchesPlayed: 5);
      final updated = analytics.copyWith(correctAnswers: 10);

      expect(updated.matchesPlayed, 5);
      expect(updated.correctAnswers, 10);
    });
  });
}
