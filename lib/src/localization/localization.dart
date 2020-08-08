import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Localization {
  final Locale locale;

  Localization(this.locale);

  static Localization of(BuildContext context) {
    return Localizations.of<Localization>(context, Localization);
  }

  Map<String, String> _localizedValues;

  Future load() async {
    String jsonStringValues =
        await rootBundle.loadString('i18n/${locale.languageCode}.json');

    Map<String, dynamic> mapeedJson = json.decode(jsonStringValues);

    _localizedValues =
        mapeedJson.map((key, value) => MapEntry(key, value.toString()));
  }

  String getTranslatedValue(String key) {
    return _localizedValues[key];
  }

  static const LocalizationsDelegate<Localization> delegate = _LocalizationDelegate();
}

class _LocalizationDelegate extends LocalizationsDelegate<Localization>{
  const _LocalizationDelegate();
  @override
  bool isSupported(Locale locale) {
      return ['en', 'es'].contains(locale.languageCode);
    }
  
    @override
    Future<Localization> load(Locale locale) async  {
      Localization localization = new Localization(locale);
      await localization.load();
      return localization;
    }
  
    @override
    bool shouldReload(LocalizationsDelegate old) => false;

}