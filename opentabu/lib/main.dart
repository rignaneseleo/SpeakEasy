/*
* OpenTabu is an Open Source game developed by Leonardo Rignanese <dev.rignanese@gmail.com>
* GNU Affero General Public License v3.0: https://choosealicense.com/licenses/agpl-3.0/
* GITHUB: https://github.com/rignaneseleo/OpenTabu
* */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:opentabu/model/settings.dart';
import 'package:opentabu/model/word.dart';
import 'package:opentabu/theme/theme.dart';
import 'package:opentabu/view/gamePage.dart';
import 'package:opentabu/view/homePage.dart';
import 'package:opentabu/view/splash_screen.dart';

import 'persistence/csvDataReader.dart';

List<Word> words;

Future<void> main() async {
  runApp(
    MaterialApp(
      title: 'Loading Tabu',
      theme: myTheme,
      home: new SplashScreen(),
    ),
  );

  words = await CSVDataReader.readData();

  runApp(
    ProviderScope(
      child: MaterialApp(
        title: 'Tabu',
        home: new HomePage(),
        theme: myTheme,
        routes: {
          "/home": (_) => new HomePage(),
        },
      ),
    ),
  );
}
