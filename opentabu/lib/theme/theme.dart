import 'package:flutter/material.dart';

//Colors
const Color bgWhite = Colors.white;
const Color txtWhite = Colors.white;
const Color txtBlack = Colors.black;
const Color txtGrey = const Color(0xFFBFBFBF);
const Color materialPurple = Colors.deepPurple;
const Color darkPurple = const Color(0xFF2E1D5F);
const Color midPurple = const Color(0xFF482c96);
const Color lightPurple = const Color(0xFF5A37BC);
const Color myRed = const Color(0xFFe74c3c);
const Color myGreen = const Color(0xFF27ae60);
const Color myYellow = const Color(0xFFF1EAA9);

ThemeData mainTheme = ThemeData(
  pageTransitionsTheme: PageTransitionsTheme(builders: {
    TargetPlatform.android: CupertinoPageTransitionsBuilder(),
    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
  }),
  //primarySwatch: materialPurple,
  textTheme: TextTheme(
    displayLarge: TextStyle(
      color: txtWhite,
      fontSize: 90,
      height: 0.9,
    ),
    displayMedium: TextStyle(
      color: txtWhite,
      fontSize: 48,
    ),
    displaySmall: TextStyle(
      fontSize: 35,
    ),
    headlineMedium: TextStyle(
      color: txtWhite,
      fontSize: 25,
    ),
    headlineSmall: TextStyle(
      color: txtWhite,
      fontSize: 20,
    ),
    titleLarge: TextStyle(
      color: txtWhite,
      fontSize: 13,
    ),
  ),
  primaryColor: darkPurple,
  fontFamily: 'SFPro',
);
