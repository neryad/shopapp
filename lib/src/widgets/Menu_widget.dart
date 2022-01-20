import 'package:PocketList/src/Shared_Prefs/Prefrecias_user.dart';
import 'package:PocketList/src/pages/help_page.dart';
import 'package:flutter/material.dart';
import 'package:PocketList/src/utils/utils.dart' as utils;
import 'package:PocketList/src/localization/localization_constant.dart';

class MenuWidget extends StatelessWidget {
  final prefs = new PreferenciasUsuario();
  Locale _locale;

  @override
  Widget build(
    BuildContext context,
  ) {
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
            onTap: () => {
              Navigator.pop(context),
              Navigator.pushNamed(context, 'home')
              // Navigator.pushReplacementNamed(context, 'home')
            },
          ),

          ListTile(
            leading: Icon(Icons.list),
            title: Text(getTranlated(context, 'mMyLisTitle')),
            onTap: () => {
              Navigator.pop(context),
              Navigator.pushNamed(context, 'newList')
              // Navigator.pushReplacementNamed(context, 'newList')
            },
          ),
          ListTile(
            leading: Icon(Icons.sync),
            title: Text('Import/exportar'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(getTranlated(context, 'mSettingTitle')),
            onTap: () => {
              Navigator.pop(context),
              Navigator.pushNamed(context, 'settings')
              // Navigator.pushReplacementNamed(context, 'settings')
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.info),
          //   title: Text(getTranlated(context, 'mAboutTitle')),
          //   onTap: () =>
          //       {Navigator.pop(context), Navigator.pushNamed(context, 'about')},
          //   //{Navigator.pushReplacementNamed(context, 'about')}
          // ),

          // ListTile(
          //   leading: Icon(Icons.info),
          //   title: Text(getTranlated(context, 'mAboutTitle')),
          //   onTap: () =>
          //       {Navigator.pop(context), Navigator.pushNamed(context, 'about')},
          //   //{Navigator.pushReplacementNamed(context, 'about')}
          // ),
          // ListTile(
          //   leading: Icon(Icons.help),
          //   title: Text(getTranlated(context, 'mHelp')),
          //   onTap: () => {
          //     Navigator.pop(context),
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => new HelpPage(),
          //         ))
          //     //Navigator.pushNamed(context, 'help')
          //   },
          // )
        ],
      ),
    );
  }
}
