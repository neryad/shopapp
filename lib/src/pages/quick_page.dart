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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add your onPressed code here!
        },
        label: Text('6,000.00'),
        icon: Icon(Icons.monetization_on),
        backgroundColor: Color.fromRGBO(255, 111, 94, 1),
      ),
    );
  }
}