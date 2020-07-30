import 'package:flutter/material.dart';
import 'package:shopapp/src/models/List_model.dart';
import 'package:shopapp/src/models/product_model.dart';
import 'package:shopapp/src/providers/db_provider.dart';
import 'package:shopapp/src/utils/utils.dart' as utils;
import 'package:shopapp/src/widgets/Menu_widget.dart';

class DetailsPage extends StatefulWidget {
  final Lista savelist;
  DetailsPage({Key key, this.savelist}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  double buget;
  double total;
  double diference;
  Color colorBuget = utils.cambiarColor();
  Color bugetColor = utils.cambiarColor();
  final editFormKey = GlobalKey<FormState>();
  //@override
  List<ProductModel> articulos = [];
  Widget build(BuildContext context) {
    // Lista listaModel = widget.savelist;
    Lista listaModel = widget.savelist;
    //buget = listaModel.total;

    return Scaffold(
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
          // _mostrarAlertaProducto(context);
        },
        backgroundColor: utils.cambiarColor(),
        child: Icon(Icons.add_shopping_cart),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: _bNavbar(context),
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
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton.icon(
                              onPressed: () =>
                                  _mostrarAlertaBuget(context, list),
                              icon: Icon(Icons.account_balance_wallet),
                              label: Text("Presupuesto")),
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
                          label: Text("Diferencia")),
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

  Widget _bNavbar(BuildContext context) {
    return BottomAppBar(
        child: new Row(
      children: <Widget>[
        FlatButton(
          //onPressed: () => _guardarLista(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[Icon(Icons.save), Text('Actualizar lista')],
          ),
        ),
        FlatButton(
          //onPressed: () => _validateEliminarList(context),
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

  _bodyWidget(String id, Lista listaArt) {
    return FutureBuilder<List<ProductModel>>(
        // builder: null
        future: DBProvider.db.getprodId(id),
        builder: (context, AsyncSnapshot<List<ProductModel>> snapshot) {
          if (snapshot.hasData && snapshot.data.length > 0) {
            final art = snapshot.data;

            articulos = art;
          }

          // if (listaModel.length == 0) {
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
          //             'No se han agregado artículos a la lista',
          //             style: TextStyle(
          //               color: utils.cambiarColor(),
          //               fontSize: 18,
          //             ),
          //           ),
          //         )
          //       ]));
          // }

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
                key: Key(articulos[index].name + articulos.length.toString()),
                onDismissed: (direction) {
                  utils.showSnack(context, 'Artículo eliminado de la lista');
                  DBProvider.db.deleteProd(articulos[index].id);
                  articulos.removeAt(index);

                  getTotal(listaArt);
                  getDiference(listaArt);
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
                                      context, 'Artículo agregado al carrito')
                                  : utils.showSnack(context,
                                      'Artículo removido del carrito'); //   showSnack(context, 'Artículo agregado');
                            },
                            activeColor: utils.cambiarColor(),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          _mostrarAlertaEditarProducto(context, index, listaArt);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0, bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Icon(
                                Icons.shopping_basket,
                                color: utils.cambiarColor(),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                        utils.numberFormat(
                                            articulos[index].price),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text('Precio')
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Column(
                                  children: <Widget>[
                                    Text(articulos[index].quantity.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text('Cantidad')
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Padding(
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

  void _mostrarAlertaBuget(BuildContext context, Lista lista) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(' Presupuesto'),
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
                    'Cancelar',
                    style: TextStyle(color: utils.cambiarColor()),
                  )),
              FlatButton(
                  onPressed: () {
                    //getTotal();
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
  
  Widget _crearBuget(Lista prod) {
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

    void _mostrarAlertaEditarProducto(BuildContext context, int index, Lista list) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('Actulizar artículo'),
            content: Form(
              key: editFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
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
                    'Salir',
                    style: TextStyle(color: utils.cambiarColor()),
                  )),
              FlatButton(
                  onPressed: () {
                    //_subimt();
                    _editDubimt(index);
                    getTotal(list);
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
    DBProvider.db.updateProd(articulos[index]);
  }

   Widget _editarNombreArticulo(int index) {
    return TextFormField(
      initialValue: articulos[index].name,
      maxLength: 50,
      textCapitalization: TextCapitalization.sentences,
      textAlign: TextAlign.center,
      onSaved: (value) => articulos[index].name = value,
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
      initialValue: articulos[index].price.toString(),
      maxLength: 6,
      //controller: _controllers[index],
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: 'Precio',
        counterText: '',
        hintStyle: TextStyle(color: utils.cambiarColor()),
      ),
      onSaved: (value) => articulos[index].price = double.parse(value),
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
      initialValue: articulos[index].quantity.toString(),
      maxLength: 6,
      //controller: _controllers[index],
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: 'Cantidad',
        counterText: '',
        hintStyle: TextStyle(color: utils.cambiarColor()),
      ),
      onSaved: (value) => articulos[index].quantity = int.parse(value),
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

}
