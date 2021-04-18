import 'dart:io';
import 'dart:math';
import 'package:PocketList/src/pages/New-List/newList.dart';
import 'package:PocketList/src/utils/pdf.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:PocketList/src/Shared_Prefs/Prefrecias_user.dart';
import 'package:PocketList/src/localization/localization_constant.dart';
import 'package:PocketList/src/pages/list_page.dart';
import 'package:PocketList/src/providers/db_provider.dart';
import 'package:PocketList/src/utils/utils.dart' as utils;
import 'package:PocketList/src/widgets/Menu_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
// import 'package:pdf/widgets.dart';

import 'package:share_extend/share_extend.dart';
import 'package:url_launcher/url_launcher.dart';

import 'help_page.dart';

final pdf = pw.Document();

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
        title: Column(mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [Text(getTranlated(context, 'mHomeTitle'))],
              ),
              Column(
                children: [Text(utils.saludos(context))],
              )
              // Text(
              //   getTranlated(context, 'mHomeTitle'),
              // ),
              // utils.saludos(context),
            ]),
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
              leading: Icon(Icons.info),
              title: Text(getTranlated(context, 'mAboutTitle')),
              onTap: () => {
                // Navigator.pop(context),
                Navigator.pushNamed(context, 'about')
              },
              //{Navigator.pushReplacementNamed(context, 'about')}
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text(getTranlated(context, 'mHelp')),
              onTap: () => {
                // Navigator.pop(context),
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => new HelpPage(),
                    ))
                //Navigator.pushNamed(context, 'help')
              },
            )
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
}
