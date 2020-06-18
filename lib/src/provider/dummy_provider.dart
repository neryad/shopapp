// import 'dart:convert';

// import 'package:flutter/services.dart' show rootBundle;
// class _DummyProvider{
//   List<dynamic> dummy = [];

//   _DummyProvider(){
//     cargarData();
//   }

  
//  Future<List<dynamic>> cargarData() async {
//     final resp = await rootBundle.loadString('data/data_ex.json');
         
//             Map dataMap = json.decode(resp);
//             dummy = dataMap['productos'];
//             print(dummy);

//             return dummy;
          
//   }
// }


// //   cargarData() {
// //     rootBundle.loadString('data/data_ex.json')
// //           .then((data) {
// //             Map dataMap = json.decode(data);
// //             dummy = dataMap['productos'];
// //           });
// //   }
// // }

// final dummyProvider = new _DummyProvider();

// Container(
//                 child: Column(
//                     children: [1, 2, 3, 4, 5].map((e) {
//                 return Card(
//                     elevation: 4,
//                     margin: EdgeInsets.all(20),
//                     child: Container(
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                         child: Row(
//                           children: <Widget>[
//                             Expanded(
//                                 flex: 2,
//                                 child: Row(
//                                   children: <Widget>[
//                                     Container(
//                                       margin: EdgeInsets.symmetric(
//                                         horizontal: 10,
//                                       ),
//                                       child: Icon(Icons.shopping_cart,
//                                           color: Colors.orangeAccent),
//                                     ),
//                                     Expanded(
//                                       flex: 2,
//                                       child: Container(
//                                           child: Text(
//                                         "TExttooooooooooooooo",
//                                         overflow: TextOverflow.ellipsis,
//                                       )),
//                                     ),
//                                     SizedBox(
//                                       width: 10,
//                                     ),
//                                     Expanded(
//                                       child: Text(
//                                         "600.00",
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                     )
//                                   ],
//                                 )),
//                             Expanded(
//                                 child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: <Widget>[
//                                 Icon(Icons.add_circle,
//                                     color: Colors.orangeAccent),
//                                 Text(
//                                   "0",
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                                 Icon(Icons.remove_circle,
//                                     color: Colors.orangeAccent),
//                               ],
//                             )),
//                           ],
//                         )));
//               }).toList()))


//TextField(
                                
  //                                 onChanged: (text) {
  //                                   items[index]['price'] = num.parse(text);
  //                                 },
  //                                 keyboardType: TextInputType.number,
  //                                 decoration:
  //                                     InputDecoration(hintText: 'precio'),
  //                                 style: TextStyle(

  //                                     // fontSize: 40.0,
  //                                     height: 2.0,
  //                                     color: Colors.black)))