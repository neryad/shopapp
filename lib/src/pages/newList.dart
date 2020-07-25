import 'package:flutter/material.dart';
import 'package:shopapp/src/models/List_model.dart';
import 'package:shopapp/src/models/product_model.dart';
//import 'package:shopapp/src/pages/home_page.dart';
import 'package:shopapp/src/providers/db_provider.dart';
import 'package:shopapp/src/utils/utils.dart' as utils;
import 'package:shopapp/src/widgets/Menu_widget.dart';
import 'package:uuid/uuid.dart';
//import 'package:shopapp/src/Shared_Prefs/Prefrecias_user.dart' as wawa;

class NewList extends StatefulWidget {
  NewList({Key key}) : super(key: key);

  @override
  _NewListState createState() => _NewListState();
}

class _NewListState extends State<NewList> {
  double buget = 00.00;
  double total = 0.00;
  double diference = 0.00;
  bool checkValue = false;

  final formKey = GlobalKey<FormState>();
  final editFormKey = GlobalKey<FormState>();
  final lisForm = GlobalKey<FormState>();

  Color colorBuget = utils.cambiarColor();
  Color bugetColor = utils.cambiarColor();

  var uuid = Uuid();

  List<ProductModel> items = [];

  //List<ProductModel> itemsTemp =  utils.prefs.read("TempPro");
  List<TextEditingController> _controllers = new List();
  ProductModel productModel = new ProductModel();
  Lista listaModel = new Lista();

  //       loadSharedPrefs() async {
  //         try {
  //            ProductModel user =  ProductModel.fromJson(await utils.prefs.read("user"));
  //           print("object");
  //         } catch (e) {
  //           print('algun jodido error');
  //         }
  //   // try {
  //   //    ProductModel user =  ProductModel.fromJson(await utils.prefs.read("user"));
  //   //   Scaffold.of(context).showSnackBar(SnackBar(
  //   //       content: new Text("Loaded!"),
  //   //       duration: const Duration(milliseconds: 500)));
  //   //   setState(() {
  //   //     //userLoad = user;
  //   //     print("object");
  //   //   });
  //   // } catch (Excepetion) {
  //   //   Scaffold.of(context).showSnackBar(SnackBar(
  //   //       content: new Text("Nothing found!"),
  //   //       duration: const Duration(milliseconds: 500)));
  //   // }

  // }

  // loadSharedPrefs() async {
  //   try {

  //     Scaffold.of(context).showSnackBar(SnackBar(
  //         content: new Text("Loaded!"),
  //         duration: const Duration(milliseconds: 500)));
  //     setState(() {
  //       itemsTemp = user;
  //     });
  //   } catch (Excepetion) {
  //     Scaffold.of(context).showSnackBar(SnackBar(
  //         content: new Text("Nothing found!"),
  //         duration: const Duration(milliseconds: 500)));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    //loadSharedPrefs();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
          //iconTheme: new IconThemeData(color: Color.fromRGBO(255, 111, 94, 1)),
          backgroundColor: utils.cambiarColor(),
          title: Text(
            'Lista de compra',
            // style: TextStyle(color: Color.fromRGBO(255, 111, 94, 1)
            // ),
          )),
      drawer: MenuWidget(),
      body: Column(
        children: <Widget>[
          _header(),
          _bodyWidget(),
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          _mostrarAlertaProducto(context);
        },
        backgroundColor: utils.cambiarColor(),
        child: Icon(Icons.add_shopping_cart),
      ),

      // Here's the new attribute:

      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: _bNavbar(context),
    );
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
            // bugetColor = Color.fromRGBO(255, 111, 94, 1);
            bugetColor = utils.cambiarColor();
          }
        });
      }
    }
  }

  void getDiference() {
    if (total == 0) {
      diference = buget;
      //colorBuget = colorBuget = Colors.green[400];
      return;
    }
    double calDiferecen = buget - total;
    if (calDiferecen < 0) {
      colorBuget = Colors.red[900];
    } else if (calDiferecen >= 0) {
      colorBuget = utils.cambiarColor();
    } else {
      colorBuget = utils.cambiarColor();
    }
    // else {
    //   colorBuget = Colors.green[400];
    // }
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
                  child: Text(
                    'Cancelar',
                    style: TextStyle(color: utils.cambiarColor()),
                  )),
              FlatButton(
                  onPressed: () {
                    getTotal();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Aceptar',
                    style: TextStyle(color: utils.cambiarColor()),
                  )),
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
                      _crearcantidadArticulo(),
                      _crearPrecioArticulo(),
                    ],
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Salir',
                    style: TextStyle(color: utils.cambiarColor()),
                  )),
              FlatButton(
                  onPressed: () {
                    _subimt();
                    getTotal();
                    //Navigator.of(context).pop();
                  },
                  child: Text(
                    'Aceptar',
                    style: TextStyle(color: utils.cambiarColor()),
                  )),
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
          borderSide: BorderSide(color: utils.cambiarColor()),
        ),
        hintText: 'Nombre artículo',
        hintStyle: TextStyle(color: utils.cambiarColor()),
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
        hintStyle: TextStyle(color: utils.cambiarColor()),
      ),
      onSaved: (value) => productModel.price = double.parse(value),
      validator: (value) {
        if (utils.isNumeric(value)) {
          return null;
        } else {
          return 'Completar campos';
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
        hintStyle: TextStyle(color: utils.cambiarColor()),
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
    // var newId = uuid.v1();
    var it = items.length;

    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();
    var prod = new ProductModel(
        name: productModel.name,
        quantity: productModel.quantity,
        listId: 1,
        price: productModel.price,
        complete: false);
    items.insert(it, prod);
    //utils.prefs.save("TempPro", prod);
    DBProvider.db.tmpProd(prod);
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
                  child: Text(
                    'Salir',
                    style: TextStyle(color: utils.cambiarColor()),
                  )),
              FlatButton(
                  onPressed: () {
                    //_subimt();
                    _editDubimt(index);
                    getTotal();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Aceptar',
                    style: TextStyle(color: utils.cambiarColor()),
                  )),
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
          borderSide: BorderSide(color: utils.cambiarColor()),
        ),
        hintText: 'Nombre artículo',
        hintStyle: TextStyle(color: utils.cambiarColor()),
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
        hintStyle: TextStyle(color: utils.cambiarColor()),
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
        hintStyle: TextStyle(color: utils.cambiarColor()),
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

  Widget _nombrelista() {
    //weo
    return TextFormField(
      //  initialValue: productModel.name,
      maxLength: 25,
      textCapitalization: TextCapitalization.sentences,
      textAlign: TextAlign.center,
      onSaved: (value) => listaModel.title = value,
      decoration: InputDecoration(
        //counterText: '',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: utils.cambiarColor()),
        ),
        hintText: 'Nombre lista',
        hintStyle: TextStyle(color: utils.cambiarColor()),
      ),
    );
  }

  Widget _nombresupermeacdo() {
    return TextFormField(
      //  initialValue: productModel.name,
      maxLength: 20,
      textCapitalization: TextCapitalization.sentences,
      textAlign: TextAlign.center,
      onSaved: (value) => listaModel.superMaret = value,
      decoration: InputDecoration(
        // counterText: '',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: utils.cambiarColor()),
        ),
        hintText: 'Nombre localidad',
        hintStyle: TextStyle(color: utils.cambiarColor()),
      ),
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
          color: utils.cambiarColor(),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: utils.cambiarColor()),
        ),
      ),
      onChanged: (value) {
        setState(() {});
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
        padding: EdgeInsets.all(5),
        // margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                _mostrarAlertaBuget(context);
              },
              child: Column(
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
                      Text(
                        "Presupuesto",
                        overflow: TextOverflow.ellipsis,
                      )
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
                      color: utils.cambiarColor(),
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
    return FutureBuilder<List<ProductModel>>(
        // builder: null
        future: DBProvider.db.getTmpArticulos(),
        builder: (context, AsyncSnapshot<List<ProductModel>> snapshot) {
          if (snapshot.hasData && snapshot.data.length > 0) {
            // print('Data ====> ${snapshot.data}');
            final mmg = snapshot.data;

            items = mmg;
            // print('Data ====> $items.name');
          }
          // print('Data ====>2 ${snapshot.data}');
          if (items.length == 0) {
            // print(tempPro);
            return Card(
                child: Column(
                    // padding: EdgeInsets.all(15.0),
                    children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      utils.cambiarNewImage(),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'No se han agregado articulos a la lista',
                      style: TextStyle(
                        color: utils.cambiarColor(),
                        fontSize: 18,
                      ),
                    ),
                  )
                ]));
          }

          items.sort((a, b) => a.name.compareTo(b.name));

           

          return Expanded(
              child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              _controllers.add(new TextEditingController());
 //var wawa = toBoolean(items[index].complete);
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
                            "Eliminar",
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
                key: Key(items[index].name + items.length.toString()),
                onDismissed: (direction) {
                  DBProvider.db.deleteTmpProd(items[index].id);
                  items.removeAt(index);
                  getTotal();
                  getDiference();

                  // setState(() {
                  //   items.removeAt(index);

                  //  // DBProvider.db.deleteTmpProd(items[index].id);
                  //   getTotal();
                  //   getDiference();
                  // });
                },
                child: Container(
                  child: Card(
                      child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 2.5, bottom: 2.5),
                          child: Row(
                            children: <Widget>[
                              Text(
                                items[index].name,
                                style: TextStyle(fontWeight: FontWeight.w900),
                                textAlign: TextAlign.start,
                              ),
                              Spacer(),
                              Checkbox(value:items[index].complete , onChanged: (valor) {
                                  items[index].complete = valor;
                                  setState(() {
                                    
                                  });
                                 // onTaskToggled(index, valor);
                                // items[index].complete = valor.toString();
                              
                                // wawa = toBoolean(items[index].complete);
                                // //checkValue = toBoolean(items[index].complete );
                                // //checkValue = items[index].complete;
                                // items[index].complete = wawa.toString();
                                // print( wawa);
                                // if(items[index].complete == 'true'){
                                  
                                //}
                                // if(valor == true){
                                //   isComplete(index);
                                //   checkValue = valor;
                                //   bool.parse(items[index].);
                                // }
                                // print(valor);
                                // (valor == true) ? 1 : 0;

                                // items[index].complete =  (valor == true) ? 1 : 0;
                                // checkValue = valor;
                                // if(checkValue){
                                //   items[index].complete = 1;
                                // }
                                // var mmg = isComplete(index);
                                // isComplete(index);
                                //items[index].complete = valor.toString();
                                // setState(() {
                                  
                                // });
                              }, activeColor: utils.cambiarColor(),)
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                    _mostrarAlertaEditarProducto(context, index);
                  },
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 2.5, bottom: 2.5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                
                                Icon(Icons.shopping_basket),
                                Text(utils.numberFormat(items[index].price)),
                                Text(items[index].quantity.toString()),
                                Text(utils.numberFormat(
                                  items[index].quantity * items[index].price,
                                )),
                                //Spacer(),
                                
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
                ),
              );
            },
          ));
        });
    // loadSharedPrefs();
    //  List<ProductModel> papa = DBProvider.db.getarticulos(1);
    // items = papa;
    //  print('data ==> ${papa}');
    //     utils.prefs.read("TempPro");
    // List<ProductModel> list2 =  papa.map((l) => ProductModel.fromJson(l)).toList();
    // print('data ==> ${papa}');
    //var width = MediaQuery.of(context).size.width;
    // var tempPro = utils.prefs.read("TempPro");
    // if (items.length == 0) {
    // // print(tempPro);
    //   return Card(
    //       child: Column(
    //           // padding: EdgeInsets.all(15.0),
    //           children: <Widget>[
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: <Widget>[
    //             utils.cambiarNewImage(),
    //           ],
    //         ),
    //         Padding(
    //           padding: const EdgeInsets.all(5.0),
    //           child: Text(
    //             'No se han agregado articulos a la lista',
    //             style: TextStyle(
    //               color: utils.cambiarColor(),
    //               fontSize: 18,
    //             ),
    //           ),
    //         )
    //       ]));

    // }
    //items = DBProvider.db.getarticulos(1);
    // if( items.length == 0 && itemsTemp.length > 0  ) {
    //   print('itemsTemp => ${itemsTemp}');
    //   //items = itemsTemp;
    // }

    //items = itemsTemp;
    //   items.sort((a, b) => a.name.compareTo(b.name));
    // var tempPro = utils.prefs.read("TempPro");
    // print(tempPro);
    // return Expanded(
    //   child:  ListView.builder(
    //       itemCount: items.length,
    //       itemBuilder: (BuildContext context, int index) {
    //         _controllers.add(new TextEditingController());

    //         return Dismissible(
    //           direction: DismissDirection.endToStart,
    //           background: Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child: Container(
    //               color: Colors.red,
    //               child: Align(
    //                 child: Row(
    //                   mainAxisAlignment: MainAxisAlignment.end,
    //                   children: <Widget>[
    //                     Icon(
    //                       Icons.delete,
    //                       color: Colors.white,
    //                     ),
    //                     Text(
    //                       "Eliminar",
    //                       style: TextStyle(
    //                         color: Colors.white,
    //                         fontWeight: FontWeight.w700,
    //                       ),
    //                       textAlign: TextAlign.right,
    //                     ),
    //                     SizedBox(
    //                       width: 20,
    //                     ),
    //                   ],
    //                 ),
    //                 alignment: Alignment.centerRight,
    //               ),
    //             ),
    //           ),
    //           key: Key(items[index].name + items.length.toString()),
    //           onDismissed: (direction) {
    //             setState(() {
    //               items.removeAt(index);
    //               getTotal();
    //               getDiference();
    //             });
    //           },
    //           child: GestureDetector(
    //             onTap: () {
    //               _mostrarAlertaEditarProducto(context, index);
    //             },
    //             child: Card(
    //               elevation: 2,
    //               margin: EdgeInsets.all(10),
    //               child: Container(
    //                 // padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
    //                 height: 100.00,
    //                 child: Row(
    //                   //mainAxisAlignment: MainAxisAlignment.spaceAround,

    //                   children: <Widget>[
    //                     Expanded(
    //                       child: Column(children: <Widget>[
    //                         Container(
    //                           child: Row(
    //                               mainAxisAlignment:
    //                                   MainAxisAlignment.spaceBetween,
    //                               children: <Widget>[
    //                                 SizedBox(
    //                                   width: 15,
    //                                 ),
    //                                 Expanded(
    //                                   child: Text(
    //                                     items[index].name,
    //                                     style: TextStyle(
    //                                         fontWeight: FontWeight.w900),
    //                                     textAlign: TextAlign.start,
    //                                   ),
    //                                 ),
    //                                 // Checkbox(
    //                                 //     activeColor: utils.cambiarColor(),
    //                                 //     value: items[index].complete,
    //                                 //     onChanged: (valor) {
    //                                 //       items[index].complete = valor;
    //                                 //       setState(() {});
    //                                 //     }),
    //                                 SizedBox(
    //                                   width: 15,
    //                                 ),
    //                               ]),
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
    //                                   color: utils.cambiarColor(),
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
    //                                     Text(utils
    //                                         .numberFormat(items[index].price)),
    //                               ),
    //                               SizedBox(
    //                                 width: 15,
    //                               ),
    //                               Expanded(
    //                                   flex: 1,
    //                                   child: Row(
    //                                     mainAxisAlignment:
    //                                         MainAxisAlignment.spaceBetween,
    //                                     children: <Widget>[
    //                                       Expanded(
    //                                         flex: 2,
    //                                         child: Text(
    //                                           items[index].quantity.toString(),
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
    //           ),
    //         );
    //       },
    // ));
  }

  Widget _bNavbar(BuildContext context) {
    return BottomAppBar(
        child: new Row(
      // mainAxisSize: MainAxisSize.max,
      // mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        FlatButton(
          //onPressed: () => _guardarLista(context),   _validateEliminarList(context);
          //onPressed: items.length == 0 ? null : () => _guardarLista(context),
          onPressed: () => _guardarLista(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[Icon(Icons.save), Text('Guardar lista')],
          ),
        ),
        FlatButton(
          //onPressed: items.length == 0 ? null : () => _validateEliminarList(context),
          onPressed: () => _validateEliminarList(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(Icons.remove_circle_outline),
              Text('Limpiar lista')
            ],
          ),
        ),
      ],
    ));
  }

  _validateEliminarList(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('Eliminar contenido'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Salir',
                    style: TextStyle(color: utils.cambiarColor()),
                  )),
              FlatButton(
                  onPressed: () => limpiarTodo(),
                  child: Text(
                    'Aceptar',
                    style: TextStyle(color: utils.cambiarColor()),
                  )),
            ],
          );
        });
  }

  // borrarmmg(int index){
  //   print(items[index].id);
  //   print(items[index].name);
  //     // DBProvider.db.deleteTmpProd(items[index].id);
  // }

  limpiarTodo() {
    //    DBProvider.db.deleteAllTempProd();
    // items.clear();

    setState(() {
      DBProvider.db.deleteAllTempProd();
      items.clear();
      getTotal();
      getDiference();
    });
    Navigator.of(context).pop();
  }

  saveList() {
    DBProvider.db.deleteAllTempProd();
    //if (!formKey.currentState.validate()) return;
    lisForm.currentState.save();
    //  var it = items.length;

    // items.insert(it, prod);
    DateTime now = new DateTime.now();
    var fecha = '${now.day}/${now.month}/${now.year}';
    final nuevaLista = Lista(
        title: listaModel.title,
        superMaret: listaModel.superMaret,
        fecha: fecha,
        total: total);
    DBProvider.db.nuevoLista(nuevaLista);
    var prod = new ProductModel(
        name: productModel.name,
        quantity: productModel.quantity,
        listId: nuevaLista.id,
        price: productModel.price);

    DBProvider.db.newProd(prod);

    items = [];
    lisForm.currentState.reset();
  }

  void _guardarLista(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('Guardar lista'),
            content: Form(
              key: lisForm,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[_nombrelista(), _nombresupermeacdo()],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Salir',
                    style: TextStyle(color: utils.cambiarColor()),
                  )),
              FlatButton(
                  onPressed: () {
                    //  DBProvider.db.getTmpArticulos();

                    saveList();
                    Navigator.pushNamed(context, 'home');
                    // setState(() {

                    // });
                  },
                  child: Text(
                    'Aceptar',
                    style: TextStyle(color: utils.cambiarColor()),
                  )),
            ],
          );
        });
  }

  bool toBoolean(String str, [bool strict]) {
  if (strict == true) {
    return str == '1' || str == 'true';
  }
  return str != '0' && str != 'false' && str != '';
}
//  void onTaskToggled(int index, bool valor) {
//     setState(() {
//       items[index].complete = valor.toString();
//       print(items[index].complete);
//     });
//   }
  // isComplete(int valor) {
  //  // (items[valor].complete == 1)? true : false;
  //   if( items[valor].complete <= 0 ) {
  //     return checkValue;
  //   } 
  //   items[valor].complete = 1;
  //   checkValue = true;
  //   return true;
  // }
}
