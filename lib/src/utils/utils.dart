import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:shopapp/src/Shared_Prefs/Prefrecias_user.dart';

final prefs = new PreferenciasUsuario();

bool isNumeric(String s) {
  if (s.isEmpty) return false;

  final n = num.tryParse(s);

  return (n == null) ? false : true;
}

String numberFormat(double t) {
  NumberFormat f = new NumberFormat("#,##0.00", "en_US");
  return f.format(t);
}

Color cambiarColor() {
  print(prefs.genero);
  if (prefs.genero == 1) {
    return Color.fromRGBO(255, 111, 94, 1);
  } else if (prefs.genero == 2) {
    return Color(0xffb0e5c68);
  } else if (prefs.genero == 3) {
    return Color(0xffb02b7600);
  } else if (prefs.genero == 4) {
    return Color(0xffb0FF1493);
  } else {
    return Color(0xffb04e4e4e);
  }

  //   Color bgColor = Color(0xffb9fbec3);
  // Color bgColor1 = Color(0xffb0e5c68);
  // Color bgColor2 = Color(0xffbf9fbfb);
  // return Color.fromRGBO(255, 111, 94, 1);
}
