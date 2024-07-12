import 'dart:ui';

import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

String capitalize(String s) {
  if (s.length == 0) return s;
  return s[0].toUpperCase() + s.substring(1);
}

bool areAllElementsSame(List<int> list) {
  if (list.isEmpty) return true; // An empty list is considered to have all elements the same
  int firstElement = list.first;
  return list.every((element) => element == firstElement);
}

Future launchURL(String url) async {
  try {
    await launchUrl(Uri.parse(url));
  } catch (e) {
    print("ERROR launchURL: $e");
  }
}

Locale? getSelectedLocale() {
  var langCode = sp.getString("saved_locale_langcode");
  if (langCode != null) {
    return Locale.fromSubtags(languageCode: langCode);
  }

  return PlatformDispatcher.instance.locale;
}
