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
}

BoxDecoration cambiarHeaderImage() {
  if (prefs.genero == 1) {
    return BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/undraw_shopping_app_flsj.png"),
            fit: BoxFit.cover));
  } else if (prefs.genero == 2) {
    return BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/undraw_shopping_app_flsj_A.png"),
            fit: BoxFit.cover));
  } else if (prefs.genero == 3) {
    return BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/undraw_shopping_app_flsj_G.png"),
            fit: BoxFit.cover));
  } else if (prefs.genero == 4) {
    return BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/undraw_shopping_app_flsj_R.png"),
            fit: BoxFit.cover));
  } else {
    return BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/undraw_shopping_app_flsj_GR.png"),
            fit: BoxFit.cover));
  }
}

Image cambiarHomeImage() {
  if (prefs.genero == 1) {
    return Image(
      image: AssetImage('assets/undraw_empty_cart_co35.png'),
      height: 200.00,
      fit: BoxFit.cover,
    );
  } else if (prefs.genero == 2) {
    return Image(
      image: AssetImage('assets/undraw_empty_cart_co35_A.png'),
      height: 200.00,
      fit: BoxFit.cover,
    );
  } else if (prefs.genero == 3) {
    return Image(
      image: AssetImage('assets/undraw_empty_cart_co35_G.png'),
      height: 200.00,
      fit: BoxFit.cover,
    );
  } else if (prefs.genero == 4) {
    return Image(
      image: AssetImage('assets/undraw_empty_cart_co35_R.png'),
      height: 200.00,
      fit: BoxFit.cover,
    );
  } else {
    return Image(
      image: AssetImage('assets/undraw_empty_cart_co35_GR.png'),
      height: 200.00,
      fit: BoxFit.cover,
    );
  }
}

Image cambiarNewImage() {
  if (prefs.genero == 1) {
    return Image(
      image: AssetImage('assets/add_to_cart.png'),
      height: 240.00,
      fit: BoxFit.cover,
    );
  } else if (prefs.genero == 2) {
    return Image(
      image: AssetImage('assets/add_to_cart_A.png'),
      height: 240.00,
      fit: BoxFit.cover,
    );
  } else if (prefs.genero == 3) {
    return Image(
      image: AssetImage('assets/add_to_cart_G.png'),
      height: 240.00,
      fit: BoxFit.cover,
    );
  } else if (prefs.genero == 4) {
    return Image(
      image: AssetImage('assets/add_to_cart_R.png'),
      height: 240.00,
      fit: BoxFit.cover,
    );
  } else {
    return Image(
      image: AssetImage('assets/add_to_cart_GR.png'),
      height: 240.00,
      fit: BoxFit.cover,
    );
  }
}
