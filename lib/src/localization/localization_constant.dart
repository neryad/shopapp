import 'dart:io';

import 'package:PocketList/src/Shared_Prefs/Prefrecias_user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:PocketList/src/localization/localization.dart';

String? getTranlated(BuildContext context, String key) {
  return Localization.of(context)?.getTranslatedValue(key);
}

final prefsU = new PreferenciasUsuario();
// Langue code

const String ENGLISH = 'en';

const String SPANISH = 'es';
final String defaultLocale = Platform.localeName.substring(0, 2);

const String LANGUAGE_CODE = 'languageCode';

Future<Locale> setLocal(String languageCode) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(LANGUAGE_CODE, languageCode);
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  Locale _temp;
  // if (languageCode == 'en') {
  //   _temp = Locale(languageCode, 'US');
  // } else {
  //   _temp = Locale(languageCode, 'US');
  // }

  switch (languageCode) {
    case ENGLISH:
      _temp = Locale(languageCode, 'US');
      break;

    case SPANISH:
      _temp = Locale(languageCode, 'US');
      break;

    default:
      _temp = Locale(defaultLocale, 'US');
  }

  return _temp;
}

Future<Locale> getLocale() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String languageCode = _prefs.getString(LANGUAGE_CODE) ?? defaultLocale;
  prefsU.lnge = languageCode;
  return _locale(languageCode);
}
