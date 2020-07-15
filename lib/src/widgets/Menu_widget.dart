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
            leading: Icon(Icons.home),
            title: Text('Mis listas'),
            onTap: () => {Navigator.pushReplacementNamed(context, 'home')},
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Nueva lista'),
            onTap: () => {Navigator.pushReplacementNamed(context, 'newList')},
          ),
          //  ListTile(
          //   leading: Icon(Icons.book),
          //   title: Text('Pre-list'),
          // ),

          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Ajustes'),
            onTap: () => {Navigator.pushReplacementNamed(context, 'settings')},
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Acerca de'),
          )
        ],
      ),
    );
  }
}
