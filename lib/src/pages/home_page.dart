import 'package:flutter/material.dart';
import 'package:shopapp/src/Shared_Prefs/Prefrecias_user.dart';
import 'package:shopapp/src/pages/list_page.dart';
import 'package:shopapp/src/utils/utils.dart' as utils;
import 'package:shopapp/src/widgets/Menu_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  final prefs = new PreferenciasUsuario();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        elevation: 0.0,
        //title: Text( 'Hola ${prefs.nombreUsuario}', style: TextStyle(color:Colors.red),),
        backgroundColor: utils.cambiarColor(),
        //iconTheme: new IconThemeData(color: Color.fromRGBO(255, 111, 94, 1)),
      ),
      body: ListPage(),
      drawer: MenuWidget(),
    );
  }

  // Widget _callPage( int currentPage ){
  //   switch( currentPage ) {
  //     case 0 : return ListPage();
  //     // case 1 : return QuickPage();

  //     default:
  //       return ListPage();
  //   }
  // }

  // Widget _imagen() {
  //   return Container(
  //     padding: EdgeInsets.all(10.0),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: <Widget>[
  //         Image(
  //           image: AssetImage('assets/undraw_empty_cart_co35.png'),
  //           height: 200.00,
  //           fit: BoxFit.cover,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _bNavbar() {
  //   return BottomNavigationBar(items: [
  //     BottomNavigationBarItem(
  //         icon: Icon(Icons.settings), title: Text('Settings')),
  //     BottomNavigationBarItem(
  //         icon: Icon(Icons.monetization_on),
  //         title: Text(
  //           '10,000.00',
  //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
  //         )),
  //   ]);
  // }

  // Widget _card() {
  //   return Container(
  //     height: 100.00,
  //     child: Card(
  //       elevation: 10.0,
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceAround,
  //         children: <Widget>[
  //           Icon(Icons.shopping_basket, color: Color.fromRGBO(255, 111, 94, 1)),
  //           Text('Compra supermecado'),
  //           Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: <Widget>[
  //             Text('15/05/2020'),
  //             Text('Total: 250.00', style:  TextStyle(fontWeight: FontWeight.bold,), )
  //             ]
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Drawer _crearMenu() {
  //   return Drawer(
  //     child: ListView(
  //       padding: EdgeInsets.zero,
  //       children: <Widget>[
  //         DrawerHeader(
  //           child: Text(''),
  //           decoration: BoxDecoration(
  //               image: DecorationImage(
  //                   image: AssetImage("assets/undraw_shopping_app_flsj.png"),
  //                   fit: BoxFit.cover)),
  //         ),
  //         ListTile(
  //           leading: Icon(Icons.home),
  //           title: Text('Inicio'),
  //           onTap: () => {Navigator.pushReplacementNamed(context, 'home')},
  //         ),
  //         ListTile(
  //           leading: Icon(Icons.list),
  //           title: Text('lista de compra'),
  //           onTap: () => {Navigator.pushNamed(context, 'newList')},
  //         ),
  //         //  ListTile(
  //         //   leading: Icon(Icons.book),
  //         //   title: Text('Pre-list'),
  //         // ),

  //         ListTile(
  //           leading: Icon(Icons.settings),
  //           title: Text('Ajustes'),
  //           onTap: () => {Navigator.pushNamed(context, 'settings')},
  //         ),
  //         ListTile(
  //           leading: Icon(Icons.info),
  //           title: Text('Acerca de'),
  //         )
  //       ],
  //     ),
  //   );
  // }

// Drawer(
//         child: SafeArea(
//           child: ListView(
//             children: <Widget>[
//               DrawerHeader(
//                 child: Text(''),
//                 decoration: BoxDecoration(
//                     image: DecorationImage(
//                         image:
//                             AssetImage("assets/undraw_shopping_app_flsj.png"),
//                         fit: BoxFit.cover)),
//               ),
//               ListTile(
//                 leading: Icon(Icons.home),
//                 title: Text('Inicio'),
//                 onTap: () =>{ Navigator.pushNamed(context, 'home')},
//               ),
//             ListTile(
//                 leading: Icon(Icons.list),
//                 title: Text('lista de compra'),
//                 onTap: () =>{ Navigator.pushNamed(context, 'newList')},
//               ),
//               //  ListTile(
//               //   leading: Icon(Icons.book),
//               //   title: Text('Pre-list'),
//               // ),

//                 ListTile(
//                 leading: Icon(Icons.settings),
//                 title: Text('Ajustes'),
//                  onTap: () =>{ Navigator.pushNamed(context, 'settings')},
//               ),
//               ListTile(
//                 leading: Icon(Icons.info),
//                 title: Text('Acerca de'),
//               )

//             ],
//           ),
//         ),
//       ),
}
