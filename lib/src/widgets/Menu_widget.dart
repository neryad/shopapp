import 'package:flutter/material.dart';
import 'package:shopapp/src/utils/utils.dart' as utils;
class MenuWidget extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(''),
            decoration: utils.cambiarHeaderImage(),
          ),
          ListTile(
            
            leading: Icon(Icons.home, size: 30.0,),
            title: Text('Mis listas', style: TextStyle(fontSize: 18.0),),
            onTap: () => {Navigator.pushReplacementNamed(context, 'home')},
          ),
          ListTile(
            leading: Icon(Icons.list, size: 30.0,),
            title: Text('Lista de compra',style: TextStyle(fontSize: 18.0),),
            onTap: () => {Navigator.pushReplacementNamed(context, 'newList')},
          ),
          ListTile(
            leading: Icon(Icons.settings, size: 30.0,),
            title: Text('Ajustes',style: TextStyle(fontSize: 18.0),),
            onTap: () => {Navigator.pushReplacementNamed(context, 'settings')},
          ),
          ListTile(
            leading: Icon(Icons.info, size: 30.0,),
            title: Text('Acerca de',style: TextStyle(fontSize: 18.0),),
            onTap: () => {Navigator.pushReplacementNamed(context, 'about')},
          )
        ],
      ),
    );
  }
}
