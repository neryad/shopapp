import 'package:PocketList/src/pages/New-List/newList.dart';
import 'package:flutter/material.dart';
import 'package:PocketList/src/Shared_Prefs/Prefrecias_user.dart';
import 'package:PocketList/src/localization/localization_constant.dart';
import 'package:PocketList/src/pages/list_page.dart';
import 'package:PocketList/src/providers/db_provider.dart';
import 'package:PocketList/src/utils/utils.dart' as utils;
import 'package:url_launcher/url_launcher.dart';

import 'help_page.dart';

// final pdf = pw.Document();

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  final prefs = new PreferenciasUsuario();
  @override
  void initState() {
    super.initState();
    prefs.ultimaPagina = 'home';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: utils.saludos(context),
        elevation: 0.0,
        backgroundColor: utils.cambiarColor(),
      ),
      body: ListPage(),
      drawer: Drawer(
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
                // Navigator.pop(context),
                Navigator.pushNamed(context, 'home')
                // Navigator.pushReplacementNamed(context, 'home')
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text(getTranlated(context, 'mMyLisTitle')),
              onTap: () => {
                // Navigator.pop(context),
                Navigator.pushNamed(context, 'newList')
                // Navigator.pushReplacementNamed(context, 'newList')
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(getTranlated(context, 'mSettingTitle')),
              onTap: () => {
                //Navigator.pop(context),
                Navigator.pushNamed(context, 'settings')
                //Navigator.pushReplacementNamed(context, 'settings')
              },
            ),
            ListTile(
              leading: Icon(Icons.new_releases_sharp),
              title: Text(getTranlated(context, 'mNewsTitle')),
              onTap: () => {
                //Navigator.pop(context),
                Navigator.pushNamed(context, 'newsPage')
                //Navigator.pushReplacementNamed(context, 'settings')
              },
            ),
            ListTile(
              leading: Icon(Icons.mail),
              title: Text(getTranlated(context, 'mContact')),
              onTap: () => {_launchURL()},
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text(getTranlated(context, 'mAboutTitle')),
              onTap: () => {
                // Navigator.pop(context),
                Navigator.pushNamed(context, 'about')
              },
              //{Navigator.pushReplacementNamed(context, 'about')}
            ),
            // ListTile(
            //   leading: Icon(Icons.help),
            //   title: Text(getTranlated(context, 'mHelp')),
            //   onTap: () => {
            //     // Navigator.pop(context),
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
      ),
      //MenuWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return NewList();
            }),
          )
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: utils.cambiarColor(),
      ),
    );
  }

  limpiarTodo() {
    setState(() {
      DBProvider.db.deleteAllList();
      setState(() {});
    });
    Navigator.of(context).pop();
  }

  void _launchURL1(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch';
  void _launchURL() async {
    final Uri params = Uri(
        scheme: 'mailto',
        path: 'neryadg@gmail.com',
        query: 'subject=Contact from Pocketlist');
    String url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }
}
