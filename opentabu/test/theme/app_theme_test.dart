import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speakeasy/theme/app_theme.dart';

void main() {
  group('AppColors', () {
    test('darkPurple has correct value', () {
      expect(AppColors.darkPurple, const Color(0xFF2E1D5F));
    });

    test('midPurple has correct value', () {
      expect(AppColors.midPurple, const Color(0xFF482c96));
    });

    test('lightPurple has correct value', () {
      expect(AppColors.lightPurple, const Color(0xFF5A37BC));
    });

    test('myRed has correct value', () {
      expect(AppColors.myRed, const Color(0xFFe74c3c));
    });

    test('myGreen has correct value', () {
      expect(AppColors.myGreen, const Color(0xFF27ae60));
    });

    test('myYellow has correct value', () {
      expect(AppColors.myYellow, const Color(0xFFF1EAA9));
    });

    test('txtGrey has correct value', () {
      expect(AppColors.txtGrey, const Color(0xFFBFBFBF));
    });
  });

  group('buildAppTheme', () {
    late ThemeData theme;

    setUp(() {
      theme = buildAppTheme();
    });

    test('uses Material 3', () {
      expect(theme.useMaterial3, isTrue);
    });

    test('has darkPurple as primary color', () {
      expect(theme.primaryColor, AppColors.darkPurple);
    });

    test('uses SFPro font in text theme', () {
      // fontFamily is applied via ThemeData constructor, reflected in textTheme
      expect(theme.textTheme.bodyMedium?.fontFamily, 'SFPro');
    });

    test('has cupertino page transitions for both platforms', () {
      final builders = theme.pageTransitionsTheme.builders;
      expect(builders[TargetPlatform.android],
          isA<CupertinoPageTransitionsBuilder>());
      expect(builders[TargetPlatform.iOS],
          isA<CupertinoPageTransitionsBuilder>());
    });

    group('text theme', () {
      test('displayLarge is 90px white', () {
        expect(theme.textTheme.displayLarge?.fontSize, 90);
        expect(theme.textTheme.displayLarge?.color, AppColors.txtWhite);
        expect(theme.textTheme.displayLarge?.height, 0.9);
      });

      test('displayMedium is 48px white', () {
        expect(theme.textTheme.displayMedium?.fontSize, 48);
        expect(theme.textTheme.displayMedium?.color, AppColors.txtWhite);
      });

      test('displaySmall is 35px', () {
        expect(theme.textTheme.displaySmall?.fontSize, 35);
      });

      test('headlineMedium is 25px white', () {
        expect(theme.textTheme.headlineMedium?.fontSize, 25);
        expect(theme.textTheme.headlineMedium?.color, AppColors.txtWhite);
      });

      test('headlineSmall is 20px white', () {
        expect(theme.textTheme.headlineSmall?.fontSize, 20);
        expect(theme.textTheme.headlineSmall?.color, AppColors.txtWhite);
      });

      test('titleLarge is 13px white', () {
        expect(theme.textTheme.titleLarge?.fontSize, 13);
        expect(theme.textTheme.titleLarge?.color, AppColors.txtWhite);
      });
    });
  });
}
