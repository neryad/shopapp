import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:pocketlist/src/theme/app_theme.dart';
import 'package:pocketlist/src/Shared_Prefs/Prefrecias_user.dart';
//import 'package:flushbar/flushbar.dart';
import 'package:pocketlist/src/localization/localization_constant.dart';
import 'package:another_flushbar/flushbar.dart';

final prefs = new PreferenciasUsuario();
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
  return AppTheme.getPrimaryColor(prefs.color,
      customColor: prefs.customColorValue);
}

saludos(BuildContext context) {
  var timeNow = int.parse(DateFormat('kk').format(DateTime.now()));
  String greattin1 = getTranslated(context, 'greattin1');
  String greattin2 = getTranslated(context, 'greattin2');
  String greattin3 = getTranslated(context, 'greattin3');
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

  return Text(msg,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ));
}

void showSnack(BuildContext context, String msg) {
  Flushbar(
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

void showSuccessSnack(BuildContext context, String msg) {
  Flushbar(
    message: msg,
    icon: Icon(Icons.check_circle, size: 28, color: Colors.white),
    leftBarIndicatorColor: Colors.green,
    backgroundColor: Colors.green[700]!,
    duration: Duration(seconds: 2),
    borderRadius: BorderRadius.circular(8),
    margin: EdgeInsets.all(8),
  )..show(context);
}

void showErrorSnack(BuildContext context, String msg) {
  Flushbar(
    message: msg,
    icon: Icon(Icons.error, size: 28, color: Colors.white),
    leftBarIndicatorColor: Colors.red,
    backgroundColor: Colors.red[700]!,
    duration: Duration(seconds: 3),
    borderRadius: BorderRadius.circular(8),
    margin: EdgeInsets.all(8),
  )..show(context);
}

void showInfoSnack(BuildContext context, String msg) {
  Flushbar(
    message: msg,
    icon: Icon(Icons.info_outline,
        size: 28, color: Theme.of(context).colorScheme.primary),
    leftBarIndicatorColor: Theme.of(context).colorScheme.primary,
    duration: Duration(seconds: 2),
    borderRadius: BorderRadius.circular(8),
    margin: EdgeInsets.all(8),
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
