import 'package:flutter/material.dart';
import 'package:shopapp/src/utils/utils.dart' as utils;

class ListPage extends StatefulWidget {
  ListPage({Key key}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            utils.saludos(),
            _imagen(),
            _card(),
            _card(),
            _card(),
            _card(),
            _card(),
             _card(),
            _card(),
            _card(),
          ],
        ),
      ),
    );
  }
}

  Widget _imagen() {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          utils.cambiarHomeImage(),
        ],
      ),
    );
  }
  
  Widget _card() {
    return Container(
      height: 100.00,
      child: Card(
        elevation: 10.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Icon(Icons.shopping_basket, color: utils.cambiarColor()),
            Text('Compra supermecado'),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              Text('15/05/2020'), 
              Text('Total: 250.00', style:  TextStyle(fontWeight: FontWeight.bold,), )
              ]
            ),
          ],
        ),
      ),
    );
  }
