import 'package:flutter/material.dart';
import 'package:shopapp/src/pages/home_page.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pockedlist',
      home: Scaffold(
        body: HomePage(),
      ),
    );
  }
}