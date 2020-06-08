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
      // appBar: new AppBar(
      //   elevation: 0.0,
      //   backgroundColor: Colors.white,
      //   iconTheme: new IconThemeData(color: Color.fromRGBO(255, 111, 94, 1)),
      // ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            _Imagen(),
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

  Widget _Imagen() {
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

  Widget __bNavbarHome() {
    return BottomNavigationBar(items: [
      BottomNavigationBarItem(
          icon: Icon(Icons.store_mall_directory), title: Text('Home')),
      BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart), title: Text('Quick list')),
    ]);
  }

  Widget __bNavbar() {
    return BottomNavigationBar(items: [
      BottomNavigationBarItem(
          icon: Icon(Icons.settings), title: Text('Settings')),
      BottomNavigationBarItem(
          icon: Icon(Icons.monetization_on),
          title: Text(
            '10,000.00',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          )),
    ]);
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
