import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocketlist/src/Shared_Prefs/Prefrecias_user.dart';
import 'package:pocketlist/src/localization/localization_constant.dart';
import 'package:pocketlist/src/models/List_model.dart';
import 'package:pocketlist/src/models/product_model.dart';
import 'package:pocketlist/src/models/suge.dart';
import 'package:pocketlist/src/providers/db_provider.dart';
import 'package:pocketlist/src/utils/utils.dart' as utils;
import 'package:uuid/uuid.dart';
import 'package:another_flushbar/flushbar.dart';

class ShoppingListPage extends StatefulWidget {
  final Lista? existingList; // null = nueva lista, no-null = editar lista

  ShoppingListPage({Key? key, this.existingList}) : super(key: key);

  @override
  _ShoppingListPageState createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  late bool isNewList;
  late String listId;

  double buget = 0.00;
  double total = 0.00;
  double diference = 0.00;
  int totalItems = 0;
  bool checkValue = false;
  bool _dialogoCompletadoMostrado = false;
  FocusNode myFocusNode = FocusNode();

  final prefs = PreferenciasUsuario();

  @override
  void initState() {
    super.initState();

    isNewList = widget.existingList == null;

    if (isNewList) {
      // Modo: Nueva lista
      listId = 'tmp';
      total = double.parse(prefs.tempTotal);
      buget = double.parse(prefs.tempBuget);
    } else {
      // Modo: Editar lista existente
      listId = widget.existingList!.id;
      buget = widget.existingList!.buget;
      total = widget.existingList!.total;
      diference = widget.existingList!.diference;
      listaModel = widget.existingList!;
    }
  }

  final formKey = GlobalKey<FormState>();
  final editFormKey = GlobalKey<FormState>();
  final lisForm = GlobalKey<FormState>();

  Color colorBuget = utils.cambiarColor();
  Color bugetColor = utils.cambiarColor();
  final bugetController = TextEditingController();

  var uuid = Uuid();

  List<ProductModel> items = [];
  List<TextEditingController> _controllers = [];
  ProductModel productModel = ProductModel();
  Segurencia sugeModel = Segurencia();
  late Lista listaModel = Lista();

  // Getters para items completados y pendientes
  int get itemsCompletados => items.where((item) => item.complete == 1).length;
  int get itemsPendientes => items.where((item) => item.complete == 0).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: utils.cambiarColor(),
        title: isNewList
            ? Text(getTranlated(context, 'mMyLisTitle'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    listaModel.title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  if (listaModel.superMaret.isNotEmpty)
                    Text(
                      listaModel.superMaret,
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                    ),
                ],
              ),
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

                if (itemsCompletados > 0)
                  IconButton(
                    icon: Icon(Icons.refresh),
                    tooltip:
                        getTranlated(context, 'resetList') ?? 'Reiniciar lista',
                    onPressed: _confirmResetCompleted,
                  ),

                // Mostrar fecha solo en listas guardadas
                if (!isNewList && items.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.calendar_today, size: 14),
                          SizedBox(width: 6),
                          Text(
                            listaModel.fecha,
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
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

      if (isNewList) {
        prefs.tempTotal = total.toString();
      } else {
        listaModel.total = total;
        _updateLista();
      }
    }
  }

  void getDiference() {
    if (total == 0) {
      diference = buget;
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

    if (!isNewList) {
      listaModel.diference = diference;
    }
  }

  void _mostrarAlertaBuget(BuildContext context) {
    final budgetController = TextEditingController(
      text: buget > 0 ? buget.toString() : '',
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet,
                      color: utils.cambiarColor(),
                      size: 28,
                    ),
                    SizedBox(width: 12),
                    Text(
                      getTranlated(context, 'buget'),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                TextField(
                  controller: budgetController,
                  maxLength: 6,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  autofocus: true,
                  decoration: InputDecoration(
                    counterText: '',
                    labelText: getTranlated(context, 'newBuget'),
                    prefixIcon: Icon(Icons.attach_money),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: utils.cambiarColor(),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(getTranlated(context, 'baclTolist')),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        saveBudget(budgetController.text);
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: utils.cambiarColor(),
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        getTranlated(context, 'save'),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _mostrarAlertaProducto(BuildContext context) {
    productModel = ProductModel();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.add_shopping_cart,
                          color: utils.cambiarColor(), size: 28),
                      SizedBox(width: 12),
                      Text(
                        getTranlated(context, 'newArt'),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  _crearNombreArticulo(),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _crearcantidadArticulo()),
                      SizedBox(width: 16),
                      Expanded(child: _crearPrecioArticulo()),
                    ],
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          productModel = ProductModel();
                          Navigator.of(context).pop();
                        },
                        child: Text(getTranlated(context, 'baclTolist')),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          _subimt();
                          getTotal();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: utils.cambiarColor(),
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          getTranlated(context, 'add'),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
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
        listId: listId, // Usa el listId correcto (tmp o id real)
        price: productModel.price,
        complete: 0);
    items.insert(it, prod);
    DBProvider.db.newProd(prod);

    productModel = ProductModel();

    formKey.currentState!.reset();
    setState(() {});
    myFocusNode.requestFocus();
  }

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

    if (!isNewList) {
      _updateLista();
    }
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
    return TextFormField(
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
      maxLength: 20,
      textCapitalization: TextCapitalization.sentences,
      textAlign: TextAlign.center,
      onSaved: (value) => listaModel.superMaret = value ?? '',
      decoration: InputDecoration(
        labelText: getTranlated(context, 'shopName'),
        labelStyle: TextStyle(
            color: (prefs.color == 5) ? Colors.white : utils.cambiarColor()),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: (prefs.color == 5) ? Colors.white : utils.cambiarColor()),
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      margin: EdgeInsets.all(12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildStatRow(
            icon: Icons.account_balance_wallet,
            label: getTranlated(context, 'buget'),
            value: utils.numberFormat(buget),
            color: bugetColor,
            onTap: () => _mostrarAlertaBuget(context),
          ),
          Divider(height: 16, thickness: 1),
          _buildStatRow(
            icon: Icons.shopping_cart,
            label: 'Total',
            value: utils.numberFormat(total),
            color: utils.cambiarColor(),
          ),
          Divider(height: 16, thickness: 1),
          _buildStatRow(
            icon: Icons.shuffle,
            label: getTranlated(context, 'difference'),
            value: utils.numberFormat(diference),
            color: colorBuget,
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            Spacer(),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _bodyWidget() {
    return FutureBuilder<List<ProductModel>>(
        future: isNewList
            ? DBProvider.db.getArticlesTmp('tmp')
            : DBProvider.db.getProdId(listId),
        builder: (context, AsyncSnapshot<List<ProductModel>> snapshot) {
          if (snapshot.hasData && snapshot.data!.length > 0) {
            final tmpArt = snapshot.data;
            items = tmpArt!;
          }

          if (items.length == 0) {
            return Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: utils.cambiarColor().withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.shopping_cart_outlined,
                        size: 80,
                        color: utils.cambiarColor().withOpacity(0.5),
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      getTranlated(context, 'noItems'),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      getTranlated(context, 'noItems2'),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                    SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: () => _mostrarAlertaProducto(context),
                      icon: Icon(Icons.add),
                      label: Text('Agregar primer artículo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: utils.cambiarColor(),
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          items.sort((a, b) {
            if (a.complete != b.complete) {
              return a.complete.compareTo(b.complete);
            }
            return a.name.toLowerCase().compareTo(b.name.toLowerCase());
          });

          return Expanded(
              child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              _controllers.add(new TextEditingController());
              bool isComplete = (items[index].complete == 1) ? true : false;

              bool esElPrimeroCompletado =
                  index > 0 && items[index - 1].complete == 0 && isComplete;

              return Column(
                children: [
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
                    key: Key(items[index].id.toString()),
                    onDismissed: (direction) {
                      var deletedItem = items[index];
                      showDeleteSnack(context, getTranlated(context, 'offLis'),
                          index, deletedItem, items);
                      DBProvider.db.deleteProd(items[index].id);
                      items.removeAt(index);

                      getTotal();
                      getDiference();
                      setState(() {});
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isComplete
                            ? Color(0xFFE8E8E8)
                            : Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: isComplete
                            ? []
                            : [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      items[index].name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        decoration: isComplete
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                        decorationColor: utils.cambiarColor(),
                                        decorationThickness: 2,
                                      ),
                                    ),
                                  ),
                                  Transform.scale(
                                    scale: 1.2,
                                    child: Checkbox(
                                      value: isComplete,
                                      onChanged: (valor) {
                                        HapticFeedback.mediumImpact();
                                        _marcarComoCompletado(
                                            index, valor ?? false);
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      activeColor: utils.cambiarColor(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () =>
                                  _mostrarAlertaEditarProducto(context, index),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: isComplete
                                      ? Colors.grey.withOpacity(0.1)
                                      : utils.cambiarColor().withOpacity(0.05),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildItemDetail(
                                      icon: Icons.attach_money,
                                      label: getTranlated(context, 'price'),
                                      value: utils
                                          .numberFormat(items[index].price),
                                    ),
                                    Container(
                                        width: 1,
                                        height: 30,
                                        color: Colors.grey[300]),
                                    _buildItemDetail(
                                      icon: Icons.shopping_basket,
                                      label: getTranlated(context, 'quantity'),
                                      value: items[index].quantity.toString(),
                                    ),
                                    Container(
                                        width: 1,
                                        height: 30,
                                        color: Colors.grey[300]),
                                    _buildItemDetail(
                                      icon: Icons.calculate,
                                      label: 'Total',
                                      value: utils.numberFormat(
                                        items[index].quantity *
                                            items[index].price,
                                      ),
                                      highlight: true,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ));
        });
  }

  Widget _buildItemDetail({
    required IconData icon,
    required String label,
    required String value,
    bool highlight = false,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: Colors.grey[600]),
            SizedBox(width: 4),
            Text(
              value,
              style: TextStyle(
                fontWeight: highlight ? FontWeight.bold : FontWeight.w600,
                fontSize: highlight ? 16 : 15,
              ),
            ),
          ],
        ),
        SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  void _marcarComoCompletado(int index, bool valor) {
    int complValue = valor ? 1 : 0;
    items[index].complete = complValue;
    DBProvider.db.updateProd(items[index]);

    setState(() {});

    updatedCount(valor);

    utils.showSnack(
      context,
      valor ? getTranlated(context, 'onCart') : getTranlated(context, 'ofCart'),
    );
  }

  Widget _bNavbar(BuildContext context) {
    return BottomAppBar(
      elevation: 8,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Solo mostrar botones de guardar/limpiar en nueva lista
            if (isNewList) ...[
              _buildNavButton(
                icon: Icons.save_outlined,
                label: getTranlated(context, 'saveList'),
                onPressed: items.isEmpty ? null : () => _guardarLista(context),
                color: Colors.green,
              ),
              _buildNavButton(
                icon: Icons.delete_outline,
                label: getTranlated(context, 'clearList'),
                onPressed:
                    items.isEmpty ? null : () => _validateEliminarList(context),
                color: Colors.red,
              ),
            ] else
              Spacer(),

            FloatingActionButton(
              onPressed: () => _mostrarAlertaProducto(context),
              backgroundColor: utils.cambiarColor(),
              child: Icon(Icons.add_shopping_cart, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    required Color color,
  }) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: onPressed == null ? Colors.grey : color),
      label: Text(
        label,
        style: TextStyle(
          color: onPressed == null ? Colors.grey : color,
          fontWeight: FontWeight.w500,
        ),
      ),
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
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

  void _confirmResetCompleted() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            getTranlated(context, 'resetList') ?? 'Reiniciar lista',
          ),
          content: Text(
            getTranlated(context, 'resetListConfirm') ??
                '¿Deseas desmarcar todos los artículos completados?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(getTranlated(context, 'leave')),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetCompletedItems();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: utils.cambiarColor(),
              ),
              child: Text(
                getTranlated(context, 'accept'),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
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
                  getTranlated(context, 'listComplete'),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (isNewList)
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
                  if (isNewList) SizedBox(height: 8),
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
                  SizedBox(height: 5),
                  TextButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: Text(
                      getTranlated(context, 'resetList') ?? 'Reiniciar lista',
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _resetCompletedItems();
                    },
                  ),
                  SizedBox(height: 5),
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

  void _resetCompletedItems() async {
    for (var item in items) {
      if (item.complete == 1) {
        item.complete = 0;
        await DBProvider.db.updateProd(item);
      }
    }

    setState(() {
      _dialogoCompletadoMostrado = false;
    });

    utils.showSnack(
      context,
      getTranlated(context, 'itemsReset') ?? 'Lista reiniciada',
    );
  }

  limpiarTodo() {
    setState(() {
      if (isNewList) {
        DBProvider.db.deleteAllTempProd('tmp');
        prefs.tempTotal = '0.00';
        prefs.tempBuget = '0.00';
        buget = 0.00;
      } else {
        DBProvider.db.deleteAllProdByListId(listId);
      }

      items.clear();
      total = 0.00;
      diference = 0.00;
      totalItems = 0;
      _dialogoCompletadoMostrado = false;

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

    if (isNewList) {
      prefs.tempBuget = buget.toString();
    } else {
      listaModel.buget = buget;
      _updateLista();
    }

    getTotal();
    setState(() {});
  }

  saveList() async {
    String lisId = uuid.v4();
    lisForm.currentState!.save();
    DateTime now = DateTime.now();
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
    _dialogoCompletadoMostrado = false;
  }

  void _updateLista() {
    if (!isNewList) {
      DateTime now = DateTime.now();
      var fecha = '${now.day}/${now.month}/${now.year}';

      final updateLista = Lista(
        id: listaModel.id,
        title: listaModel.title,
        superMaret: listaModel.superMaret,
        fecha: fecha,
        total: total,
        diference: diference,
        buget: buget,
      );

      DBProvider.db.updateList(updateLista);
    }
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
    int completados = items.where((item) => item.complete == 1).length;

    if (completados == items.length &&
        items.isNotEmpty &&
        !_dialogoCompletadoMostrado) {
      _dialogoCompletadoMostrado = true;

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
      _dialogoCompletadoMostrado = false;
    }
  }

  void showDeleteSnack(BuildContext context, String msg, int index,
      ProductModel item, List<ProductModel> items) {
    Flushbar(
      message: msg,
      icon: Icon(
        Icons.info_outline,
        size: 28,
        color: (prefs.color == 5) ? Colors.white : utils.cambiarColor(),
      ),
      mainButton: TextButton(
        onPressed: () {
          if (isNewList) {
            DBProvider.db.tmpProd(item);
            DBProvider.db.getArticlesTmp('tmp');
          } else {
            DBProvider.db.newProd(item);
          }
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
