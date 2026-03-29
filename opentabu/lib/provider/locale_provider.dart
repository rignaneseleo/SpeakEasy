import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:speakeasy/provider/shared_preferences_provider.dart';

part 'locale_provider.g.dart';

const supportedLocales = [
  Locale('en', 'US'),
  Locale('it', 'IT'),
];

@Riverpod(keepAlive: true)
Locale savedLocale(SavedLocaleRef ref) {
  final sp = ref.watch(sharedPreferencesProvider);
  final langCode = sp.getString('saved_locale_langcode');
  if (langCode != null) {
    return Locale.fromSubtags(languageCode: langCode);
  }
  return PlatformDispatcher.instance.locale;
}
