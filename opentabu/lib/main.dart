import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speakeasy/app.dart';
import 'package:speakeasy/provider/device_provider.dart';
import 'package:speakeasy/provider/locale_provider.dart';
import 'package:speakeasy/provider/shared_preferences_provider.dart';
import 'package:speakeasy/provider/sound_provider.dart';
import 'package:speakeasy/provider/words_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final sp = await SharedPreferences.getInstance();

  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(sp),
    ],
  );

  // Initialize services in parallel
  await Future.wait([
    container.read(soundServiceProvider.notifier).initialize(),
    container.read(deviceInfoProvider.notifier).initialize(),
  ]);

  // Preload words
  await container.read(wordsControllerProvider.future);

  final startLocale = container.read(savedLocaleProvider);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: EasyLocalization(
        startLocale: startLocale,
        supportedLocales: supportedLocales,
        path: 'assets/lang',
        fallbackLocale: supportedLocales.first,
        child: const SpeakEasyApp(),
      ),
    ),
  );
}
