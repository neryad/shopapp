import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:PocketList/src/localization/localization.dart';

String getTranlated(BuildContext context, String key) {
  return Localization.of(context).getTranslatedValue(key);
}

// Langue code

const String ENGLISH = 'en';
const String SPANISH = 'es';

const String LANGUAGE_CODE = 'languageCode';

Future<Locale> setLocal(String languageCode) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(LANGUAGE_CODE, languageCode);
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  Locale _temp;
  switch (languageCode) {
    case ENGLISH:
      _temp = Locale(languageCode, 'US');
      break;

    case SPANISH:
      _temp = Locale(languageCode, 'US');
      break;

    default:
      _temp = Locale(ENGLISH, 'US');
  }

  return _temp;
}

Future<Locale> getLocale() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String languageCode = _prefs.getString(LANGUAGE_CODE) ?? ENGLISH;
  return _locale(languageCode);
}
