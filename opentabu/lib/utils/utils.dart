import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

String capitalize(String s) {
  if (s.length == 0) return s;
  return s[0].toUpperCase() + s.substring(1);
}

Future launchURL(String url) async {
  try {
    await launchUrl(Uri.parse(url));
  } catch (e) {
    print("ERROR launchURL: $e");
  }
}

Locale? getSelectedLocale({BuildContext? context}) {
  var customLocaleStr = prefs.getString("saved_locale");
  if (customLocaleStr != null) {
    var customLocaleRawList = customLocaleStr.split("_");
    return Locale.fromSubtags(
        languageCode: customLocaleRawList[0],
        countryCode: customLocaleRawList[1]);
  }

  if (context == null) return null;
  return Localizations.localeOf(context);
}
