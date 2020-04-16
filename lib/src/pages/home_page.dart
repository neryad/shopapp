import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              _Imagen(),
              _card(),
              // _header()
              // _lista(),
            ],
          ),
        ),
      ),
       bottomNavigationBar: __bNavbar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarAlert(context),
        child: Icon(Icons.add_shopping_cart),
        backgroundColor: Color.fromRGBO(255, 111, 94, 1),
      ),
    );
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

  Widget __bNavbar() {

    return BottomNavigationBar(
      items: [
         BottomNavigationBarItem(icon: Icon(Icons.settings), title: Text('Settings')),
        BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on), title: Text('10,000.00', style: TextStyle(fontWeight: FontWeight.bold, fontSize:20.0),)),
      ]
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
           Icon(Icons.shopping_cart, color:  Color.fromRGBO(255, 111, 94, 1)),
           Text('Pasta'),
           Text('2'),
           Text('125'),
           Text('250.00')
           
          ],
        ),
      ),
    );

  }

   void _mostrarAlert(BuildContext context){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context){
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          title: Text('Titulo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children:<Widget>[
              Text('Este el contenido de la casja'),
              FlutterLogo(size:100.0)
            ]
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(), 
              child: Text('Cancelar')),
             FlatButton(
               onPressed: () {
                 Navigator.of(context).pop();
               }, 
               child: Text('Ok'))
          ],
        );
      }
    );
  }
}
