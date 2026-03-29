import 'package:flutter_test/flutter_test.dart';
import 'package:speakeasy/util/extensions.dart';

void main() {
  group('String.capitalized', () {
    test('capitalizes first letter', () {
      expect('hello'.capitalized, 'Hello');
    });

    test('keeps already capitalized string', () {
      expect('Hello'.capitalized, 'Hello');
    });

    test('handles single character', () {
      expect('a'.capitalized, 'A');
    });

    test('handles empty string', () {
      expect(''.capitalized, '');
    });

    test('preserves rest of string', () {
      expect('hELLO wORLD'.capitalized, 'HELLO wORLD');
    });

    test('handles unicode', () {
      expect('über'.capitalized, 'Über');
    });

    test('handles numbers at start', () {
      expect('123abc'.capitalized, '123abc');
    });
  });
}
