import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class PreferenciasUsuario {
  static final PreferenciasUsuario _instacia =
      new PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instacia;
  }

  PreferenciasUsuario._internal();

  late SharedPreferences _prefs;

  initPrefes() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  Color defaultColor = Color.fromRGBO(255, 111, 94, 1);
  int get color {
    return _prefs.getInt('color') ?? 1;
  }

  set color(int value) {
    _prefs.setInt('color', value);
  }

  // Agrega esto a tu clase PreferenciasUsuario
  int get customColorValue {
    return _prefs.getInt('customColorValue') ?? 0xFFFF6F5E;
  }

  set customColorValue(int value) {
    _prefs.setInt('customColorValue', value);
  }

  bool get darkLightTheme {
    return _prefs.getBool('darkLightTheme') ?? false;
  }

  set darkLightTheme(bool value) {
    _prefs.setBool('darkLightTheme', value);
  }

  String get nombreUsuario {
    return _prefs.getString('nombreUsuario') ?? '';
  }

  set nombreUsuario(String value) {
    _prefs.setString('nombreUsuario', value);
  }

  String get lnge {
    return _prefs.getString('lnge') ?? 'en';
  }

  set lnge(String value) {
    _prefs.setString('lnge', value);
  }

  String get ultimaPagina {
    return _prefs.getString('ultimaPagina') ?? 'home';
  }

  set ultimaPagina(String value) {
    _prefs.setString('ultimaPagina', value);
  }

  bool get onboardingSeen {
    return _prefs.getBool('onboardingSeen') ?? false;
  }

  set onboardingSeen(bool value) {
    _prefs.setBool('onboardingSeen', value);
  }

  String get tempTotal {
    return _prefs.getString('tempTotal') ?? '0.00';
  }

  set tempTotal(String value) {
    _prefs.setString('tempTotal', value);
  }

  String get tempBuget {
    return _prefs.getString('tempBuget') ?? '0.00';
  }

  set tempBuget(String value) {
    _prefs.setString('tempBuget', value);
  }
}
