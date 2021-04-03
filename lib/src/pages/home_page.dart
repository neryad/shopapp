import 'dart:io';
import 'dart:math';
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
        title: Text(
          getTranlated(context, 'mHomeTitle'),
        ),
        elevation: 0.0,
        backgroundColor: utils.cambiarColor(),
      ),
      body: ListPage(),
      drawer: MenuWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {Navigator.pushReplacementNamed(context, 'newList')},
        child: const Icon(Icons.add),
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
