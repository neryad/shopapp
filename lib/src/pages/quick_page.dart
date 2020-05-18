import 'package:flutter/material.dart';

class QuickPage extends StatefulWidget {
  QuickPage({Key key}) : super(key: key);

  @override
  _QuickPageState createState() => _QuickPageState();
}

class _QuickPageState extends State<QuickPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body:Center(
      child:  Text('Quick'),
    ),
    
    );
  }
}