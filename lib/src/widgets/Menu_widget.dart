import 'package:flutter/material.dart';
import 'package:PocketList/src/utils/utils.dart' as utils;
import 'package:PocketList/src/localization/localization_constant.dart';

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
            leading: Icon(
              Icons.home,
            ),
            title: Text(
              getTranlated(context, 'mHomeTitle'),
            ),
            onTap: () => {Navigator.pushReplacementNamed(context, 'home')},
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text(getTranlated(context, 'mMyLisTitle')),
            onTap: () => {Navigator.pushReplacementNamed(context, 'newList')},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(getTranlated(context, 'mSettingTitle')),
            onTap: () => {Navigator.pushReplacementNamed(context, 'settings')},
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text(getTranlated(context, 'mAboutTitle')),
            onTap: () => {Navigator.pushReplacementNamed(context, 'about')},
          )
        ],
      ),
    );
  }
}
