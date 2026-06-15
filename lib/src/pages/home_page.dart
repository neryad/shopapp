import 'package:flutter/material.dart';
import 'package:pocketlist/src/Shared_Prefs/Preferencias_user.dart';
import 'package:pocketlist/src/pages/New-List/newList.dart';
import 'package:pocketlist/src/pages/list_page.dart';
import 'package:pocketlist/src/localization/localization_constant.dart';
import 'package:pocketlist/src/utils/utils.dart' as utils;
import 'package:pocketlist/src/widgets/Menu_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final prefs = PreferenciasUsuario();

  @override
  void initState() {
    super.initState();
    prefs.ultimaPagina = 'home';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: utils.saludos(context),
        elevation: 0,
      ),
      drawer: MenuWidget(),
      body: ListPage(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ShoppingListPage(), // Sin parámetro = nueva lista
            ),
          );
        },
        icon: Icon(Icons.add, color: Colors.white),
        label: Text(
          getTranslated(context, 'fabNewList'),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
