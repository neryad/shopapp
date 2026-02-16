// import 'package:pocketlist/src/pages/New-List/newList.dart';
// import 'package:flutter/material.dart';
// import 'package:pocketlist/src/Shared_Prefs/Prefrecias_user.dart';
// import 'package:pocketlist/src/pages/list_page.dart';

// import 'package:pocketlist/src/utils/utils.dart' as utils;
// import 'package:pocketlist/src/widgets/Menu_widget.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final prefs = new PreferenciasUsuario();

//   @override
//   void initState() {
//     super.initState();
//     prefs.ultimaPagina = 'home';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         title: utils.saludos(context),
//       ),
//       drawer: MenuWidget(),
//       body: ListPage(),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) {
//               return ShoppingListPage();
//             }),
//           )
//         },
//         child: const Icon(
//           Icons.add,
//           color: Colors.white,
//         ),
//         // backgroundColor: utils.cambiarColor(),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:pocketlist/src/Shared_Prefs/Prefrecias_user.dart';
import 'package:pocketlist/src/pages/New-List/newList.dart';
import 'package:pocketlist/src/pages/list_page.dart';
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: utils.cambiarColor(),
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
          'Nueva Lista',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: utils.cambiarColor(),
      ),
    );
  }
}
