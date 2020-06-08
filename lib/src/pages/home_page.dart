import 'package:flutter/material.dart';
import 'package:shopapp/src/pages/list_page.dart';
import 'package:shopapp/src/pages/quick_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        elevation: 0.0,
        
        backgroundColor: Colors.white,
        iconTheme: new IconThemeData(color: Color.fromRGBO(255, 111, 94, 1)),
      ),
      body: _callPage(currentIndex),
      // bottomNavigationBar: __bNavbarHome(),
      
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        onPressed: () =>{ Navigator.pushNamed(context, 'newList')}, //_settingModalBottomSheet(context),
        child: Icon(Icons.add_shopping_cart),
        backgroundColor: Color.fromRGBO(255, 111, 94, 1),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                child: Text(''),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image:
                            AssetImage("assets/undraw_shopping_app_flsj.png"),
                        fit: BoxFit.cover)),
              ),
            
               ListTile(
                leading: Icon(Icons.book),
                title: Text('Pre-list'),
              ),
                ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text('About'),
              )
              
            ],
          ),
        ),
      ),
    );
  }
  Widget _callPage( int currentPage ){
    switch( currentPage ) {
      case 0 : return ListPage();
      case 1 : return QuickPage();

      default:
        return ListPage();
    }
  }

  Widget _Imagen() {
    return Container(
      padding: EdgeInsets.all(10.0),
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
    
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) { 
        setState(() {
          currentIndex = index;
        });
      }, 
      items: [
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

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: _Fromularios()),
                  SizedBox(height: 5),
                ],
              ),
            ));
  }

  Widget _Fromularios() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
                labelText: 'Producto',
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                  color: Color.fromRGBO(255, 111, 94, 1),
                ))),
          ),
          TextField(
              decoration: InputDecoration(
                  labelText: 'Precio',
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Color.fromRGBO(255, 111, 94, 1),
                  ))),
              keyboardType: TextInputType.number),
          // TextField(
          //     decoration: InputDecoration(
          //         labelText: 'Cantidad',
          //         focusedBorder: UnderlineInputBorder(
          //             borderSide: BorderSide(
          //           color: Color.fromRGBO(255, 111, 94, 1),
          //         ))),
          //     keyboardType: TextInputType.number),
          FlatButton(
            onPressed: () {},
            color: Color.fromRGBO(255, 111, 94, 1),
            child: Text(
              'Guardar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
