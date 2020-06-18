import 'package:flutter/material.dart';

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
            _imagen(),
            _card(),
            _card(),
            _card(),
            _card(),
            _card(),
             _card(),
            _card(),
            _card(),

            // _header()
            // _lista(),
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
          Image(
            image: AssetImage('assets/undraw_empty_cart_co35.png'),
            height: 200.00,
            fit: BoxFit.cover,
          ),
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
            Icon(Icons.shopping_basket, color: Color.fromRGBO(255, 111, 94, 1)),
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
