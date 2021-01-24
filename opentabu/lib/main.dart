/*
* OpenTabu is an Open Source game developed by Leonardo Rignanese <dev.rignanese@gmail.com>
* GNU Affero General Public License v3.0: https://choosealicense.com/licenses/agpl-3.0/
* GITHUB: https://github.com/rignaneseleo/OpenTabu
* */
import 'dart:async';

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
import 'package:soundpool/soundpool.dart';
import 'package:vibration/vibration.dart';

import 'persistence/csv_data_reader.dart';

List<Word> words;
bool hasVibration = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      theme: mainTheme,
      home: new SplashScreen(),
    ),
  );

  words = await CSVDataReader.readData();
  await loadSounds();
  hasVibration = await Vibration.hasVibrator();

  runApp(
    ProviderScope(
      child: GetMaterialApp(
        title: 'OpenTabu',
        home: new HomePage(),
        theme: mainTheme,
        routes: {
          "/home": (_) => new HomePage(),
        },
      ),
    ),
  );
}
