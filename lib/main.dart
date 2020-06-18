import 'package:flutter/material.dart';
import 'package:shopapp/src/pages/home_page.dart';
import 'package:shopapp/src/pages/newList.dart';

 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TuCompra',
      initialRoute: 'newList',
      routes: {
        'home' : ( BuildContext context) => HomePage(),
        'newList': ( BuildContext context) => NewList(),
      },
      // home: Scaffold(
      //   body: HomePage(),
      // ),
    );
  }
}