import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';

import 'package:speakeasy/router.dart';
import 'package:speakeasy/theme/app_theme.dart';

class SpeakEasyApp extends StatelessWidget {
  const SpeakEasyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'SpeakEasy',
      theme: buildAppTheme(),
      routerConfig: appRouter,
      localizationsDelegates: [
        const LocaleNamesLocalizationsDelegate(),
        ...context.localizationDelegates,
      ],
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
