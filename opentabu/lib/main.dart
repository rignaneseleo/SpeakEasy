/*
* OpenTabu is an Open Source game developed by Leonardo Rignanese <dev.rignanese@gmail.com>
* GNU Affero General Public License v3.0: https://choosealicense.com/licenses/agpl-3.0/
* GITHUB: https://github.com/rignaneseleo/OpenTabu
* */
import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speakeasy/controller/words_controller.dart';
import 'package:speakeasy/providers/saved_locale_provider.dart';
import 'package:speakeasy/providers/shared_pref_provider.dart';
import 'package:speakeasy/theme/theme.dart';
import 'package:speakeasy/view/home_page.dart';
import 'package:speakeasy/view/splash_screen.dart';
import 'package:vibration/vibration.dart';

import 'api/sound/sound_loader.dart';

bool hasVibration = false;
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
  Locale('en', "US"), //this is the default language
  Locale('it', "IT"),
];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // Hide the nav bar
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // Set the navigation bar color
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black, // Set the navigation bar color
    systemNavigationBarIconBrightness:
        Brightness.light, // Set the icon brightness
  ));

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

  await loadSounds();
  if (kIsWeb)
    hasVibration = false;
  else {
    hasVibration = await Vibration.hasVibrator() ?? false;
  }

  packageInfo = await PackageInfo.fromPlatform();

  final ref = ProviderContainer(
    overrides: [
      sharedPreferencesProvider
          .overrideWithValue(await SharedPreferences.getInstance()),
    ],
  );

  //preload the words
  await ref.read(wordsControllerProvider.future);

  runApp(
    UncontrolledProviderScope(
      container: ref,
      child: EasyLocalization(
        startLocale: ref.read(savedLocaleProvider),
        supportedLocales: supportedLanguages,
        path: 'assets/lang',
        saveLocale: true,
        fallbackLocale: supportedLanguages.first,
        child: const SpeakEasyApp(),
      ),
    ),
  );
}

/*void _printOrderedWords(List<Word> words) {
  words.sort((a, b) => a.nTabu.compareTo(b.nTabu));

  print("---------------------");
  for (var w in words.reversed) {
    print("${w.wordToGuess},${w.taboos}");
  }
  print("---------------------");
}*/

class SpeakEasyApp extends StatelessWidget {
  const SpeakEasyApp({super.key});

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
