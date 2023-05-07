/*
* OpenTabu is an Open Source game developed by Leonardo Rignanese <dev.rignanese@gmail.com>
* GNU Affero General Public License v3.0: https://choosealicense.com/licenses/agpl-3.0/
* GITHUB: https://github.com/rignaneseleo/OpenTabu
* */
import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:speakeasy/model/word.dart';
import 'package:speakeasy/persistence/sound_loader.dart';
import 'package:speakeasy/theme/theme.dart';
import 'package:speakeasy/view/home_page.dart';
import 'package:speakeasy/view/splash_screen.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

import 'persistence/csv_data_reader.dart';

List<Word> words = [];
bool hasVibration = false;
late SharedPreferences prefs;
PackageInfo? packageInfo;

bool smallScreen = false;

/*
altre modalità di gioco:
INDOVINO SINGOLO
Nel corso di quest’unico turno di gioco, il suggeritore deve scegliere un solo compagno di
squadra, che dovrà provare a indovinare in solitudine quante più parole misteriose possibile.
TEMPO DOPPIO
Quando è finito il tempo concesso dalla prima clessidra, voltatela di nuovo e continuate
a giocare fino a nuovo esaurimento del tempo! Per fare sì che ogni sfida sia equilibrata,
lo stesso vantaggio spetterà anche all’altra squadra nel turno di gioco immediatamente
successivo.
STATUA DI SALE
Il suggeritore deve stare seduto perfettamente immobile mentre suggerisce le parole da
indovinare ai compagni: a girare le carte, di volta in volta, ci penseranno i membri della
squadra avversaria.
DENTRO TUTTI!
Se esce questo simbolo, entrambe le squadre possono provare a indovinare le parole
misteriose che vengono suggerite.*/

List<Locale> supportedLanguages = const [
  Locale('en', "US"),
  Locale('it', "IT"),
];

late SharedPreferences sp;

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
      debugShowCheckedModeBanner: false,
      theme: mainTheme,
      home: new SplashScreen(),
    ),
  );

  sp = await SharedPreferences.getInstance();

  var defaultLocale = sp.getString("saved_locale") ?? Platform.localeName;
  words = await CSVDataReader.readData(
      'assets/words/${defaultLocale.substring(0, 2)}/min.csv');
  words.shuffle();
  //_printWords(words);

  await loadSounds();
  hasVibration = await Vibration.hasVibrator() ?? false;
  prefs = await SharedPreferences.getInstance();
  packageInfo = await PackageInfo.fromPlatform();

  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: supportedLanguages,
        path: 'assets/lang',
        saveLocale: true,
        fallbackLocale: supportedLanguages.first,
        child: SpeakEasyApp(),
      ),
    ),
  );
}

void _printOrderedWords(List<Word> words) {
  words.sort((a, b) => a.nTabu.compareTo(b.nTabu));

  print("---------------------");
  for (var w in words.reversed) {
    print("${w.wordToGuess},${w.taboos}");
  }
  print("---------------------");
}

class SpeakEasyApp extends StatelessWidget {
  const SpeakEasyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SpeakEasy',
      home: new HomePage(),
      theme: mainTheme,
      routes: {
        "/home": (_) => new HomePage(),
      },
      //Easy_localization:
      localizationsDelegates: [
        LocaleNamesLocalizationsDelegate(),
        ...context.localizationDelegates
      ],
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
