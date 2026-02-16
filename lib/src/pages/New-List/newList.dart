import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocketlist/src/Shared_Prefs/Prefrecias_user.dart';
import 'package:pocketlist/src/localization/localization_constant.dart';
import 'package:pocketlist/src/models/List_model.dart';
import 'package:pocketlist/src/models/product_model.dart';
import 'package:pocketlist/src/models/suge.dart';
import 'package:pocketlist/src/providers/db_provider.dart';
import 'package:pocketlist/src/utils/utils.dart' as utils;
//import 'package:pocketlist/src/widgets/Menu_widget.dart';
import 'package:uuid/uuid.dart';
import 'package:another_flushbar/flushbar.dart';

class NewList extends StatefulWidget {
  NewList({Key? key}) : super(key: key);

  @override
  _NewListState createState() => _NewListState();
}

class _NewListState extends State<NewList> {
  double buget = 00.00;
  double total = 0.00;
  double diference = 0.00;
  int totalItems = 0;
  bool checkValue = false;
  bool _dialogoCompletadoMostrado = false;
  FocusNode myFocusNode = FocusNode();

  final prefs = new PreferenciasUsuario();

  @override
  void initState() {
    // prefs.ultimaPagina = 'newList';
    total = double.parse(prefs.tempTotal);
    buget = double.parse(prefs.tempBuget);
    super.initState();
  }

  final formKey = GlobalKey<FormState>();
  final editFormKey = GlobalKey<FormState>();
  final lisForm = GlobalKey<FormState>();

  Color colorBuget = utils.cambiarColor();
  Color bugetColor = utils.cambiarColor();
  final bugetController = TextEditingController();

  var uuid = Uuid();

  List<ProductModel> items = [];

  //List<ProductModel> itemsTemp =  utils.prefs.read("TempPro");
  List<TextEditingController> _controllers = [];
  ProductModel productModel = new ProductModel();
  Segurencia sugeModel = new Segurencia();
  Lista listaModel = new Lista();

  // Getters para items completados y pendientes
  int get itemsCompletados => items.where((item) => item.complete == 1).length;
  int get itemsPendientes => items.where((item) => item.complete == 0).length;

  @override
  Widget build(BuildContext context) {
    //loadSharedPrefs();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      // backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: utils.cambiarColor(),
        title: Text(getTranlated(context, 'mMyLisTitle')),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                if (items.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$itemsCompletados/${items.length}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
      //drawer: Icon(Icons.arrow_back),
      // drawer: MenuWidget(),
      body: Column(
        children: <Widget>[
          _header(),
          _bodyWidget(),
        ],
      ),
      bottomNavigationBar: _bNavbar(context),
    );
  }

  void getTotal() {
    if (items.isNotEmpty) {
      total = 0;
      for (int i = 0; i < items.length; i++) {
        setState(() {
          total += (items[i].price * items[i].quantity);

          getDiference();
          if (total > buget) {
            bugetColor = Colors.red[900]!;
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
      colorBuget = Colors.red[900]!;
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: Text(getTranlated(context, 'buget')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _crearBuget(),
              ],
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    getTranlated(context, 'baclTolist'),
                    style: TextStyle(
                        color: (prefs.color == 5)
                            ? Colors.white
                            : utils.cambiarColor()),
                  )),
              TextButton(
                  onPressed: () {
                    saveBudget(bugetController.text);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    getTranlated(context, 'addBuget'),
                    style: TextStyle(
                        color: (prefs.color == 5)
                            ? Colors.white
                            : utils.cambiarColor()),
                  )),
            ],
          );
        });
  }

  void _mostrarAlertaProducto(BuildContext context) {
    // Resetear el modelo al abrir el diálogo
    productModel = ProductModel();

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: Text(getTranlated(context, 'newArt')),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
              TextButton(
                  onPressed: () {
                    productModel = ProductModel(); // Resetear al cancelar
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    getTranlated(context, 'baclTolist'),
                    style: TextStyle(
                        color: (prefs.color == 5)
                            ? Colors.white
                            : utils.cambiarColor()),
                  )),
              TextButton(
                  onPressed: () {
                    _subimt();
                    getTotal();
                    //Navigator.of(context).pop();
                  },
                  child: Text(
                    getTranlated(context, 'add'),
                    style: TextStyle(
                        color: (prefs.color == 5)
                            ? Colors.white
                            : utils.cambiarColor()),
                  )),
            ],
          );
        });
  }

  Widget _crearNombreArticulo() {
    return TextFormField(
      initialValue: productModel.name,
      focusNode: myFocusNode,
      maxLength: 33,
      textCapitalization: TextCapitalization.sentences,
      textAlign: TextAlign.center,
      onSaved: (value) => productModel.name = value ?? '',
      validator: (value) {
        if (utils.isEmpty(value!)) {
          return null;
        } else {
          return getTranlated(context, 'noEmpty');
        }
      },
      decoration: InputDecoration(
        labelText: getTranlated(context, 'nameArt'),
        labelStyle: TextStyle(
            color: (prefs.color == 5) ? Colors.white : utils.cambiarColor()),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: (prefs.color == 5) ? Colors.white : utils.cambiarColor()),
        ),
      ),
    );
  }

  Widget _crearPrecioArticulo() {
    return TextFormField(
      initialValue:
          (productModel.price == 0) ? "" : productModel.price.toString(),
      maxLength: 6,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        labelText: getTranlated(context, 'price'),
        counterText: '',
        labelStyle: TextStyle(
            color: (prefs.color == 5) ? Colors.white : utils.cambiarColor()),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: (prefs.color == 5) ? Colors.white : utils.cambiarColor()),
        ),
      ),
      onSaved: (value) {
        productModel.price =
            double.parse((value == null || value.isEmpty) ? "0" : value);
      },
      validator: (value) {
        String checkValue = value ?? "0";
        if (checkValue.isEmpty) {
          checkValue = "0";
        }
        if (utils.isNumeric(checkValue)) {
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
      initialValue:
          (productModel.quantity == 0) ? "" : productModel.quantity.toString(),
      maxLength: 6,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        labelText: getTranlated(context, 'quantity'),
        counterText: '',
        labelStyle: TextStyle(
            color: (prefs.color == 5) ? Colors.white : utils.cambiarColor()),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: (prefs.color == 5) ? Colors.white : utils.cambiarColor()),
        ),
      ),
      onSaved: (value) {
        productModel.quantity =
            int.parse((value == null || value.isEmpty) ? "0" : value);
      },
      validator: (value) {
        String checkValue = value ?? "0";
        if (checkValue.isEmpty) {
          checkValue = "0";
        }
        if (utils.isNumeric(checkValue)) {
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
    if (!formKey.currentState!.validate()) return;

    formKey.currentState!.save();
    var prod = ProductModel(
        name: productModel.name,
        quantity: productModel.quantity,
        listId: 'tmp',
        price: productModel.price,
        complete: 0);
    items.insert(it, prod);
    DBProvider.db.newProd(prod);

    // Resetear el modelo para el próximo item
    productModel = ProductModel();

    formKey.currentState!.reset();
    setState(() {});
    myFocusNode.requestFocus();
  }

  // void _subimt() {
  //   var it = items.length;
  //   if (!formKey.currentState!.validate()) return;

  //   formKey.currentState!.save();
  //   var prod = ProductModel(
  //       name: productModel.name,
  //       quantity: productModel.quantity,
  //       listId: 'tmp',
  //       price: productModel.price,
  //       complete: 0);
  //   items.insert(it, prod);
  //   DBProvider.db.newProd(prod);
  //   //print(productModel.id);
  //   formKey.currentState!.reset();
  //   setState(() {});
  //   myFocusNode.requestFocus();
  // }

  void _mostrarAlertaEditarProducto(BuildContext context, int index) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: Text(getTranlated(context, 'EupdArt')),
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
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    getTranlated(context, 'leave'),
                    style: TextStyle(
                        color: (prefs.color == 5)
                            ? Colors.white
                            : utils.cambiarColor()),
                  )),
              TextButton(
                  onPressed: () {
                    //_subimt();
                    _editDubimt(index);
                    getTotal();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    getTranlated(context, 'save'),
                    style: TextStyle(
                        color: (prefs.color == 5)
                            ? Colors.white
                            : utils.cambiarColor()),
                  )),
            ],
          );
        });
  }

  void _editDubimt(int index) {
    editFormKey.currentState!.save();
    DBProvider.db.updateProd(items[index]);
  }

  Widget _editarNombreArticulo(int index) {
    return TextFormField(
      initialValue: items[index].name,
      maxLength: 33,
      textCapitalization: TextCapitalization.sentences,
      textAlign: TextAlign.center,
      onSaved: (value) => items[index].name = value ?? '',
      decoration: InputDecoration(
        labelText: getTranlated(context, 'nameArt'),
        counterText: '',
        labelStyle: TextStyle(
            color: (prefs.color == 5) ? Colors.white : utils.cambiarColor()),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: (prefs.color == 5) ? Colors.white : utils.cambiarColor()),
        ),
      ),
    );
  }

  Widget _editarPrecioArticulo(int index) {
    return TextFormField(
      initialValue:
          (items[index].price == 0) ? "" : items[index].price.toString(),
      maxLength: 6,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        labelText: getTranlated(context, 'price'),
        counterText: '',
        labelStyle: TextStyle(
            color: (prefs.color == 5) ? Colors.white : utils.cambiarColor()),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: (prefs.color == 5) ? Colors.white : utils.cambiarColor()),
        ),
      ),
      onSaved: (value) {
        items[index].price =
            double.parse((value == null || value.isEmpty) ? "0" : value);
      },
      validator: (value) {
        if (utils.isNumeric(value ?? "0")) {
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
      initialValue:
          (items[index].quantity == 0) ? "" : items[index].quantity.toString(),
      maxLength: 6,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        labelText: getTranlated(context, 'quantity'),
        counterText: '',
        labelStyle: TextStyle(
            color: (prefs.color == 5) ? Colors.white : utils.cambiarColor()),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: (prefs.color == 5) ? Colors.white : utils.cambiarColor()),
        ),
      ),
      onSaved: (value) {
        items[index].quantity =
            int.parse((value == null || value.isEmpty) ? "0" : value);
      },
      validator: (value) {
        if (utils.isNumeric(value ?? "0")) {
          return null;
        } else {
          return getTranlated(context, 'onlyNumbers');
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
      onSaved: (value) => listaModel.title = value ?? '',
      decoration: InputDecoration(
        labelText: getTranlated(context, 'listName'),
        labelStyle: TextStyle(
            color: (prefs.color == 5) ? Colors.white : utils.cambiarColor()),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: (prefs.color == 5) ? Colors.white : utils.cambiarColor()),
        ),
      ),
    );
  }

  Widget _nombresupermeacdo() {
    return TextFormField(
      //  initialValue: productModel.name,
      maxLength: 20,
      textCapitalization: TextCapitalization.sentences,
      textAlign: TextAlign.center,
      onSaved: (value) => listaModel.superMaret = value ?? '',
      decoration: InputDecoration(
        // counterText: '',
        labelText: getTranlated(context, 'shopName'),
        labelStyle: TextStyle(
            color: (prefs.color == 5) ? Colors.white : utils.cambiarColor()),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: (prefs.color == 5) ? Colors.white : utils.cambiarColor()),
        ),
        // hintText: 'Nombre localidad',
        //hintStyle: TextStyle(color: utils.cambiarColor()),
      ),
    );
  }

  Widget _crearBuget() {
    return TextField(
      maxLength: 6,
      controller: bugetController,
      keyboardType: TextInputType.numberWithOptions(decimal: true),

      decoration: InputDecoration(
        counterText: '',
        hintText: getTranlated(context, 'newBuget'),
        suffixIcon: Icon(
          Icons.account_balance_wallet,
          color: (prefs.color == 5) ? Colors.white : utils.cambiarColor(),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: (prefs.color == 5) ? Colors.white : utils.cambiarColor()),
        ),
      ),

      // onChanged: (value) {
      //   setState(() {});
      //   if (value == null) {
      //     return;
      //   }
      // },
    );
  }

  Widget _header() {
    return Container(
      padding: EdgeInsets.only(left: 5.0, right: 10.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              //color: Theme.of(context).primaryColor,
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () => _mostrarAlertaBuget(context),
                    child: Container(
                      // color: Theme.of(context).primaryColor,
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.account_balance_wallet,
                                        color: (prefs.color == 5)
                                            ? Colors.white
                                            : utils.cambiarColor()),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(getTranlated(context, 'buget'),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold
                                            //color: bugetColor,
                                            )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Column(
                            children: <Widget>[
                              Text(
                                utils.numberFormat(buget),
                                style: TextStyle(
                                    fontSize: 18,
                                    color: (prefs.color == 5)
                                        ? Colors.white
                                        : bugetColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.shopping_cart),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('Total',
                                      style: TextStyle(
                                        fontSize: 16,
                                        //color: bugetColor,
                                      )),
                                ],
                              ),
                            )
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
                                  color: (prefs.color == 5)
                                      ? Colors.white
                                      : utils.cambiarColor(),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.shuffle),
                            SizedBox(
                              width: 5,
                            ),
                            Text(getTranlated(context, 'difference'),
                                style: TextStyle(
                                  fontSize: 16,
                                  //color: bugetColor,
                                )),
                          ],
                        ),
                      ),
                      Spacer(),
                      Text(
                        utils.numberFormat(diference),
                        style: TextStyle(
                            fontSize: 18,
                            color:
                                (prefs.color == 5) ? Colors.white : bugetColor,
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
        future: DBProvider.db.getArticlesTmp('tmp'),
        builder: (context, AsyncSnapshot<List<ProductModel>> snapshot) {
          if (snapshot.hasData && snapshot.data!.length > 0) {
            final tmpArt = snapshot.data;

            items = tmpArt!;
          }
          //TODO:hacer seed para futura sugerencias
          if (items.length == 0) {
            return Card(
                child: Container(
              color: Colors.white,
              child: Column(
                  // padding: EdgeInsets.all(15.0),
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        utils.cambiarNewImage(),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          getTranlated(context, 'noItems'),
                          style: TextStyle(
                            color: utils.cambiarColor(),
                            fontSize: 18,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "",
                              ),
                              WidgetSpan(
                                child: Icon(Icons.add_shopping_cart,
                                    color: utils.cambiarColor()),
                              ),
                              TextSpan(
                                text: " ",
                              ),
                              TextSpan(
                                text: getTranlated(context, 'noItems2'),
                                style: TextStyle(
                                  color: utils.cambiarColor(),
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ]),
            ));
          }

          items.sort(
              (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
          return Expanded(
              child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              _controllers.add(new TextEditingController());
              //var wawa = toBoolean(items[index].complete);
              bool isComplete = (items[index].complete == 1) ? true : false;

              // Verificar si este es el primer item completado
              bool esElPrimeroCompletado =
                  index > 0 && items[index - 1].complete == 0 && isComplete;

              return Column(
                children: [
                  // Separador visual entre items pendientes y completados
                  if (esElPrimeroCompletado)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 1,
                              color: Colors.grey[400],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                                SizedBox(width: 6),
                                Text(
                                  getTranlated(context, 'completed') ??
                                      'Completados',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 1,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),
                  // Item de la lista
                  Dismissible(
                    direction: DismissDirection.endToStart,
                    background: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
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
                      var deletedItem = items[index];
                      //wawa(context, getTranlated(context, 'offLis'), index, deletedItem, items);
                      showDeleteSnack(context, getTranlated(context, 'offLis'),
                          index, deletedItem, items);
                      // utils.showSnack(context,  getTranlated(context, 'offLis'));
                      DBProvider.db.deleteProd(items[index].id);
                      items.removeAt(index);

                      getTotal();
                      getDiference();
                      setState(() {});
                    },
                    // Color(0xff424242)
                    //#595959

                    child: Container(
                      child: Card(
                          elevation: isComplete ? 1 : 2,
                          color: isComplete
                              ? Color(0xffc3c3c3)
                              : prefs.color == 5
                                  ? utils.cambiarColor()
                                  : prefs.darkLightTheme
                                      ? ThemeData.dark().cardColor
                                      : ThemeData().cardColor,
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Text(
                                      items[index].name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        decoration: isComplete
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                        decorationColor: utils.cambiarColor(),
                                        decorationStyle:
                                            TextDecorationStyle.solid,
                                        decorationThickness: 3,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Checkbox(
                                    value: isComplete,
                                    onChanged: (valor) {
                                      HapticFeedback.mediumImpact();
                                      _marcarComoCompletado(
                                          index, valor ?? false);
                                    },
                                    activeColor: isComplete
                                        ? Colors.black
                                        : (prefs.color == 5)
                                            ? Colors.white
                                            : utils.cambiarColor(),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () => _mostrarAlertaEditarProducto(
                                    context, index),
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 0, bottom: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Icon(
                                          Icons.edit,
                                          color: isComplete
                                              ? Colors.black
                                              : (prefs.color == 5)
                                                  ? Colors.white
                                                  : utils.cambiarColor(),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                  utils.numberFormat(
                                                      items[index].price),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(getTranlated(
                                                  context, 'price'))
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
                                                  items[index]
                                                      .quantity
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(getTranlated(
                                                  context, 'quantity'))
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
                                                      items[index].quantity *
                                                          items[index].price),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
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
                              ),
                            ],
                          )),
                    ),
                  ),
                ],
              );
            },
          ));
        });
  }

  // Nueva función para marcar items como completados
  void _marcarComoCompletado(int index, bool valor) {
    int complValue = (valor == true) ? 1 : 0;
    items[index].complete = complValue;
    DBProvider.db.updateProd(items[index]);

    setState(() {
      if (valor == true) {
        // Mover al final
        final ProductModel item = items.removeAt(index);
        items.add(item);
        utils.showSnack(context, getTranlated(context, 'onCart'));
      } else {
        // Si desmarca, reordenar alfabéticamente
        items.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        utils.showSnack(context, getTranlated(context, 'ofCart'));
      }
    });

    updatedCount(valor);
  }

  Widget _bNavbar(BuildContext context) {
    return BottomAppBar(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          //(valor == true) ? 1 : 0;
          onPressed: () => (items.length <= 0) ? null : _guardarLista(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(Icons.save),
              Text(getTranlated(context, 'saveList'))
            ],
          ),
        ),
        TextButton(
          onPressed: () =>
              (items.length <= 0) ? null : _validateEliminarList(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(Icons.remove_circle_outline, color: Colors.red[400]),
              Text(getTranlated(context, 'clearList'))
            ],
          ),
        ),
        TextButton(
          onPressed: () => _mostrarAlertaProducto(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(Icons.add_shopping_cart,
                  color:
                      (prefs.color == 5) ? Colors.white : utils.cambiarColor()),
              //Text(getTranlated(context, 'clearList'))
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: Text(getTranlated(context, 'deleteCont')),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    getTranlated(context, 'leave'),
                    style: TextStyle(
                        color: (prefs.color == 5)
                            ? Colors.white
                            : utils.cambiarColor()),
                  )),
              TextButton(
                  onPressed: () => limpiarTodo(),
                  child: Text(
                    getTranlated(context, 'accept'),
                    style: TextStyle(
                        color: (prefs.color == 5)
                            ? Colors.white
                            : utils.cambiarColor()),
                  )),
            ],
          );
        });
  }

  _validateGuardaroEliminarList(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: Column(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 48,
                ),
                SizedBox(height: 12),
                Text(
                  getTranlated(context, 'listComplete') ?? '¡Lista completada!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            // content: Text(
            //   '¿Qué deseas hacer con esta lista?',
            //   textAlign: TextAlign.center,
            //   style: TextStyle(fontSize: 16),
            // ),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton.icon(
                    onPressed: () =>
                        {Navigator.of(context).pop(), _guardarLista(context)},
                    icon: Icon(Icons.save, color: Colors.white),
                    label: Text(
                      getTranlated(context, 'save'),
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: (prefs.color == 5)
                          ? Colors.white.withOpacity(0.9)
                          : utils.cambiarColor(),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                  SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () => {
                      Navigator.of(context).pop(),
                      _validateEliminarList(context),
                    },
                    icon: Icon(Icons.delete_outline, color: Colors.red),
                    label: Text(
                      getTranlated(context, 'clearList'),
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.red),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                  SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      getTranlated(context, 'leave'),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }

  // _validateGuardaroEliminarList(BuildContext context) {
  //   return showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (context) {
  //         return AlertDialog(
  //           shape:
  //               RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  //           title: Row(
  //             children: [
  //               Icon(
  //                 Icons.check_circle,
  //                 color: Colors.green,
  //                 size: 28,
  //               ),
  //               SizedBox(width: 10),
  //               Expanded(
  //                 child: Text(getTranlated(context, 'listComplete') ??
  //                     '¡Lista completada!'),
  //               ),
  //             ],
  //           ),
  //           content: Text(
  //             getTranlated(context, 'listCompleteMessage') ??
  //                 '¿Qué deseas hacer con esta lista?',
  //           ),
  //           actions: <Widget>[
  //             TextButton.icon(
  //               onPressed: () => {
  //                 Navigator.of(context).pop(),
  //                 _validateEliminarList(context),
  //               },
  //               icon: Icon(Icons.delete_outline, color: Colors.red),
  //               label: Text(
  //                 getTranlated(context, 'clearList'),
  //                 style: TextStyle(color: Colors.red),
  //               ),
  //             ),
  //             TextButton.icon(
  //               onPressed: () => Navigator.of(context).pop(),
  //               icon: Icon(Icons.close),
  //               label: Text(
  //                 getTranlated(context, 'leave'),
  //                 style: TextStyle(
  //                   color: (prefs.color == 5) ? Colors.white : Colors.grey[700],
  //                 ),
  //               ),
  //             ),
  //             ElevatedButton.icon(
  //               onPressed: () =>
  //                   {Navigator.of(context).pop(), _guardarLista(context)},
  //               icon: Icon(Icons.save),
  //               label: Text(getTranlated(context, 'save')),
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor:
  //                     (prefs.color == 5) ? Colors.white : utils.cambiarColor(),
  //               ),
  //             ),
  //           ],
  //         );
  //       });
  // }

  limpiarTodo() {
    setState(() {
      DBProvider.db.deleteAllTempProd('tmp');
      items.clear();
      total = 0.00;
      buget = 0.00;
      diference = 0.00;
      totalItems = 0;
      _dialogoCompletadoMostrado = false;

      // También resetear las preferencias temporales
      prefs.tempTotal = '0.00';
      prefs.tempBuget = '0.00';

      // Actualizar colores
      bugetColor = utils.cambiarColor();
      colorBuget = utils.cambiarColor();
    });
    Navigator.of(context).pop();
  }

  saveBudget(String value) {
    if (value.isEmpty) {
      return;
    }

    buget = double.parse(value);
    prefs.tempBuget = buget.toString();
    getTotal();
    bugetController.clear();
    setState(() {});
  }

  saveList() async {
    String lisId = uuid.v4();
    //DBProvider.db.deleteAllTempProd();
    lisForm.currentState!.save();
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

    await DBProvider.db.nuevoLista(nuevaLista);

    for (var i = 0; i < items.length; i++) {
      items[i].listId = nuevaLista.id;

      await DBProvider.db.updateProd(items[i]);
    }

    items = [];
    lisForm.currentState!.reset();
    _dialogoCompletadoMostrado = false; // Resetear flag
  }

  void _guardarLista(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: Text(getTranlated(context, 'saveList')),
            content: Form(
              key: lisForm,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[_nombrelista(), _nombresupermeacdo()],
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    getTranlated(context, 'leave'),
                    style: TextStyle(
                        color: (prefs.color == 5)
                            ? Colors.white
                            : utils.cambiarColor()),
                  )),
              TextButton(
                  onPressed: () {
                    saveList();
                    Navigator.pushNamed(context, 'home');
                    prefs.tempTotal = '0.00';
                    prefs.tempBuget = '0.00';
                  },
                  child: Text(
                    getTranlated(context, 'save'),
                    style: TextStyle(
                        color: (prefs.color == 5)
                            ? Colors.white
                            : utils.cambiarColor()),
                  )),
            ],
          );
        });
  }

  void updatedCount(bool value) {
    // Calculamos directamente los items completados en lugar de usar un contador
    int completados = items.where((item) => item.complete == 1).length;

    // Verificar si todos están completados
    if (completados == items.length &&
        items.isNotEmpty &&
        !_dialogoCompletadoMostrado) {
      _dialogoCompletadoMostrado = true;

      // Pequeño delay para mejor UX
      Future.delayed(Duration(milliseconds: 500), () {
        if (mounted) {
          showcompletedSnack(
              context,
              getTranlated(context, 'listComplete') ??
                  'Lista de compra completa');
          _validateGuardaroEliminarList(context);
        }
      });
    } else if (completados < items.length) {
      // Si desmarca alguno, resetear el flag
      _dialogoCompletadoMostrado = false;
    }
  }

  void showDeleteSnack(BuildContext context, String msg, int index,
      ProductModel item, List<ProductModel> items) {
    Flushbar(
      //title: 'This action is prohibited',
      message: msg,
      icon: Icon(
        Icons.info_outline,
        size: 28,
        color: (prefs.color == 5) ? Colors.white : utils.cambiarColor(),
      ),
      mainButton: TextButton(
        onPressed: () {
          //_undoProd(item, index);
          DBProvider.db.tmpProd(item);
          DBProvider.db.getArticlesTmp('tmp');
          var it = items.length;
          items.insert(it, item);
          setState(() {});
        },
        child: Text(
          getTranlated(context, 'undo'),
          style: TextStyle(
              color: (prefs.color == 5) ? Colors.white : Colors.amber),
        ),
      ),
      leftBarIndicatorColor:
          (prefs.color == 5) ? Colors.white : utils.cambiarColor(),
      duration: Duration(seconds: 3),
    )..show(context);
  }

  void showcompletedSnack(BuildContext context, String msg) {
    Flushbar(
      //title: 'This action is prohibited',
      message: msg,
      icon: Icon(
        Icons.check_circle,
        size: 28,
        color: Colors.green,
      ),
      leftBarIndicatorColor: Colors.green,
      duration: Duration(seconds: 2),
    )..show(context);
  }
}
