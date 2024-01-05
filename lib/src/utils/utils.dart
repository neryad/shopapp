import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:PocketList/src/Shared_Prefs/Prefrecias_user.dart';
//import 'package:flushbar/flushbar.dart';
import 'package:PocketList/src/localization/localization_constant.dart';
import 'package:PocketList/src/models/product_model.dart';
import 'package:another_flushbar/flushbar.dart';

final prefs = new PreferenciasUsuario();
DateTime now = DateTime.now();
List<ProductModel> deleteItems = [];
var timeNow = int.parse(DateFormat('kk').format(now));

bool isNumeric(String s) {
  if (s.isEmpty) return false;

  final n = num.tryParse(s);

  return (n == null) ? false : true;
}

bool isEmpty(String s) {
  return (s == " ") ? false : true;
}

String numberFormat(double t) {
  NumberFormat f = new NumberFormat("#,##0.00", "en_US");
  return f.format(t);
}

Color cambiarColor() {
  if (prefs.color == 1) {
    return Color.fromRGBO(255, 111, 94, 1);
  } else if (prefs.color == 2) {
    return Color(0xffb0e5c68);
  } else if (prefs.color == 3) {
    return Color(0xffb02b7600);
  } else if (prefs.color == 4) {
    return Color(0xffb0FF1493);
  } else if (prefs.color == 5) {
    return Color(0xffb424242);
  } else if (prefs.color == 6) {
    return Color(0xff7e57c2);
  } else if (prefs.color == 7) {
    return Color(0xffe53935);
  } else {
    return Color.fromRGBO(255, 111, 94, 1);
  }
}

BoxDecoration cambiarHeaderImage() {
  var img = '';
  img = 'assets/shopping_app_${prefs.color}.png';
  // if (prefs.color == 1) {
  //   img = 'assets/undraw_shopping_app_flsj.png';
  // } else if (prefs.color == 2) {
  //   img = 'assets/undraw_shopping_app_flsj_A.png';
  // } else if (prefs.color == 3) {
  //   img = 'assets/undraw_shopping_app_flsj_G.png';
  // } else if (prefs.color == 4) {
  //   img = 'assets/undraw_shopping_app_flsj_R.png';
  // } else if (prefs.color == 5) {
  //   img = 'assets/undraw_shopping_app_flsj_GR.png';
  // } else if (prefs.color == 6) {
  //   img = 'assets/undraw_shopping_app_flsj-dp.png';
  // } else if (prefs.color == 7) {
  //   img = 'assets/undraw_shopping_app_flsj-Red.png';
  // } else {
  //   img = 'assets/undraw_shopping_app_flsj.png';
  // }

  return BoxDecoration(
      image: DecorationImage(image: AssetImage(img), fit: BoxFit.cover));
}

Image cambiarHomeImage() {
  var img;
  img = 'assets/empty_cart_${prefs.color}.png';
  // if (prefs.color == 1) {
  //   img = 'assets/undraw_empty_cart_co35.png';
  // } else if (prefs.color == 2) {
  //   img = 'assets/undraw_empty_cart_co35_A.png';
  // } else if (prefs.color == 3) {
  //   img = 'assets/undraw_empty_cart_co35_G.png';
  // } else if (prefs.color == 4) {
  //   img = 'assets/undraw_empty_cart_co35_R.png';
  // } else if (prefs.color == 5) {
  //   img = 'assets/undraw_empty_cart_co35_GR.png';
  // } else if (prefs.color == 6) {
  //   img = 'assets/undraw_empty_cart_co35-dp.png';
  // } else if (prefs.color == 7) {
  //   img = 'assets/undraw_empty_cart_co35-Red.png';
  // } else {
  //   img = 'assets/undraw_empty_cart_co35.png';
  // }

  return Image(
    image: AssetImage(img),
    height: 150.00,
    fit: BoxFit.fitWidth,
  );
}

Image cambiarNewImage() {
  var img;
  img = 'assets/add_to_cart_${prefs.color}.png';
  // if (prefs.color == 1) {
  //   img = 'assets/add_to_cart.png';
  // } else if (prefs.color == 2) {
  //   img = 'assets/add_to_cart_A.png';
  // } else if (prefs.color == 3) {
  //   img = 'assets/add_to_cart_G.png';
  // } else if (prefs.color == 4) {
  //   img = 'assets/add_to_cart_R.png';
  // } else if (prefs.color == 5) {
  //   img = 'assets/add_to_cart_GR.png';
  // } else if (prefs.color == 6) {
  //   img = 'assets/undraw_add_to_cart_vkjp-dp.png';
  // } else if (prefs.color == 7) {
  //   img = 'assets/undraw_add_to_cart_vkjp-Red.png';
  // } else {
  //   img = 'assets/add_to_cart.png';
  // }

  return Image(
    image: AssetImage(img),
    height: 200.00,
    fit: BoxFit.cover,
  );
}

saludos(BuildContext context) {
  String greattin1 = getTranlated(context, 'greattin1')!;
  String greattin2 = getTranlated(context, 'greattin2')!;
  String greattin3 = getTranlated(context, 'greattin3')!;
  var msg = '';
  if (timeNow <= 11) {
    msg = '$greattin1 ${prefs.nombreUsuario}';
  } else if ((timeNow >= 12) && (timeNow <= 16)) {
    msg = '$greattin2 ${prefs.nombreUsuario}';
  } else if ((timeNow > 16) && (timeNow < 19)) {
    msg = '$greattin2 ${prefs.nombreUsuario}';
  } else {
    msg = '$greattin3 ${prefs.nombreUsuario}';
  }
  // return msg;

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
      color: (prefs.color == 5) ? Colors.white : cambiarColor(),
    ),
    leftBarIndicatorColor: (prefs.color == 5) ? Colors.white : cambiarColor(),
    duration: Duration(seconds: 2),
  )..show(context);
}

// Future<String> get _localPath async {
//   final directory = await getApplicationDocumentsDirectory();

//   return directory.path;
// }

// Future<File> get _localFile async {
//   final path = await _localPath;
//   print('path ${path}');
//   return File('$path/lista.pdf');
// }

// Future<int> deleteFile(String name) async {
//   final dir = await getApplicationDocumentsDirectory();
//   final file = File('${dir.path}/$name.pdf');
//   try {
//     await file.delete();
//     return 1;
//   } catch (e) {
//     return 0;
//   }
// }
