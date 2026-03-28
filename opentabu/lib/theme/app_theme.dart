import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color bgWhite = Colors.white;
  static const Color txtWhite = Colors.white;
  static const Color txtBlack = Colors.black;
  static const Color txtGrey = Color(0xFFBFBFBF);
  static const Color materialPurple = Colors.deepPurple;
  static const Color darkPurple = Color(0xFF2E1D5F);
  static const Color midPurple = Color(0xFF482c96);
  static const Color lightPurple = Color(0xFF5A37BC);
  static const Color myRed = Color(0xFFe74c3c);
  static const Color myGreen = Color(0xFF27ae60);
  static const Color myYellow = Color(0xFFF1EAA9);
}

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    colorSchemeSeed: AppColors.darkPurple,
    brightness: Brightness.light,
    fontFamily: 'SFPro',
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    }),
    primaryColor: AppColors.darkPurple,
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: AppColors.txtWhite,
        fontSize: 90,
        height: 0.9,
      ),
      displayMedium: TextStyle(
        color: AppColors.txtWhite,
        fontSize: 48,
      ),
      displaySmall: TextStyle(
        fontSize: 35,
      ),
      headlineMedium: TextStyle(
        color: AppColors.txtWhite,
        fontSize: 25,
      ),
      headlineSmall: TextStyle(
        color: AppColors.txtWhite,
        fontSize: 20,
      ),
      titleLarge: TextStyle(
        color: AppColors.txtWhite,
        fontSize: 13,
      ),
    ),
  );
}
