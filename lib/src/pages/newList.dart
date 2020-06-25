//Navigator.pushNamed(context, 'newList');
//import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopapp/src/models/product_model.dart';
import 'package:shopapp/src/utils/utils.dart' as utils;
import 'package:uuid/uuid.dart';
//import 'package:uuid/uuid_util.dart';
// import 'package:shopapp/src/widgets/counter.dart';
// import 'package:intl/intl.dart';

class NewList extends StatefulWidget {
  NewList({Key key}) : super(key: key);

  @override
  _NewListState createState() => _NewListState();
}

class _NewListState extends State<NewList> {
  double buget = 00.00;
  double total = 0.00;
  double diference = 0.00;

  Color colorBuget = Color.fromRGBO(255, 111, 94, 1);
  Color bugetColor = Color.fromRGBO(255, 111, 94, 1);
  var uuid = Uuid();
  // String bugetText = "Presupuesto";
  TextEditingController _articlesCtrl = new TextEditingController();

  // @override
  // void dispose() {
  //   // Limpia el controlador cuando el widget se elimine del árbol de widgets
  //   _articlesPriceCtrl.dispose();
  //   super.dispose();
  // }
  // List<dynamic> items = [
  //   {"name": "pan", "price": 0.00, "quantity": 0},
  //   {"name": "cafe", "price": 0.00, "quantity": 0},
  //   {"name": "desodorante", "price": 888.58, "quantity": 0}
  // ];

  List<ProductModel> items = [];
  List<TextEditingController> _controllers = new List();
  final formKey = GlobalKey<FormState>();
  ProductModel productModel = new ProductModel();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 200),
          child: Container(
         
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(color: Colors.black12, spreadRadius: 5, blurRadius: 2)
            ]),
            width: width/2.2,
            height: 120,
            child: Container(
              //height: 120,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Container(width: 8.0, height: 70.0, color: Colors.white),
                    //SizedBox(width: 15.0),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                     // crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FlatButton.icon(
                            onPressed: () => _mostrarAlerta(context),
                            icon: Icon(Icons.account_balance_wallet),
                            label: Text("Presupuesto")),
                        Text(
                          utils.numberFormat(buget),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 20,
                              color: bugetColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Spacer(),
                    //SizedBox(width: 15.0),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.shopping_cart),
                            label: Text("Total")),
                        Text(
                          utils.numberFormat(total),
                          style: TextStyle(
                              
                              fontSize: 20,
                              color: Color.fromRGBO(255, 111, 94, 1),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                     // crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        FlatButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.shuffle),
                            label: Text("Diferencia")),
                        Text(
                          utils.numberFormat(diference),
                          style: TextStyle(
                              fontSize: 20,
                              color: colorBuget,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                   // SizedBox(width: 18.0),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  _controllers.add(new TextEditingController());
                  return Dismissible(
                    background: 
                    
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.red,
                        child: Align(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              Text(
                                " Eliminar",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.right,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                          alignment: Alignment.centerRight,
                        ),
                      ),
              
                    ),
                   
                    // background: Card(

                    //   color: Colors.red,
                    //   elevation: 4,
                    //   margin: EdgeInsets.all(15),
                    //   child: Icon(Icons.delete_forever, color: Colors.white,),
                    // ),
                    key: Key(items[index].name + items.length.toString()),
                    // key: Key('items[index]'),
                    //key: Key('items[index]'),
                    // secondaryBackground: (
                    //      Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Container(
                    //     color: Colors.green,
                    //     child: Align(
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.end,
                    //         children: <Widget>[
                    //           Icon(
                    //             Icons.check,
                    //             color: Colors.white,
                    //           ),
                    //           Text(
                    //             " Completado",
                    //             style: TextStyle(
                    //               color: Colors.white,
                    //               fontWeight: FontWeight.w700,
                    //             ),
                    //             textAlign: TextAlign.right,
                    //           ),
                    //           SizedBox(
                    //             width: 20,
                    //           ),
                    //         ],
                    //       ),
                    //       alignment: Alignment.centerRight,
                    //     ),
                    //   ),
              
                    // )),

                    
                    
                    onDismissed: (direction) {
                      // if(direction == DismissDirection.endToStart){
                      //   print('Verder');
                      // }
                      // print(direction);
                      //DismissDirection.endToStart azuel
                      //DismissDirection.startToEnd rojhos

                 
                      var priceToDel = items[index].price;
                      // items.removeWhere((item) => item.id ==items[index].id);

                      //items.removeWhere((item) => item.id == items[index].id);
                      setState(() {
                        items.removeAt(index);
                        total = total - priceToDel;
                        getDiference();

                        //items.removeAt(index);
                      });
                      // setState(() {

                      //   getTotal();
                      // });

                      //getTotal();
                    },
                    child: Card(
                      elevation: 2,
                      margin: EdgeInsets.all(10),
                      child: Container(
                        padding:
                             EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        height: 80.00,
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceAround,

                          children: <Widget>[
                            Expanded(
                           
                              child: Column(children: <Widget>[
                                Container(
                               
                                  child: Row(
                                      children: <Widget>[
                                        SizedBox( width: 15,),
                                        Text(
                                          items[index].name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900),

                                          textAlign: TextAlign.start,
                                        ),
                                        
                                      ]
                                      ),
                                ),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child:
                                            //_creaPrecio(index)
                                            TextField(
                                          maxLength:6,
                                          controller: _controllers[index],
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                              hintText: '0.0', counterText: ''),
                                          keyboardType: TextInputType.number,
                                          onChanged: (text) {
                                            items[index].price =
                                                num.parse(text).toDouble();
                                            setState(() {
                                              getTotal();
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                          flex: 5,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Expanded(
                                                flex: 2,
                                                child: IconButton(
                                                  icon: Icon(Icons.add),
                                                  color: Color.fromRGBO(
                                                      255, 111, 94, 1),
                                                  onPressed: () {
                                                    setState(() {
                                                      _sumProduct(index);
                                                    });
                                                  },
                                                ),
                                              ),
                                              Expanded(
                                                flex:2,
                                                child: Text(
                                                  items[index]
                                                      .quantity
                                                      .toString(),
                                                  overflow: TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: IconButton(
                                                  icon: Icon(Icons.remove),
                                                  color: Color.fromRGBO(
                                                      255, 111, 94, 1),
                                                  onPressed: () {
                                                    setState(() {
                                                      _resProduct(index);
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          )),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                          child: Text(
                                            
                                            utils.numberFormat(
                                              items[index].quantity *
                                                  items[index].price,
                                            ),
                                            style: TextStyle(fontWeight: FontWeight.w600),
                                            //overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ]),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            _newProducto(),
          ],
        ));
  }

  validconte() {
    if (items.length == 0) {
      return Text('nada');
    } else {
      return ('todo');
    }
  }

  _sumProduct(int index) {
    setState(() {
      items[index].quantity++;
      getTotal();
    });
  }

  _resProduct(int index) {
    setState(() {
      if (items[index].quantity == 0) {
        return;
      }
      items[index].quantity--;

      getTotal();
    });
  }

  void getTotal() {
    if (items != null) {
      total = 0;
      for (int i = 0; i < items.length; i++) {
        setState(() {
          total += (items[i].price * items[i].quantity);
          getDiference();
          if (total > buget) {
            bugetColor = Colors.red[900];
          } else {
            bugetColor = Color.fromRGBO(255, 111, 94, 1);
          }
        });
      }
    }
  }

  void getDiference() {
    if (total == 0) {
      diference = buget;
      colorBuget = colorBuget = Colors.green[400];
      return;
    }
    double calDiferecen = buget - total;
    if (calDiferecen < 0) {
      colorBuget = Colors.red[900];
    } else if (calDiferecen == 0) {
      colorBuget = Color.fromRGBO(255, 111, 94, 1);
    } else {
      colorBuget = Colors.green[400];
    }
    diference = calDiferecen;
  }

  void _mostrarAlerta(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(' Presupuesto'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _crearIpunt(),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancelar')),
              FlatButton(
                  onPressed: () {
                    getTotal();
                    Navigator.of(context).pop();
                  },
                  child: Text('Aceptar')),
            ],
          );
        });
  }

  Widget _crearIpunt() {
    return TextField(
      maxLength: 6,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        counterText: '',
        hintText: 'Ingresar nuevo presupuesto',
        suffixIcon: Icon(
          Icons.account_balance_wallet,
          color: Color.fromRGBO(255, 111, 94, 1),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(255, 111, 94, 1)),
        ),
      ),
      onChanged: (value) {
        if (value == null) {
          return;
        } else {
          buget = double.parse(value);
        }
      },
    );
  }

  Widget _newProducto() {
    var it = items.length;
    return Container(
      color: Colors.white60,
      child: TextField(
        maxLength: 50,
        textCapitalization: TextCapitalization.sentences,
        textAlign: TextAlign.center,
        controller: _articlesCtrl,
        onSubmitted: (text) {
          if( text == ''){
            return;
          }
          // insertar(it,text);
          var newId = uuid.v1();
          items.insert(
              it,
              new ProductModel(
                  id: newId, name: text, quantity: 1, price: 0.00));
          _articlesCtrl.clear();
          setState(() {});
        },
        decoration: InputDecoration(
          counterText: '',
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(255, 111, 94, 1)),
          ),
          hintText: 'Nuevo articulo',
          hintStyle: TextStyle(color: Color.fromRGBO(255, 111, 94, 1)),
        ),
      ),
    );
  }
}

// if(items.length == 0){
//       return  Scaffold(
//         backgroundColor: Colors.grey[200],
//         appBar: PreferredSize(
//           preferredSize: Size(double.infinity, 200),
//           child: Container(
//             decoration: BoxDecoration(boxShadow: [
//               BoxShadow(color: Colors.black12, spreadRadius: 5, blurRadius: 2)
//             ]),
//             width: MediaQuery.of(context).size.width,
//             height: 140,
//             child: Container(

//               decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(20),
//                       bottomRight: Radius.circular(20))),
//               child: Container(
//                 margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Container(width: 8.0, height: 70.0, color: Colors.white),
//                     Column(
//                       children: <Widget>[
//                         FlatButton.icon(
//                             onPressed: () => _mostrarAlerta(context),
//                             icon: Icon(Icons.account_balance_wallet),
//                             label: Text("Presupuesto")),
//                         Text(
//                           utils.numberFormat(buget),
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(
//                               fontSize: 20,
//                               color: bugetColor,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                     SizedBox(width: 15.0),
//                     Column(
//                       children: <Widget>[
//                         FlatButton.icon(
//                             onPressed: () {},
//                             icon: Icon(Icons.shopping_cart),
//                             label: Text("Total")),
//                         Text(
//                           utils.numberFormat(total),
//                           style: TextStyle(
//                               fontSize: 20,
//                               color: Color.fromRGBO(255, 111, 94, 1),
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                     Spacer(),
//                     Column(
//                       children: <Widget>[
//                         FlatButton.icon(
//                             onPressed: () {},
//                             icon: Icon(Icons.shuffle),
//                             label: Text("Diferencia")),
//                         Text(
//                           utils.numberFormat(diference),
//                           style: TextStyle(
//                               fontSize: 20,
//                               color: colorBuget,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                      SizedBox(width: 18.0),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//         body: Column(children:<Widget>[
//           Container(
//            // height: 250,
//             margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
//             child: Image(
//         image: AssetImage(
//             'assets/add_to_cart.png'),
//       height: 200.0,
//       fit: BoxFit.contain,
//       ),
//           ),
//            SizedBox(height: 35.0),
//             Text('No se ha agregado articulos a la lsita'),
//             SizedBox(height: 164.0),

//           _newProducto()
//         ]) );
