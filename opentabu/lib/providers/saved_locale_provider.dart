import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'shared_pref_provider.dart';

part 'saved_locale_provider.g.dart';

@Riverpod(keepAlive: true) //Enable cache
Locale savedLocale(SavedLocaleRef ref) {
  final sp = ref.watch(sharedPreferencesProvider);
  final langCode = sp.getString("saved_locale_langcode");
  if (langCode != null) {
    return Locale.fromSubtags(languageCode: langCode);
  }

  return PlatformDispatcher.instance.locale;
}
