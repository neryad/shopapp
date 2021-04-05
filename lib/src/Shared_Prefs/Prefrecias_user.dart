import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class PreferenciasUsuario {
  static final PreferenciasUsuario _instacia =
      new PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instacia;
  }

  PreferenciasUsuario._internal();

  SharedPreferences _prefs;

  initPrefes() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  Color defaultColor = Color.fromRGBO(255, 111, 94, 1);
  get color {
    return _prefs.getInt('color') ?? 1;
  }

  set color(int value) {
    _prefs.setInt('color', value);
  }

  get colorSecundario {
    return _prefs.getBool('colorSecundario') ?? false;
  }

  set colorSecundario(bool value) {
    _prefs.setBool('colorSecundario', value);
  }

  get nombreUsuario {
    return _prefs.getString('nombreUsuario') ?? '';
  }

  set nombreUsuario(String value) {
    _prefs.setString('nombreUsuario', value);
  }

  get lnge {
    return _prefs.getString('lnge');
  }

  set lnge(String value) {
    _prefs.setString('lnge', value);
  }

  get ultimaPagina {
    return _prefs.getString('ultimaPagina') ?? 'home';
  }

  set ultimaPagina(String value) {
    _prefs.setString('ultimaPagina', value);
  }

  get tempTotal {
    return _prefs.getString('tempTotal') ?? '0.00';
  }

  set tempTotal(String value) {
    _prefs.setString('tempTotal', value);
  }

  get tempBuget {
    return _prefs.getString('tempBuget') ?? '0.00';
  }

  set tempBuget(String value) {
    _prefs.setString('tempBuget', value);
  }
}
