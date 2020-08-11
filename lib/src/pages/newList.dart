import 'package:flutter/material.dart';
import 'package:shopapp/src/Shared_Prefs/Prefrecias_user.dart';
import 'package:shopapp/src/localization/localization_constant.dart';
import 'package:shopapp/src/models/List_model.dart';
import 'package:shopapp/src/models/product_model.dart';
import 'package:shopapp/src/models/suge.dart';
import 'package:shopapp/src/providers/db_provider.dart';
import 'package:shopapp/src/utils/utils.dart' as utils;
import 'package:shopapp/src/widgets/Menu_widget.dart';
import 'package:uuid/uuid.dart';

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
  final prefs = new PreferenciasUsuario();

  @override
  void initState() {
    total = double.parse(prefs.tempTotal);
    buget = double.parse(prefs.tempBuget);
    super.initState();
  }

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
  Segurencia sugeModel = new Segurencia();
  Lista listaModel = new Lista();

  @override
  Widget build(BuildContext context) {
    //loadSharedPrefs();

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
          backgroundColor: utils.cambiarColor(),
          title: Text(getTranlated(context, 'mMyLisTitle'))),
      drawer: MenuWidget(),
      body: Column(
        children: <Widget>[
          _header(),
          //_midHeader(),
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
            bugetColor = utils.cambiarColor();
          }
        });
      }
      prefs.tempTotal = total.toString();
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
    diference = calDiferecen;
  }

  void _mostrarAlertaBuget(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(getTranlated(context, 'buget')),
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
                     getTranlated(context, 'baclTolist'),
                    style: TextStyle(color: utils.cambiarColor()),
                  )),
              FlatButton(
                  onPressed: () {
                    getTotal();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                     getTranlated(context, 'addBuget'),
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
            title: Text(getTranlated(context, 'newArt')),
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
                   getTranlated(context, 'baclTolist'),
                    style: TextStyle(color: utils.cambiarColor()),
                  )),
              FlatButton(
                  onPressed: () {
                    _subimt();
                    getTotal();
                    //Navigator.of(context).pop();
                  },
                  child: Text(
                     getTranlated(context, 'add'),
                    style: TextStyle(color: utils.cambiarColor()),
                  )),
            ],
          );
        });
  }

  Widget _crearNombreArticulo() {
    return TextFormField(
      //  initialValue: productModel.name,
      maxLength: 40,
      textCapitalization: TextCapitalization.sentences,
      textAlign: TextAlign.center,
      onSaved: (value) => productModel.name = value,
      validator: (value){
        if(utils.isEmpty(value)){
          return null;
        } else {
          return getTranlated(context, 'noEmpty');
        }
      },
      decoration: InputDecoration(
        labelText: getTranlated(context, 'nameArt'),
        counterText: '',
        labelStyle: TextStyle(color: utils.cambiarColor()),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: utils.cambiarColor()),
        ),
        //hintText: 'Nombre artículo',
        //hintStyle: TextStyle(color: utils.cambiarColor()),
      ),
    );
  }

  Widget _crearPrecioArticulo() {
    return TextFormField(
      // initialValue:0.toString(),
      maxLength: 6,
      //controller: _controllers[index],
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        labelText: getTranlated(context, 'price'),
        counterText: '',
        labelStyle: TextStyle(color: utils.cambiarColor()),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: utils.cambiarColor()),
        ),
      ),
      onSaved: (value) {
        productModel.price = double.parse((value == "") ? "0" : value);
      },
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
      //initialValue: 0.toString(),
      maxLength: 6,
      //controller: _controllers[index],
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        labelText: getTranlated(context, 'quantity'),
        counterText: '',
        labelStyle: TextStyle(color: utils.cambiarColor()),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: utils.cambiarColor()),
        ),
        //  int complValue = (valor == true) ? 1 : 0; int.parse(value),
      ),
      onSaved: (value) {
        productModel.quantity = int.parse((value == "") ? "0" : value);
      },
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

  void _subimt() {
    var it = items.length;
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();
    var prod = new ProductModel(
        name: productModel.name,
        quantity: productModel.quantity,
        listId: '1',
        price: productModel.price,
        complete: 0);
    items.insert(it, prod);
    DBProvider.db.tmpProd(prod);
    formKey.currentState.reset();
  }

  void _mostrarAlertaEditarProducto(BuildContext context, int index) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(getTranlated(context, 'editArt')),
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
                   getTranlated(context, 'leave'),
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
                    getTranlated(context, 'accept'),
                    style: TextStyle(color: utils.cambiarColor()),
                  )),
            ],
          );
        });
  }

  void _editDubimt(int index) {
    editFormKey.currentState.save();
    DBProvider.db.updatetempProd(items[index]);
  }

  Widget _editarNombreArticulo(int index) {
    return TextFormField(
      initialValue: items[index].name,
      maxLength: 50,
      textCapitalization: TextCapitalization.sentences,
      textAlign: TextAlign.center,
      onSaved: (value) => items[index].name = value,
      decoration: InputDecoration(
        labelText: getTranlated(context, 'nameArt'),
        counterText: '',
        labelStyle: TextStyle(color: utils.cambiarColor()),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: utils.cambiarColor()),
        ),
        //hintText: 'Nombre artículo',
        //hintStyle: TextStyle(color: utils.cambiarColor()),
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
        labelText: getTranlated(context, 'price'),
        counterText: '',
        labelStyle: TextStyle(color: utils.cambiarColor()),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: utils.cambiarColor()),
        ),
      ),
      onSaved: (value) {
        items[index].price = double.parse((value == "") ? "0" : value);
      },
      //onSaved: (value) => items[index].price = double.parse(value),
      validator: (value) {
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
      initialValue: items[index].quantity.toString(),
      maxLength: 6,
      //controller: _controllers[index],

      textAlign: TextAlign.center,
      decoration: InputDecoration(
        labelText: getTranlated(context, 'quantity'),
        counterText: '',
        labelStyle: TextStyle(color: utils.cambiarColor()),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: utils.cambiarColor()),
        ),
        //hintStyle: TextStyle(color: utils.cambiarColor()),
      ),
      onSaved: (value) {
        items[index].quantity = int.parse((value == "") ? "0" : value);
      },
      //onSaved: (value) => items[index].quantity = int.parse(value),
      validator: (value) {
        if (utils.isNumeric(value)) {
          return null;
        } else {
          return  getTranlated(context, 'onlyNumbers');
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
         labelText: getTranlated(context, 'listName'),
        labelStyle: TextStyle(color: utils.cambiarColor()),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: utils.cambiarColor()),
        ),
        //hintText: 'Nombre lista',
        //hintStyle: TextStyle(color: utils.cambiarColor()),
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
         labelText: getTranlated(context, 'shopName'),
        labelStyle: TextStyle(color: utils.cambiarColor()),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: utils.cambiarColor()),
        ),
       // hintText: 'Nombre localidad',
        //hintStyle: TextStyle(color: utils.cambiarColor()),
      ),
    );
  }

  Widget _crearBuget() {
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
          buget = double.parse(value);
          prefs.tempBuget = buget.toString();
        }
      },
    );
  }

  Widget _header() {
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
                     onTap: () => _mostrarAlertaBuget(context),
                    child: Container(
                      color: Colors.white,
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FlatButton.icon(
                                  onPressed: () => _mostrarAlertaBuget(context),
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

  _bodyWidget() {
    return FutureBuilder<List<ProductModel>>(
        // builder: null
        future: DBProvider.db.getTmpArticulos(),
        builder: (context, AsyncSnapshot<List<ProductModel>> snapshot) {
          if (snapshot.hasData && snapshot.data.length > 0) {
            final tmpArt = snapshot.data;

            items = tmpArt;
          }
          //      sugeModel.name = "Pan";
          // DBProvider.db.sugeInsert(sugeModel);

          //   sugeModel.name = "Yuca";
          // DBProvider.db.sugeInsert(sugeModel);

          //   sugeModel.name = "Jabon";
          // DBProvider.db.sugeInsert(sugeModel);
          if (items.length == 0) {
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
                        getTranlated(context, 'noList'),
                      style: TextStyle(
                        color: utils.cambiarColor(),
                        fontSize: 18,
                      ),
                    ),
                  )
                ]));
          }

          items.sort((a, b) => a.name.compareTo(b.name));
          // sugeModel.name = "Pan";
          // DBProvider.db.sugeInsert(sugeModel);

          //   sugeModel.name = "Yuca";
          // DBProvider.db.sugeInsert(sugeModel);

          //   sugeModel.name = "Jabon";
          // DBProvider.db.sugeInsert(sugeModel);

          return Expanded(
              child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              _controllers.add(new TextEditingController());
              //var wawa = toBoolean(items[index].complete);
              bool isComplete = (items[index].complete == 1) ? true : false;
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
                key: Key(items[index].name + items.length.toString()),
                onDismissed: (direction) {
                  //wey
                  utils.showDeleteSnack(context, getTranlated(context, 'offLis'), items, index);
                 // utils.showSnack(context,  getTranlated(context, 'offLis'));
                  DBProvider.db.deleteTmpProd(items[index].id);
                  items.removeAt(index);

                  getTotal();
                  getDiference();
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
                            items[index].name,
                            style: TextStyle(fontWeight: FontWeight.w900),
                            textAlign: TextAlign.start,
                          ),
                          Spacer(),
                          Checkbox(
                            value: isComplete,
                            onChanged: (valor) {
                              int complValue = (valor == true) ? 1 : 0;
                              items[index].complete = complValue;
                              DBProvider.db.updatetempProd(items[index]);
                              setState(() {});

                              (valor == true)
                                  ? utils.showSnack(
                                      context,  getTranlated(context, 'onCart'))
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
                      GestureDetector(
                        onTap: () {
                          _mostrarAlertaEditarProducto(context, index);
                        },
                        child: GestureDetector(
                          onTap: () {
                            _mostrarAlertaEditarProducto(context, index);
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
                                GestureDetector(
                                  onTap: () {
                                    _mostrarAlertaEditarProducto(
                                        context, index);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                            utils.numberFormat(
                                                items[index].price),
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
                                        context, index);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Column(
                                      children: <Widget>[
                                        Text(items[index].quantity.toString(),
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
                                        context, index);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                            utils.numberFormat(
                                                items[index].quantity *
                                                    items[index].price),
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
                      ),
                    ],
                  )),
                ),
              );
            },
          ));
        });
  }

  Widget _bNavbar(BuildContext context) {
    return BottomAppBar(
        child: new Row(
      children: <Widget>[
        FlatButton(
          onPressed: () => _guardarLista(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[Icon(Icons.save), Text(getTranlated(context, 'saveList'))],
          ),
        ),
        FlatButton(
          onPressed: () => _validateEliminarList(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(Icons.remove_circle_outline),
              Text(getTranlated(context, 'clearList'))
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
            title: Text(getTranlated(context, 'deleteCont')),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    getTranlated(context, 'leave'),
                    style: TextStyle(color: utils.cambiarColor()),
                  )),
              FlatButton(
                  onPressed: () => limpiarTodo(),
                  child: Text(
                    getTranlated(context, 'accept'),
                    style: TextStyle(color: utils.cambiarColor()),
                  )),
            ],
          );
        });
  }

  limpiarTodo() {
    setState(() {
      DBProvider.db.deleteAllTempProd();
      items.clear();
      getTotal();
      getDiference();
    });
    Navigator.of(context).pop();
  }

  saveList() {
    String lisId = uuid.v4();
    DBProvider.db.deleteAllTempProd();
    lisForm.currentState.save();
    DateTime now = new DateTime.now();
    var fecha = '${now.day}/${now.month}/${now.year}';
    final nuevaLista = Lista(
        id: lisId,
        title: listaModel.title,
        superMaret: listaModel.superMaret,
        fecha: fecha,
        total: total,
        diference: diference,
        buget: buget);

    DBProvider.db.nuevoLista(nuevaLista);
    // var prod = new ProductModel(
    //     name: productModel.name,
    //     quantity: productModel.quantity,
    //     listId: 6,
    //     price: productModel.price);

    for (var i = 0; i < items.length; i++) {
      items[i].listId = nuevaLista.id;
      DBProvider.db.newProd(items[i]);
    }

    // DBProvider.db.newProd(prod);

    items = [];
    lisForm.currentState.reset();
  }

  void _guardarLista(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(getTranlated(context, 'saveList')),
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
                    getTranlated(context, 'leave'),
                    style: TextStyle(color: utils.cambiarColor()),
                  )),
              FlatButton(
                  onPressed: () {
                    saveList();
                    Navigator.pushNamed(context, 'home');
                    prefs.tempTotal = '0.00';
                    prefs.tempBuget = '0.00';
                  },
                  child: Text(
                    getTranlated(context, 'accept'),
                    style: TextStyle(color: utils.cambiarColor()),
                  )),
            ],
          );
        });
  }
}
