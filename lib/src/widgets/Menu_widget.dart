import 'package:flutter/material.dart';

class MenuWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(''),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/undraw_shopping_app_flsj.png"),
                    fit: BoxFit.cover)),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Inicio'),
            onTap: () => {Navigator.pushReplacementNamed(context, 'home')},
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('lista de compra'),
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
