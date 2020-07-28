import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:shopapp/src/Shared_Prefs/Prefrecias_user.dart';
import 'package:shopapp/src/models/List_model.dart';
import 'package:shopapp/src/models/product_model.dart';
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
  Lista listaModel = new Lista();

  @override
  Widget build(BuildContext context) {
    //loadSharedPrefs();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
          backgroundColor: utils.cambiarColor(),
          title: Text(
            'Lista de compra',
          )),
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
    //int flag = (boolValue==true)? 1:0;
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();
    var prod = new ProductModel(
        name: productModel.name,
        quantity: productModel.quantity,
        listId: 1,
        price: productModel.price,
        complete: 0);
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
          prefs.tempBuget = buget.toString();
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
        padding: EdgeInsets.all(3),
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
//   Widget _midHeader(){
//       return ConstrainedBox(
//   constraints: BoxConstraints.expand(height: 60),
//   child: Container(
//     color: Colors.white,
//     child: Padding(
//       padding: EdgeInsets.all(10), 
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         //crossAxisAlignment: CrossAxisAlignment.center,
//         children: <Widget>[
          
//         Text('Articulo'),
//           SizedBox(
//                             width: 20,
//                           ),
//         Text('Precio'),
//           SizedBox(
//                             width: 15,
//                           ),
//         Text('Cantidad'),
//             SizedBox(
//                             width: 15,
//                           ),
//         Text('Total articulo'),
//       ],)
//       //Text('msg', style: TextStyle(fontSize: 25 ,fontWeight: FontWeight.bold))
//     ),
// ));
//   }
  _bodyWidget() {
    return FutureBuilder<List<ProductModel>>(
        // builder: null
        future: DBProvider.db.getTmpArticulos(),
        builder: (context, AsyncSnapshot<List<ProductModel>> snapshot) {
          if (snapshot.hasData && snapshot.data.length > 0) {
            final tmpArt = snapshot.data;

            items = tmpArt;
          }

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
                      'No se han agregado artículos a la lista',
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
                  showSnack(context, 'Artículo eliminado de la lista');
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
                              
                              (valor == true) ? showSnack(context, 'Artículo agregado al carrito') : showSnack(context, 'Artículo removido del carrito');                              //   showSnack(context, 'Artículo agregado');

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
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0, bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              
                              Icon(Icons.shopping_basket, color: utils.cambiarColor(),),
                                  SizedBox(
                            width: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                              Text(utils.numberFormat(items[index].price),style: TextStyle( fontWeight: FontWeight.bold)),
                              Text('Precio')
                            ],),
                          )
                              ,
                                  SizedBox(
                            width: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(children: <Widget>[
                              Text(items[index].quantity.toString(),style: TextStyle( fontWeight: FontWeight.bold)),
                              Text('Cantidad')
                            ],),
                          ),
                              
                                  SizedBox(
                            width: 5,
                          ),
                           Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(children: <Widget>[
                              Text(utils.numberFormat(items[index].quantity * items[index].price),style: TextStyle( fontWeight: FontWeight.bold)),
                              Text('Total')
                            ],),
                          ),
                              // Text(utils.numberFormat(
                              //   items[index].quantity * items[index].price,
                              // )
                              //),
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

  void showSnack(BuildContext context, String msg){
       Flushbar(
      //title: 'This action is prohibited',
      message: msg,
      icon: Icon(
        Icons.info_outline,
        size: 28,
        color: utils.cambiarColor(),
      ),
      leftBarIndicatorColor: utils.cambiarColor(),
      duration: Duration(seconds: 2),
    )..show(context);
    // Scaffold.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text(msg),
    //   ),
      
    // );
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
                    prefs.tempTotal = '0.00';
                    prefs.tempBuget = '0.00';
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

}
