import 'package:flutter/material.dart';
import 'package:shopapp/src/Shared_Prefs/Prefrecias_user.dart';
import 'package:shopapp/src/pages/home_page.dart';
import 'package:shopapp/src/pages/newList.dart';
import 'package:shopapp/src/pages/setting_page.dart';
void main() async {
    WidgetsFlutterBinding.ensureInitialized(); 
     final prefs = new PreferenciasUsuario();
     await prefs.initPrefes();
     runApp(new MyApp()); 
    

}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TuCompra',
      initialRoute: 'home',
      routes: {
        'home' : ( BuildContext context) => HomePage(),
        'newList': ( BuildContext context) => NewList(),
        'settings': ( BuildContext context) => SettingPage(),
      },
    );
  }
}
