import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:shopapp/src/Shared_Prefs/Prefrecias_user.dart';
import 'package:flushbar/flushbar.dart';
import 'package:shopapp/src/localization/localization_constant.dart';

final prefs = new PreferenciasUsuario();

bool isNumeric(String s) {
  if (s.isEmpty) return false;

  final n = num.tryParse(s);

  return (n == null) ? false : true;
}

DateTime now = DateTime.now();

var timeNow = int.parse(DateFormat('kk').format(now));

String numberFormat(double t) {
  NumberFormat f = new NumberFormat("#,##0.00", "en_US");
  return f.format(t);
}

Color cambiarColor() {
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
  var img = '';
  if (prefs.genero == 1) {
    img = 'assets/undraw_shopping_app_flsj.png';
  } else if (prefs.genero == 2) {
    img = 'assets/undraw_shopping_app_flsj_A.png';
  } else if (prefs.genero == 3) {
    img = 'assets/undraw_shopping_app_flsj_G.png';
  } else if (prefs.genero == 4) {
    img = 'assets/undraw_shopping_app_flsj_R.png';
  } else {
    img = 'assets/undraw_shopping_app_flsj_GR.png';
  }

  return BoxDecoration(
      image: DecorationImage(image: AssetImage(img), fit: BoxFit.cover));
}

Image cambiarHomeImage() {
  var img;
  if (prefs.genero == 1) {
    img = 'assets/undraw_empty_cart_co35.png';
  } else if (prefs.genero == 2) {
    img = 'assets/undraw_empty_cart_co35_A.png';
  } else if (prefs.genero == 3) {
    img = 'assets/undraw_empty_cart_co35_G.png';
  } else if (prefs.genero == 4) {
    img = 'assets/undraw_empty_cart_co35_R.png';
  } else {
    img = 'assets/undraw_empty_cart_co35_GR.png';
  }

  return Image(
    image: AssetImage(img),
    height: 150.00,
    fit: BoxFit.cover,
  );
}

Image cambiarNewImage() {
  var img;
  if (prefs.genero == 1) {
    img = 'assets/add_to_cart.png';
  } else if (prefs.genero == 2) {
    img = 'assets/add_to_cart_A.png';
  } else if (prefs.genero == 3) {
    img = 'assets/add_to_cart_G.png';
  } else if (prefs.genero == 4) {
    img = 'assets/add_to_cart_R.png';
  } else {
    img = 'assets/add_to_cart_GR.png';
  }

  return Image(
    image: AssetImage(img),
    height: 200.00,
    fit: BoxFit.cover,
  );
}

saludos(BuildContext context) {
  String greattin1 = getTranlated(context, 'greattin1');
  String greattin2 = getTranlated(context, 'greattin2');
  String greattin3 = getTranlated(context, 'greattin3');
  var msg = '';
  if (timeNow <= 11) {
    msg = '${greattin1} ${prefs.nombreUsuario}';
  } else if ((timeNow >= 12) && (timeNow <= 16)) {
    msg = '${greattin2} ${prefs.nombreUsuario}';
  } else if ((timeNow > 16) && (timeNow < 19)) {
    msg = '${greattin2} ${prefs.nombreUsuario}';
  } else {
    msg = '${greattin3} ${prefs.nombreUsuario}';
  }
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(msg,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          )),
    ],
  );
}

void showSnack(BuildContext context, String msg) {
  Flushbar(
    //title: 'This action is prohibited',
    message: msg,
    icon: Icon(
      Icons.info_outline,
      size: 28,
      color: cambiarColor(),
    ),
    leftBarIndicatorColor: cambiarColor(),
    duration: Duration(seconds: 2),
  )..show(context);
}
