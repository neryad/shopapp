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
  final formKey = GlobalKey<FormState>();
  final editFormKey = GlobalKey<FormState>();
  Color colorBuget = Color.fromRGBO(255, 111, 94, 1);
  Color bugetColor = Color.fromRGBO(255, 111, 94, 1);
  var uuid = Uuid();
  // String bugetText = "Presupuesto";
  //TextEditingController _articlesCtrl = new TextEditingController();

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
  ProductModel productModel = new ProductModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
          iconTheme: new IconThemeData(color: Color.fromRGBO(255, 111, 94, 1)),
          backgroundColor: Colors.white,
          title: Text('Lista de compra',
              style: TextStyle(color: Color.fromRGBO(255, 111, 94, 1)))),
      body: Container(
          child: Column(
        children: <Widget>[
          _header(),
          _bodyWidget(),
        ],
      )),

      // Column(

      //   children: <Widget>[
      //     Expanded(
      //       child: ListView.builder(
      //         itemCount: items.length,
      //         itemBuilder: (BuildContext context, int index) {
      //           _controllers.add(new TextEditingController());

      //           return Dismissible(
      //             direction: DismissDirection.endToStart,
      //             background: Padding(
      //               padding: const EdgeInsets.all(8.0),
      //               child: Container(
      //                 color: Colors.red,
      //                 child: Align(
      //                   child: Row(
      //                     mainAxisAlignment: MainAxisAlignment.end,
      //                     children: <Widget>[
      //                       Icon(
      //                         Icons.delete,
      //                         color: Colors.white,
      //                       ),
      //                       Text(
      //                         " Eliminar",
      //                         style: TextStyle(
      //                           color: Colors.white,
      //                           fontWeight: FontWeight.w700,
      //                         ),
      //                         textAlign: TextAlign.right,
      //                       ),
      //                       SizedBox(
      //                         width: 20,
      //                       ),
      //                     ],
      //                   ),
      //                   alignment: Alignment.centerRight,
      //                 ),
      //               ),
      //             ),

      //             // background: Card(

      //             //   color: Colors.red,
      //             //   elevation: 4,
      //             //   margin: EdgeInsets.all(15),
      //             //   child: Icon(Icons.delete_forever, color: Colors.white,),
      //             // ),
      //             key: Key(items[index].name + items.length.toString()),
      //             // key: Key('items[index]'),
      //             //key: Key('items[index]'),
      //             // secondaryBackground: (
      //             //      Padding(
      //             //   padding: const EdgeInsets.all(8.0),
      //             //   child: Container(
      //             //     color: Colors.green,
      //             //     child: Align(
      //             //       child: Row(
      //             //         mainAxisAlignment: MainAxisAlignment.end,
      //             //         children: <Widget>[
      //             //           Icon(
      //             //             Icons.check,
      //             //             color: Colors.white,
      //             //           ),
      //             //           Text(
      //             //             " Completado",
      //             //             style: TextStyle(
      //             //               color: Colors.white,
      //             //               fontWeight: FontWeight.w700,
      //             //             ),
      //             //             textAlign: TextAlign.right,
      //             //           ),
      //             //           SizedBox(
      //             //             width: 20,
      //             //           ),
      //             //         ],
      //             //       ),
      //             //       alignment: Alignment.centerRight,
      //             //     ),
      //             //   ),

      //             // )),

      //             onDismissed: (direction) {
      //               // if(direction == DismissDirection.endToStart){
      //               //   print('Verder');
      //               // }
      //               // print(direction);
      //               //DismissDirection.endToStart azuel
      //               //DismissDirection.startToEnd rojhos

      //               // items.removeWhere((item) => item.id ==items[index].id);

      //               //items.removeWhere((item) => item.id == items[index].id);
      //               setState(() {
      //                 // var priceToDel = items[index].price;
      //                 items.removeAt(index);
      //                 // total = total - priceToDel;
      //                 getTotal();
      //                 getDiference();

      //                 //items.removeAt(index);
      //               });
      //               // setState(() {

      //               //   getTotal();
      //               // });

      //               //getTotal();
      //             },
      //             child: Card(
      //               elevation: 2,
      //               margin: EdgeInsets.all(10),
      //               child: Container(
      //                 padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      //                 height: 80.00,
      //                 child: Row(
      //                   //mainAxisAlignment: MainAxisAlignment.spaceAround,

      //                   children: <Widget>[
      //                     Expanded(
      //                       child: Column(children: <Widget>[
      //                         Container(
      //                           child: Row(children: <Widget>[
      //                             SizedBox(
      //                               width: 15,
      //                             ),
      //                             Text(
      //                               items[index].name,
      //                               style:
      //                                   TextStyle(fontWeight: FontWeight.w900),
      //                               textAlign: TextAlign.start,
      //                             ),
      //                           ]),
      //                         ),
      //                         Container(
      //                           child: Row(
      //                             children: <Widget>[
      //                               SizedBox(
      //                                 width: 15,
      //                               ),
      //                               Expanded(
      //                                 flex: 2,
      //                                 child: IconButton(
      //                                   icon: Icon(Icons.shopping_basket),
      //                                   color: Color.fromRGBO(255, 111, 94, 1),
      //                                   onPressed: () {
      //                                     _mostrarAlertaEditarProducto(
      //                                         context, index);
      //                                     setState(() {
      //                                       //_sumProduct(index);
      //                                     });
      //                                   },
      //                                 ),
      //                               ),
      //                               Expanded(
      //                                 flex: 2,
      //                                 child:
      //                                     //_creaPrecio(index)
      //                                     Text(utils.numberFormat(
      //                                         items[index].price)),
      //                               ),
      //                               SizedBox(
      //                                 width: 15,
      //                               ),
      //                               Expanded(
      //                                   flex: 2,
      //                                   child: Row(
      //                                     mainAxisAlignment:
      //                                         MainAxisAlignment.spaceBetween,
      //                                     children: <Widget>[
      //                                       Expanded(
      //                                         flex: 2,
      //                                         child: Text(
      //                                           items[index]
      //                                               .quantity
      //                                               .toString(),
      //                                           overflow: TextOverflow.ellipsis,
      //                                           textAlign: TextAlign.center,
      //                                         ),
      //                                       ),
      //                                     ],
      //                                   )),
      //                               SizedBox(
      //                                 width: 15,
      //                               ),
      //                               Expanded(
      //                                 flex: 3,
      //                                 child: Container(
      //                                   margin: EdgeInsets.symmetric(
      //                                     horizontal: 10,
      //                                   ),
      //                                   child: Text(
      //                                     utils.numberFormat(
      //                                       items[index].quantity *
      //                                           items[index].price,
      //                                     ),
      //                                     style: TextStyle(
      //                                         fontWeight: FontWeight.w600),
      //                                     //overflow: TextOverflow.ellipsis,
      //                                   ),
      //                                 ),
      //                               ),
      //                             ],
      //                           ),
      //                         )
      //                       ]),
      //                     )
      //                   ],
      //                 ),
      //               ),
      //             ),
      //           );
      //         },
      //       ),
      //     ),
      //     //_newProducto(),
      //   ],
      // ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          _mostrarAlertaProducto(context);
        },
        backgroundColor: Color.fromRGBO(255, 111, 94, 1),
        child: Icon(Icons.add_shopping_cart),
      ),

      // Here's the new attribute:

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // validconte() {
  //   if (items.length == 0) {
  //     return Text('nada');
  //   } else {
  //     return ('todo');
  //   }
  // }

  // _sumProduct(int index) {
  //   setState(() {
  //     items[index].quantity++;
  //     getTotal();
  //   });
  // }

  // _resProduct(int index) {
  //   setState(() {
  //     if (items[index].quantity == 0) {
  //       return;
  //     }
  //     items[index].quantity--;

  //     getTotal();
  //   });
  // }

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

  void _mostrarAlertaBuget(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(' Presupuesto'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _crearBuget(),
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

  void _mostrarAlertaProducto(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(' Nuevo artículo'),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Container(
                  //  height: MediaQuery.of(context).size.height / 4,
                  //width: MediaQuery.of(context).size.width / 1,
                  //color: Colors.red,

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _crearNombreArticulo(),
                      _crearPrecioArticulo(),
                      _crearcantidadArticulo(),
                    ],
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Salir')),
              FlatButton(
                  onPressed: () {
                    _subimt();
                    getTotal();
                    //Navigator.of(context).pop();
                  },
                  child: Text('Aceptar')),
            ],
          );
        });
  }

  Widget _crearNombreArticulo() {
    return TextFormField(
      //  initialValue: productModel.name,
      maxLength: 50,
      textCapitalization: TextCapitalization.sentences,
      textAlign: TextAlign.center,
      onSaved: (value) => productModel.name = value,
      decoration: InputDecoration(
        counterText: '',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(255, 111, 94, 1)),
        ),
        hintText: 'Nombre artículo',
        hintStyle: TextStyle(color: Color.fromRGBO(255, 111, 94, 1)),
      ),
    );
  }

  Widget _crearPrecioArticulo() {
    return TextFormField(
      //  initialValue: productModel.price.toString(),
      maxLength: 6,
      //controller: _controllers[index],
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: 'Precio',
        counterText: '',
        hintStyle: TextStyle(color: Color.fromRGBO(255, 111, 94, 1)),
      ),
      onSaved: (value) => productModel.price = double.parse(value),
      validator: (value) {
        if (utils.isNumeric(value)) {
          return null;
        } else {
          return 'Solo numeros';
        }
      },
      keyboardType: TextInputType.numberWithOptions(decimal: true),
    );
  }

  Widget _crearcantidadArticulo() {
    return TextFormField(
      // initialValue: productModel.quantity.toString(),
      maxLength: 6,
      //controller: _controllers[index],
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: 'Cantidad',
        counterText: '',
        hintStyle: TextStyle(color: Color.fromRGBO(255, 111, 94, 1)),
      ),
      onSaved: (value) => productModel.quantity = int.parse(value),
      validator: (value) {
        if (utils.isNumeric(value)) {
          return null;
        } else {
          return 'Solo numeros';
        }
      },
      keyboardType: TextInputType.numberWithOptions(decimal: true),
    );
  }

  void _subimt() {
    var newId = uuid.v1();
    var it = items.length;

    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();
    items.insert(
        it,
        new ProductModel(
            id: newId,
            name: productModel.name,
            quantity: productModel.quantity,
            price: productModel.price));
    formKey.currentState.reset();
  }

  void _mostrarAlertaEditarProducto(BuildContext context, int index) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(' Nuevo artículo'),
            content: Form(
              key: editFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _editarNombreArticulo(index),
                  _editarPrecioArticulo(index),
                  _editarcantidadArticulo(index),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Salir')),
              FlatButton(
                  onPressed: () {
                    //_subimt();
                    _editDubimt(index);
                    getTotal();
                    Navigator.of(context).pop();
                  },
                  child: Text('Aceptar')),
            ],
          );
        });
  }

  void _editDubimt(int index) {
    editFormKey.currentState.save();
  }

  Widget _editarNombreArticulo(int index) {
    return TextFormField(
      initialValue: items[index].name,
      maxLength: 50,
      textCapitalization: TextCapitalization.sentences,
      textAlign: TextAlign.center,
      onSaved: (value) => items[index].name = value,
      decoration: InputDecoration(
        counterText: '',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(255, 111, 94, 1)),
        ),
        hintText: 'Nombre artículo',
        hintStyle: TextStyle(color: Color.fromRGBO(255, 111, 94, 1)),
      ),
    );
  }

  Widget _editarPrecioArticulo(int index) {
    return TextFormField(
      initialValue: items[index].price.toString(),
      maxLength: 6,
      //controller: _controllers[index],
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: 'Precio',
        counterText: '',
        hintStyle: TextStyle(color: Color.fromRGBO(255, 111, 94, 1)),
      ),
      onSaved: (value) => items[index].price = double.parse(value),
      validator: (value) {
        if (utils.isNumeric(value)) {
          return null;
        } else {
          return 'Solo numeros';
        }
      },
      keyboardType: TextInputType.numberWithOptions(decimal: true),
    );
  }

  Widget _editarcantidadArticulo(int index) {
    return TextFormField(
      initialValue: items[index].quantity.toString(),
      maxLength: 6,
      //controller: _controllers[index],
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: 'Cantidad',
        counterText: '',
        hintStyle: TextStyle(color: Color.fromRGBO(255, 111, 94, 1)),
      ),
      onSaved: (value) => items[index].quantity = int.parse(value),
      validator: (value) {
        if (utils.isNumeric(value)) {
          return null;
        } else {
          return 'Solo numeros';
        }
      },
      keyboardType: TextInputType.numberWithOptions(decimal: true),
    );
  }

  Widget _crearBuget() {
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

  Widget _header() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Container(
        // margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.account_balance_wallet,
                          color: Colors.black,
                        ),
                        onPressed: () => _mostrarAlertaBuget(context)),
                    Text("Presupuesto", overflow: TextOverflow.ellipsis)
                  ],
                ),
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
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 20,
                      color: colorBuget,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _bodyWidget() {
    var width = MediaQuery.of(context).size.width;

    if (items.length == 0) {
      return Card(
          child: Container(
        // padding: EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage('assets/add_to_cart.png'),
              height: 240.00,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ));
      //Image(image: AssetImage("assets/add_to_cart.png") , height: 250,);
      //Image(image: AssetImage("assets/add_to_cart.png"),);
    }
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(color: Colors.black12, spreadRadius: 5, blurRadius: 2)
          ]),
          height: 100,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Container(
              // margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          IconButton(
                              icon: Icon(
                                Icons.account_balance_wallet,
                                color: Colors.black,
                              ),
                              onPressed: () => _mostrarAlertaBuget(context)),
                          Text("Presupuesto", overflow: TextOverflow.ellipsis)
                        ],
                      ),
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
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 20,
                            color: colorBuget,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              _controllers.add(new TextEditingController());

              return Dismissible(
                direction: DismissDirection.endToStart,
                background: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Colors.red,
                    child: Align(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
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

                  // items.removeWhere((item) => item.id ==items[index].id);

                  //items.removeWhere((item) => item.id == items[index].id);
                  setState(() {
                    // var priceToDel = items[index].price;
                    items.removeAt(index);
                    // total = total - priceToDel;
                    getTotal();
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
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    height: 80.00,
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceAround,

                      children: <Widget>[
                        Expanded(
                          child: Column(children: <Widget>[
                            Container(
                              child: Row(children: <Widget>[
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  items[index].name,
                                  style: TextStyle(fontWeight: FontWeight.w900),
                                  textAlign: TextAlign.start,
                                ),
                              ]),
                            ),
                            Container(
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: IconButton(
                                      icon: Icon(Icons.shopping_basket),
                                      color: Color.fromRGBO(255, 111, 94, 1),
                                      onPressed: () {
                                        _mostrarAlertaEditarProducto(
                                            context, index);
                                        setState(() {
                                          //_sumProduct(index);
                                        });
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child:
                                        //_creaPrecio(index)
                                        Text(utils
                                            .numberFormat(items[index].price)),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                      flex: 2,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              items[index].quantity.toString(),
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
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
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
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
        //_newProducto(),
      ],
    );
  }
  // Widget _newProducto() {
  //   var it = items.length;
  //   return Container(
  //       color: Colors.white60,
  //       child: Column(
  //         children: <Widget>[
  //           TextField(
  //             maxLength: 50,
  //             textCapitalization: TextCapitalization.sentences,
  //             textAlign: TextAlign.center,
  //             controller: _articlesCtrl,
  //             onSubmitted: (text) {
  //               if (text == '') {
  //                 return;
  //               }
  //               // insertar(it,text);
  //               var newId = uuid.v1();
  //               items.insert(
  //                   it,
  //                   new ProductModel(
  //                      name: text, quantity: 1, price: 0.00));
  //               _articlesCtrl.clear();
  //               setState(() {});
  //             },
  //             decoration: InputDecoration(
  //               counterText: '',
  //               focusedBorder: UnderlineInputBorder(
  //                 borderSide:
  //                     BorderSide(color: Color.fromRGBO(255, 111, 94, 1)),
  //               ),
  //               hintText: 'Nombre artículo',
  //               hintStyle: TextStyle(color: Color.fromRGBO(255, 111, 94, 1)),
  //             ),
  //           ),
  //         ],
  //       ));
  // }
}

// ListView.builder(
//               itemCount: items.length,
//               itemBuilder: (BuildContext context, int index) {
//                 _controllers.add(new TextEditingController());
//                 return Dismissible(
//                   direction: DismissDirection.endToStart,
//                   background: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Container(
//                       color: Colors.red,
//                       child: Align(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: <Widget>[
//                             Icon(
//                               Icons.delete,
//                               color: Colors.white,
//                             ),
//                             Text(
//                               " Eliminar",
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                               textAlign: TextAlign.right,
//                             ),
//                             SizedBox(
//                               width: 20,
//                             ),
//                           ],
//                         ),
//                         alignment: Alignment.centerRight,
//                       ),
//                     ),
//                   ),

//                   // background: Card(

//                   //   color: Colors.red,
//                   //   elevation: 4,
//                   //   margin: EdgeInsets.all(15),
//                   //   child: Icon(Icons.delete_forever, color: Colors.white,),
//                   // ),
//                   key: Key(items[index].name + items.length.toString()),
//                   // key: Key('items[index]'),
//                   //key: Key('items[index]'),
//                   // secondaryBackground: (
//                   //      Padding(
//                   //   padding: const EdgeInsets.all(8.0),
//                   //   child: Container(
//                   //     color: Colors.green,
//                   //     child: Align(
//                   //       child: Row(
//                   //         mainAxisAlignment: MainAxisAlignment.end,
//                   //         children: <Widget>[
//                   //           Icon(
//                   //             Icons.check,
//                   //             color: Colors.white,
//                   //           ),
//                   //           Text(
//                   //             " Completado",
//                   //             style: TextStyle(
//                   //               color: Colors.white,
//                   //               fontWeight: FontWeight.w700,
//                   //             ),
//                   //             textAlign: TextAlign.right,
//                   //           ),
//                   //           SizedBox(
//                   //             width: 20,
//                   //           ),
//                   //         ],
//                   //       ),
//                   //       alignment: Alignment.centerRight,
//                   //     ),
//                   //   ),

//                   // )),

//                   onDismissed: (direction) {
//                     // if(direction == DismissDirection.endToStart){
//                     //   print('Verder');
//                     // }
//                     // print(direction);
//                     //DismissDirection.endToStart azuel
//                     //DismissDirection.startToEnd rojhos

//                     var priceToDel = items[index].price;
//                     // items.removeWhere((item) => item.id ==items[index].id);

//                     //items.removeWhere((item) => item.id == items[index].id);
//                     setState(() {
//                       items.removeAt(index);
//                       total = total - priceToDel;
//                       getDiference();

//                       //items.removeAt(index);
//                     });
//                     // setState(() {

//                     //   getTotal();
//                     // });

//                     //getTotal();
//                   },
//                   child: Card(
//                     elevation: 2,
//                     margin: EdgeInsets.all(10),
//                     child: Container(
//                       padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//                       height: 80.00,
//                       child: Row(
//                         //mainAxisAlignment: MainAxisAlignment.spaceAround,

//                         children: <Widget>[
//                           Expanded(
//                             child: Column(children: <Widget>[
//                               Container(
//                                 child: Row(children: <Widget>[
//                                   SizedBox(
//                                     width: 15,
//                                   ),
//                                   Text(
//                                     items[index].name,
//                                     style:
//                                         TextStyle(fontWeight: FontWeight.w900),
//                                     textAlign: TextAlign.start,
//                                   ),
//                                 ]),
//                               ),
//                               Container(
//                                 child: Row(
//                                   children: <Widget>[
//                                     SizedBox(
//                                       width: 15,
//                                     ),
//                                     Expanded(
//                                       flex: 3,
//                                       child:
//                                           //_creaPrecio(index)
//                                           TextField(
//                                         maxLength: 6,
//                                         controller: _controllers[index],
//                                         textAlign: TextAlign.center,
//                                         decoration: InputDecoration(
//                                             hintText: '0.0', counterText: ''),
//                                         keyboardType:
//                                             TextInputType.numberWithOptions(
//                                                 decimal: true),
//                                         onChanged: (text) {
//                                           items[index].price =
//                                               num.parse(text).toDouble();
//                                           setState(() {
//                                             getTotal();
//                                           });
//                                         },
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       width: 15,
//                                     ),
//                                     Expanded(
//                                         flex: 5,
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: <Widget>[
//                                             Expanded(
//                                               flex: 2,
//                                               child: IconButton(
//                                                 icon: Icon(Icons.add),
//                                                 color: Color.fromRGBO(
//                                                     255, 111, 94, 1),
//                                                 onPressed: () {
//                                                   setState(() {
//                                                     _sumProduct(index);
//                                                   });
//                                                 },
//                                               ),
//                                             ),
//                                             Expanded(
//                                               flex: 2,
//                                               child: Text(
//                                                 items[index]
//                                                     .quantity
//                                                     .toString(),
//                                                 overflow: TextOverflow.ellipsis,
//                                                 textAlign: TextAlign.center,
//                                               ),
//                                             ),
//                                             Expanded(
//                                               flex: 2,
//                                               child: IconButton(
//                                                 icon: Icon(Icons.remove),
//                                                 color: Color.fromRGBO(
//                                                     255, 111, 94, 1),
//                                                 onPressed: () {
//                                                   setState(() {
//                                                     _resProduct(index);
//                                                   });
//                                                 },
//                                               ),
//                                             ),
//                                           ],
//                                         )),
//                                     SizedBox(
//                                       width: 15,
//                                     ),
//                                     Expanded(
//                                       flex: 3,
//                                       child: Container(
//                                         margin: EdgeInsets.symmetric(
//                                           horizontal: 10,
//                                         ),
//                                         child: Text(
//                                           utils.numberFormat(
//                                             items[index].quantity *
//                                                 items[index].price,
//                                           ),
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.w600),
//                                           //overflow: TextOverflow.ellipsis,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               )
//                             ]),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
