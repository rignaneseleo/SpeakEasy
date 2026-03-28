import 'package:flutter_test/flutter_test.dart';
import 'package:speakeasy/model/game_settings.dart';

void main() {
  group('GameSettings', () {
    test('has correct defaults', () {
      const settings = GameSettings();
      expect(settings.nPlayers, 2);
      expect(settings.turnDurationInSeconds, 90);
      expect(settings.nSkip, 3);
      expect(settings.nTurns, 10);
      expect(settings.nTaboos, 5);
    });

    test('copyWith overrides single field', () {
      const settings = GameSettings();
      final updated = settings.copyWith(nPlayers: 4);

      expect(updated.nPlayers, 4);
      expect(updated.turnDurationInSeconds, 90);
      expect(updated.nSkip, 3);
      expect(updated.nTurns, 10);
      expect(updated.nTaboos, 5);
    });

    test('copyWith overrides all fields', () {
      final settings = const GameSettings().copyWith(
        nPlayers: 5,
        turnDurationInSeconds: 60,
        nSkip: 2,
        nTurns: 8,
        nTaboos: 3,
      );

      expect(settings.nPlayers, 5);
      expect(settings.turnDurationInSeconds, 60);
      expect(settings.nSkip, 2);
      expect(settings.nTurns, 8);
      expect(settings.nTaboos, 3);
    });

    test('equality works', () {
      const a = GameSettings(nPlayers: 3);
      const b = GameSettings(nPlayers: 3);
      const c = GameSettings(nPlayers: 4);

      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });
  });
}
