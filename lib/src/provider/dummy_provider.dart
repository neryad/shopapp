import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
class _DummyProvider{
  List<dynamic> dummy = [];

  _DummyProvider(){
    cargarData();
  }

  
 Future<List<dynamic>> cargarData() async {
    final resp = await rootBundle.loadString('data/data_ex.json');
         
            Map dataMap = json.decode(resp);
            dummy = dataMap['productos'];
            print(dummy);

            return dummy;
          
  }
}


//   cargarData() {
//     rootBundle.loadString('data/data_ex.json')
//           .then((data) {
//             Map dataMap = json.decode(data);
//             dummy = dataMap['productos'];
//           });
//   }
// }

final dummyProvider = new _DummyProvider();