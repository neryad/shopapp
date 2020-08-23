//import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:shopapp/src/localization/localization_constant.dart';
//import 'package:shopapp/src/data/data.dart';
import 'package:shopapp/src/models/List_model.dart';
import 'package:shopapp/src/models/product_model.dart';
import 'package:shopapp/src/models/suge.dart';
import 'package:shopapp/src/providers/db_provider.dart';
import 'package:shopapp/src/utils/utils.dart' as utils;
import 'package:shopapp/src/widgets/Menu_widget.dart';
//import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:shopapp/src/data/data.dart';

class DetailsPage extends StatefulWidget {
  final Lista savelist;
  DetailsPage({Key key, this.savelist}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

// void _loadData() async {
//   await BackendService.getSuggestions();
// }
class _DetailsPageState extends State<DetailsPage> {
  @override
  void initState() {
    //_loadData();
    super.initState();
  }

  double buget;
  double total;
  double diference;
  Color colorBuget = utils.cambiarColor();
  Color bugetColor = utils.cambiarColor();
  final editFormKey = GlobalKey<FormState>();
  final formKey = GlobalKey<FormState>();
  //GlobalKey<AutoCompleteTextFieldState<Segurencia>> keyS = new GlobalKey();
  // final TextEditingController _typeAheadController = TextEditingController();
  ProductModel productModel = new ProductModel();
  //@override
  List<ProductModel> articulos = [];
  List<Segurencia> segerecias3 = [];

  Widget build(BuildContext context) {
    // Lista listaModel = widget.savelist;
    Lista listaModel = widget.savelist;
    //buget = listaModel.total;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
          backgroundColor: utils.cambiarColor(),
          title: Text(
            listaModel.title,
          )),
      drawer: MenuWidget(),
      body: Column(
        children: <Widget>[
          _header(listaModel.total, listaModel.buget, listaModel.diference,
              listaModel),
          _bodyWidget(listaModel.id, listaModel)
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          _mostrarAlertaProducto(context, listaModel);
        },
        backgroundColor: utils.cambiarColor(),
        child: Icon(Icons.add_shopping_cart),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // bottomNavigationBar: _bNavbar(context, listaModel),
    );
  }

  Widget _header(double total, double buget, double diference, Lista list) {
    return Container(
      padding: EdgeInsets.only(left: 5.0, right: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              child: Column(
                children: <Widget>[
                               GestureDetector(
                    onTap: () => _mostrarAlertaBuget(context,list),
                    child: Container(
                      color: Colors.white,
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Column(
                            
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FlatButton.icon(
                                  onPressed: () => _mostrarAlertaBuget(context,list),
                                  icon: Icon(Icons.account_balance_wallet),
                                  label: Text(getTranlated(context, 'buget'))),
                            ],
                          ),
                          Spacer(),
                          Column(
                            children: <Widget>[
                              Text(
                                utils.numberFormat(buget),
                                style: TextStyle(
                                    fontSize: 18,
                                    color: bugetColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          FlatButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.shopping_cart),
                              label: Text("Total")),
                        ],
                      ),
                      Spacer(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            utils.numberFormat(total),
                            style: TextStyle(
                                fontSize: 18,
                                color: utils.cambiarColor(),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  ),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      FlatButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.shuffle),
                          label: Text(getTranlated(context, 'difference'))),
                      Spacer(),
                      Text(
                        utils.numberFormat(diference),
                        style: TextStyle(
                            fontSize: 18,
                            color: bugetColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _bodyWidget(String id, Lista listaArt) {
    return FutureBuilder<List<ProductModel>>(
        // builder: null
        future: DBProvider.db.getprodId(id),
        builder: (context, AsyncSnapshot<List<ProductModel>> snapshot) {
          if (snapshot.hasData && snapshot.data.length > 0) {
            final art = snapshot.data;

            articulos = art;
          }

          articulos.sort((a, b) => a.name.compareTo(b.name));

          return Expanded(
              child: ListView.builder(
            itemCount: articulos.length,
            itemBuilder: (BuildContext context, int index) {
              //_controllers.add(new TextEditingController());
              //var wawa = toBoolean(articulos[index].complete);
              bool isComplete = (articulos[index].complete == 1) ? true : false;

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
                            getTranlated(context, 'delete'),
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
                key: Key(articulos[index].name + articulos.length.toString()),
                onDismissed: (direction) {
                  var deletedItem = articulos[index];
                  showDeleteSnack(context, getTranlated(context, 'offLis'), index, deletedItem, articulos);
                  //utils.showSnack(context, getTranlated(context, 'offLis'));
                  DBProvider.db.deleteProd(articulos[index].id);
                  articulos.removeAt(index);

                  getTotal(listaArt);
                  getDiference(listaArt);
                  _updataLista(listaArt);
                  setState(() {});
                },
                child: Container(
                  child: Card(
                      child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            articulos[index].name,
                            style: TextStyle(fontWeight: FontWeight.w900),
                            textAlign: TextAlign.start,
                          ),
                          Spacer(),
                          Checkbox(
                            value: isComplete,
                            onChanged: (valor) {
                              int complValue = (valor == true) ? 1 : 0;
                              articulos[index].complete = complValue;
                              DBProvider.db.updateProd(articulos[index]);
                              setState(() {});

                              (valor == true)
                                  ? utils.showSnack(
                                      context, getTranlated(context, 'onCart'))
                                  : utils.showSnack(context,
                                      getTranlated(context, 'ofCart')); //   showSnack(context, 'Artículo agregado');
                            },
                            activeColor: utils.cambiarColor(),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0, bottom: 5),
                        child: GestureDetector(
                          onTap: () {
                            _mostrarAlertaEditarProducto(
                                context, index, listaArt);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  _mostrarAlertaEditarProducto(
                                      context, index, listaArt);
                                },
                                child: Icon(
                                  Icons.shopping_basket,
                                  color: utils.cambiarColor(),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _mostrarAlertaEditarProducto(
                                      context, index, listaArt);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                          utils.numberFormat(
                                              articulos[index].price),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text(getTranlated(context, 'price'))
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _mostrarAlertaEditarProducto(
                                      context, index, listaArt);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Column(
                                    children: <Widget>[
                                      Text(articulos[index].quantity.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text(getTranlated(context, 'quantity'))
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _mostrarAlertaEditarProducto(
                                      context, index, listaArt);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                          utils.numberFormat(
                                              articulos[index].quantity *
                                                  articulos[index].price),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text('Total')
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
                ),
              );
            },
          ));
        });
  }

  _mostrarAlertaBuget(BuildContext context, Lista lista) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(getTranlated(context, 'buget')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _crearBuget(lista),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    getTranlated(context, 'baclTolist'),
                    style: TextStyle(color: utils.cambiarColor()),
                  )),
              FlatButton(
                  onPressed: () {
                    //getTotal();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    getTranlated(context, 'save'),
                    style: TextStyle(color: utils.cambiarColor()),
                  )),
            ],
          );
        });
  }

  Widget _crearBuget(Lista prod) {
    return TextField(
      maxLength: 6,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        counterText: '',
        hintText: getTranlated(context, 'newBuget'),
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
          prod.buget = double.parse(value);
          DBProvider.db.updatelist(prod);
          //prefs.tempBuget = buget.toString();
        }
      },
    );
  }

  void getTotal(Lista list) {
    if (articulos != null) {
      list.total = 0;
      for (int i = 0; i < articulos.length; i++) {
        setState(() {
          list.total += (articulos[i].price * articulos[i].quantity);

          getDiference(list);
          if (list.total > list.buget) {
            bugetColor = Colors.red[900];
          } else {
            bugetColor = utils.cambiarColor();
          }
        });
      }
      //prefs.tempTotal = total.toString();
    }
  }

  void getDiference(Lista list) {
    if (list.total == 0) {
      list.diference = list.buget;
      //colorBuget = colorBuget = Colors.green[400];
      return;
    }
    double calDiferecen = list.buget - list.total;
    if (calDiferecen < 0) {
      colorBuget = Colors.red[900];
    } else if (calDiferecen >= 0) {
      colorBuget = utils.cambiarColor();
    } else {
      colorBuget = utils.cambiarColor();
    }
    list.diference = calDiferecen;
  }

  void _mostrarAlertaEditarProducto(
      BuildContext context, int index, Lista list) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(getTranlated(context, 'EupdArt')),
            content: Form(
              key: editFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  //wawawaw2(index),
                  _editarNombreArticulo(index),
                  _editarcantidadArticulo(index),
                  _editarPrecioArticulo(index),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    getTranlated(context, 'baclTolist'),
                    style: TextStyle(color: utils.cambiarColor()),
                  )),
              FlatButton(
                  onPressed: () {
                    //_subimt();
                    _editDubimt(index);
                    getTotal(list);
                    _updataLista(list);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                     getTranlated(context, 'save'),
                    style: TextStyle(color: utils.cambiarColor()),
                  )),
            ],
          );
        });
  }

  void _editDubimt(int index) {
    editFormKey.currentState.save();
    DBProvider.db.updateProd(articulos[index]);
    
  }

  Widget _editarNombreArticulo(int index) {
    return TextFormField(
      initialValue: articulos[index].name,
       maxLength: 33,
      textCapitalization: TextCapitalization.sentences,
      textAlign: TextAlign.center,
      onSaved: (value) => articulos[index].name = value,
      decoration: InputDecoration(
        counterText: '',
        labelText: getTranlated(context, 'nameArt'),
        labelStyle: TextStyle(color: utils.cambiarColor()),

        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: utils.cambiarColor()),
        ),
        hintStyle: TextStyle(color: utils.cambiarColor()),
      ),
    );
  }

  Widget _editarPrecioArticulo(int index) {
    return TextFormField(
      initialValue: articulos[index].price.toString(),
      maxLength: 6,
      //controller: _controllers[index],
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        
        labelText: getTranlated(context, 'price'),
        labelStyle: TextStyle(color: utils.cambiarColor()),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: utils.cambiarColor()),
        ),
        counterText: '',
        //hintStyle: TextStyle(color: utils.cambiarColor()),
      ),
      onSaved: (value) {
        articulos[index].price = double.parse((value == "") ? "0" : value);
      },
      //onSaved: (value) => articulos[index].price = double.parse(value),
      validator: (value) {
        if (value.isEmpty) {
          value = "0";
        }
        if (utils.isNumeric(value)) {
          return null;
        } else {
          return getTranlated(context, 'onlyNumbers');
        }
      },
      keyboardType: TextInputType.numberWithOptions(decimal: true),
    );
  }

  Widget _editarcantidadArticulo(int index) {
    return TextFormField(
      initialValue: articulos[index].quantity.toString(),
      maxLength: 6,
      //controller: _controllers[index],
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        labelText: getTranlated(context, 'quantity'),
        labelStyle: TextStyle(color: utils.cambiarColor()),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: utils.cambiarColor()),
        ),
        counterText: '',
        //hintStyle: TextStyle(color: utils.cambiarColor()),
      ),
      onSaved: (value) {
        articulos[index].quantity = int.parse((value == "") ? "0" : value);
      },
      //onSaved: (value) => articulos[index].quantity = int.parse(value),
      validator: (value) {
        if (value.isEmpty) {
          value = "0";
        }
        if (utils.isNumeric(value)) {
          return null;
        } else {
          return getTranlated(context, 'onlyNumbers');
        }
      },
      keyboardType: TextInputType.numberWithOptions(decimal: true),
    );
  }

  // _validateEliminarList(BuildContext context, Lista list) {
  //   return showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text('Eliminar contenido'),
  //           actions: <Widget>[
  //             FlatButton(
  //                 onPressed: () => Navigator.of(context).pop(),
  //                 child: Text(
  //                   'Salir',
  //                   style: TextStyle(color: utils.cambiarColor()),
  //                 )),
  //             FlatButton(
  //                 onPressed: () => limpiarTodo(list),
  //                 child: Text(
  //                   'Aceptar',
  //                   style: TextStyle(color: utils.cambiarColor()),
  //                 )),
  //           ],
  //         );
  //       });
  // }

  // limpiarTodo(Lista list) {
  //   setState(() {
  //     DBProvider.db.deleteAllProd();
  //     articulos.clear();
  //     getTotal(list);
  //     getDiference(list);
  //     DBProvider.db.updatelist(list);
  //     utils.showSnack(context, 'Lista limpiada');
  //   });
  //   Navigator.of(context).pop();
  // }

  void _mostrarAlertaProducto(BuildContext context, Lista list) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(getTranlated(context, 'newArt')),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      //wawawaw(),
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
                    getTranlated(context, 'baclTolist'),
                    style: TextStyle(color: utils.cambiarColor()),
                  )),
              FlatButton(
                  onPressed: () {
                    _subimt(list);
                    getTotal(list);
                    _updataLista(list);
                  },
                  child: Text(
                     getTranlated(context, 'save'),
                    style: TextStyle(color: utils.cambiarColor()),
                  )),
            ],
          );
        });
  }

  Widget row(Segurencia user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            user.name,
            style: TextStyle(fontSize: 16.0),
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
      ],
    );
  }

  // AutoCompleteTextField searchTextField;
  // Widget wawawaw() {
  //   return TypeAheadFormField(
  //     textFieldConfiguration: TextFieldConfiguration(
  //         controller: this._typeAheadController,
  //         decoration: InputDecoration(labelText: 'Nombre artículo')),
  //     suggestionsCallback: (pattern) {
  //       return DBProvider.db.sugeGet(pattern);
  //     },
  //     itemBuilder: (context, Segurencia suggestion) {
  //       return ListTile(
  //         title: Text(suggestion.name),
  //       );
  //     },
  //     transitionBuilder: (context, suggestionsBox, controller) {
  //       return suggestionsBox;
  //     },
  //     onSuggestionSelected: (suggestion) {
  //       return null;
  //     },
  //     onSaved: (value) => productModel.name = value,

  //   );
  // }

  // Widget wawawaw2(int index) {

  //   return TypeAheadFormField(
  //     initialValue: articulos[index].name,
  //     textFieldConfiguration: TextFieldConfiguration(
  //         //controller: this._typeAheadController,
  //         decoration: InputDecoration(labelText: 'Nombre artículo')),
  //     suggestionsCallback: (pattern) {
  //       return DBProvider.db.sugeGet(pattern);
  //     },
  //     itemBuilder: (context, Segurencia suggestion) {
  //       return ListTile(
  //         title: Text(suggestion.name),
  //       );
  //     },
  //     transitionBuilder: (context, suggestionsBox, controller) {
  //       return suggestionsBox;
  //     },
  //     onSuggestionSelected: (suggestion) {
  //       return null;
  //     },
  //     onSaved: (value) => articulos[index].name = value,
  //     // validator: (value) {
  //     //   if (value.isEmpty) {
  //     //     return 'Please select a city';
  //     //   }
  //     // },
  //     // onSaved: (value) => this._selectedCity = value,
  //   );

  //   // Column(
  //   //   mainAxisAlignment: MainAxisAlignment.start,
  //   //   children: <Widget>[
  //   //     searchTextField = AutoCompleteTextField<Segurencia>(

  //   //       key:keyS,
  //   //       clearOnSubmit: false,
  //   //      suggestions: BackendService.players,
  //   //       style: TextStyle(color: Colors.black, fontSize: 16.0),
  //   //      decoration: InputDecoration(
  //   //     counterText: '',
  //   //     focusedBorder: UnderlineInputBorder(
  //   //       borderSide: BorderSide(color: utils.cambiarColor()),
  //   //     ),
  //   //     hintText: 'Nombre artículo',
  //   //     hintStyle: TextStyle(color: utils.cambiarColor()),
  //   //   ),

  //   //       itemFilter: (item, query) {
  //   //         return item.name.toLowerCase().startsWith(query.toLowerCase());
  //   //       },
  //   //       itemSorter: (a, b) {
  //   //         return a.name.compareTo(b.name);
  //   //       },
  //   //       itemSubmitted: (item) {
  //   //         setState(() {
  //   //           searchTextField.textField.controller.text =  articulos[index].name;
  //   //           articulos[index].name = item.name;
  //   //          // (value) => productModel.name = value
  //   //         });
  //   //       },
  //   //       itemBuilder: (context, item) {
  //   //          //initialValue: articulos[index].name;
  //   //          //articulos[index].name = value,
  //   //         // ui for the autocomplete row
  //   //         return row(item);
  //   //       },
  //   //     ),
  //   //   ],
  //   // );
  //   // );
  // }

  Widget _crearNombreArticulo() {
    return TextFormField(
      //  initialValue: productModel.name,
       maxLength: 33,
      textCapitalization: TextCapitalization.sentences,
      textAlign: TextAlign.center,
      onSaved: (value) => productModel.name = value,
      decoration: InputDecoration(
        counterText: '',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: utils.cambiarColor()),
        ),
        // hintText: 'Nombre artículo',
        labelStyle: TextStyle(color: utils.cambiarColor()),
        labelText: getTranlated(context, 'nameArt'),
        //hintStyle: TextStyle(color: utils.cambiarColor()),
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
        labelText: getTranlated(context, 'price'),
        labelStyle: TextStyle(color: utils.cambiarColor()),
        counterText: '',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: utils.cambiarColor()),
        ),
        //hintStyle: TextStyle(color: utils.cambiarColor()),
      ),
      onSaved: (value) {
        productModel.price = double.parse((value == "") ? "0" : value);
      },
      //onSaved: (value) => productModel.price = double.parse(value),
      validator: (value) {
        if (value.isEmpty) {
          value = "0";
        }
        if (utils.isNumeric(value)) {
          return null;
        } else {
          return getTranlated(context, 'onlyNumbers');
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
        labelText: getTranlated(context, 'quantity'),
        labelStyle: TextStyle(color: utils.cambiarColor()),
        counterText: '',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: utils.cambiarColor()),
        ),
        //hintStyle: TextStyle(color: utils.cambiarColor()),
      ),
      onSaved: (value) {
        productModel.quantity = int.parse((value == "") ? "0" : value);
      },
      //onSaved: (value) => productModel.quantity = int.parse(value),
      validator: (value) {
        if (value.isEmpty) {
          value = "0";
        }
        if (utils.isNumeric(value)) {
          return null;
        } else {
          return getTranlated(context, 'onlyNumbers');
        }
      },
      keyboardType: TextInputType.numberWithOptions(decimal: true),
    );
  }

  void _subimt(Lista list) {
    var it = articulos.length;
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();
    var prod = new ProductModel(
        name: productModel.name,
        quantity: productModel.quantity,
        listId: list.id,
        price: productModel.price,
        complete: 0);
    articulos.insert(it, prod);
    DBProvider.db.newProd(prod);

    formKey.currentState.reset();
  }

  _updataLista(Lista list) {
    DateTime now = new DateTime.now();
    var fecha = '${now.day}/${now.month}/${now.year}';
    final updateLista = Lista(
        id: list.id,
        title: list.title,
        superMaret: list.superMaret,
        fecha: fecha,
        total: list.total,
        diference: list.diference,
        buget: list.buget);

    DBProvider.db.updatelist(updateLista);
  }

   void showDeleteSnack(BuildContext context, String msg, int index, ProductModel item,  List<ProductModel> items) {
  Flushbar(
    //title: 'This action is prohibited',
    message: msg,
    icon: Icon(
      Icons.info_outline,
      size: 28,
      color: utils.cambiarColor(),
    ),
    mainButton: FlatButton(
        onPressed: () {
          print(item);
          //_undoProd(item, index);
           DBProvider.db.newProd(item);
           //DBProvider.db.getTmpArticulos();
          var it = items.length;
           items.insert(it, item);
          setState(() {
            
          });
        },
        child: Text(
          getTranlated(context, 'undo'),
          style: TextStyle(color: Colors.amber),
        ),
      ),
    leftBarIndicatorColor: utils.cambiarColor(),
    duration: Duration(seconds: 3),
  )..show(context);
}
}
