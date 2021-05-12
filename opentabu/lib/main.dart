/*
* OpenTabu is an Open Source game developed by Leonardo Rignanese <dev.rignanese@gmail.com>
* GNU Affero General Public License v3.0: https://choosealicense.com/licenses/agpl-3.0/
* GITHUB: https://github.com/rignaneseleo/OpenTabu
* */
import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:opentabu/model/settings.dart';
import 'package:opentabu/model/word.dart';
import 'package:opentabu/persistence/sound_loader.dart';
import 'package:opentabu/theme/theme.dart';
import 'package:opentabu/view/game_page.dart';
import 'package:opentabu/view/home_page.dart';
import 'package:opentabu/view/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soundpool/soundpool.dart';
import 'package:vibration/vibration.dart';

import 'persistence/csv_data_reader.dart';

List<Word> words;
bool hasVibration = false;
SharedPreferences prefs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // Turn off landscape mode
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  runApp(
    MaterialApp(
      theme: mainTheme,
      home: new SplashScreen(),
    ),
  );

  words = await CSVDataReader.readData();
  await loadSounds();
  hasVibration = await Vibration.hasVibrator();
  prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      child: EasyLocalization(
          supportedLocales: [Locale('en'), Locale('it')],
          path: 'assets/lang',
          fallbackLocale: Locale('en', 'US'),
          child: OpenTabuApp()),
    ),
  );
}

class OpenTabuApp extends StatelessWidget {
  const OpenTabuApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'OpenTabu',
      home: new HomePage(),
      theme: mainTheme,
      routes: {
        "/home": (_) => new HomePage(),
      },
      //Easy_localization:
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
