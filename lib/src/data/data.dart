//import 'dart:math';

import 'package:shopapp/src/models/suge.dart';
//import 'package:shopapp/src/providers/db_provider.dart';

class BackendService {
   static List<Segurencia> players;
  static Future<List<Segurencia>> getSuggestions() async {
    players = new List<Segurencia>();
     // players = await DBProvider.db.sugeGet();
      if(players.length == 0){
         print('Nada lindo');
        List  items = ['Pan','Salami','Soda','Aceite'];
        for (var i = 0; i < items.length; i++) {
          //Segurencia se = new Segurencia();
          //se .name = items[i];
          //DBProvider.db.sugeInsert(new Segurencia(name:items[i]));
          
        }
        print('ta lindo');
      } else {
         print('Todos lindo');
      }

    //List<Segurencia>segerecias3 =  [];
    //await Future.delayed(Duration(seconds: 1));
     // await  DBProvider.db.sugeGet();
      // return List.generate(3, (index) {
      //   return new  Segurencia();
      // });
    // return List.generate( (index) {
    //   return {'name': query };
    // });
  }
}


// class PlayersViewModel {
//   static List<Segurencia> players;

//   static Future loadPlayers() async {
//     try {
//       players = new List<Segurencia>();
//      // String jsonString = await rootBundle.loadString('assets/players.json');
//      String jsonString = await DBProvider.db.sugeGet();
//       Map parsedJson = json.decode(jsonString);
//       var categoryJson = parsedJson['players'] as List;
//       for (int i = 0; i < categoryJson.length; i++) {
//         players.add(new Players.fromJson(categoryJson[i]));
//       }
//     } catch (e) {
//       print(e);
//     }
//   }