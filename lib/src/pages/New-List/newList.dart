import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocketlist/src/Shared_Prefs/Preferencias_user.dart';
import 'package:pocketlist/src/localization/localization_constant.dart';
import 'package:pocketlist/src/models/List_model.dart';
import 'package:pocketlist/src/models/category_model.dart';
import 'package:pocketlist/src/models/product_model.dart';
import 'package:pocketlist/src/providers/db_provider.dart';
import 'package:pocketlist/src/utils/utils.dart' as utils;
import 'package:uuid/uuid.dart';

const int kColorGray = 5;

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

  // Categories state
  List<CategoryModel> _categories = [];
  int? _filterCategoryId; // null = show all, -1 = show "no category"
  bool _sortByCategory = false;
  int? _newItemCategoryId; // selected category when adding a new item
  int? _editItemCategoryId; // selected category when editing

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

    _loadCategories();
    _loadItems();
  }

  Future<void> _loadCategories() async {
    final cats = await DBProvider.db.getCategories();
    if (mounted) setState(() => _categories = cats);
  }

  Future<void> _loadItems() async {
    final data = await (isNewList
        ? DBProvider.db.getArticlesTmp('tmp')
        : DBProvider.db.getProdId(listId));
    if (mounted) {
      setState(() {
        items = data;
      });
      getTotal();
    }
  }

  final formKey = GlobalKey<FormState>();
  final editFormKey = GlobalKey<FormState>();
  final lisForm = GlobalKey<FormState>();

  Color colorBuget = Colors.blue;
  Color bugetColor = Colors.blue;
  final bugetController = TextEditingController();

  var uuid = Uuid();

  List<ProductModel> items = [];
  ProductModel productModel = ProductModel();
  late Lista listaModel = Lista();

  // Getters para items completados y pendientes
  int get itemsCompletados => items.where((item) => item.complete == 1).length;
  int get itemsPendientes => items.where((item) => item.complete == 0).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: isNewList
            ? Text(getTranslated(context, 'mMyLisTitle'))
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
                    tooltip: getTranslated(context, 'resetList'),
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
        total += (items[i].price * items[i].quantity);
      }
      getDiference();
      if (total > buget && buget > 0) {
        bugetColor = Colors.red[900]!;
      } else {
        bugetColor = Theme.of(context).colorScheme.primary;
      }

      setState(() {});

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
      colorBuget = Theme.of(context).colorScheme.primary;
    } else {
      colorBuget = Theme.of(context).colorScheme.primary;
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
                      color: Theme.of(context).colorScheme.primary,
                      size: 28,
                    ),
                    SizedBox(width: 12),
                    Text(
                      getTranslated(context, 'buget'),
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
                    labelText: getTranslated(context, 'newBuget'),
                    prefixIcon: Icon(Icons.attach_money),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
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
                      child: Text(getTranslated(context, 'baclTolist')),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        saveBudget(budgetController.text);
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        getTranslated(context, 'save'),
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
    _newItemCategoryId = null;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(builder: (context, setDialogState) {
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
                            color: Theme.of(context).colorScheme.primary,
                            size: 28),
                        SizedBox(width: 12),
                        Text(
                          getTranslated(context, 'newArt'),
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
                    if (_categories.isNotEmpty) ...[
                      SizedBox(height: 16),
                      DropdownButtonFormField<int?>(
                        initialValue: _newItemCategoryId,
                        decoration: InputDecoration(
                          labelText: getTranslated(context, 'categories'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2),
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: [
                          DropdownMenuItem<int?>(
                            value: null,
                            child: Text(getTranslated(context, 'noCategory'),
                                style: TextStyle(color: Colors.grey[600])),
                          ),
                          ..._categories.map((cat) => DropdownMenuItem<int?>(
                                value: cat.id,
                                child: Row(
                                  children: [
                                    Text(cat.icon,
                                        style: TextStyle(fontSize: 16)),
                                    SizedBox(width: 8),
                                    Text(cat.name),
                                  ],
                                ),
                              )),
                        ],
                        onChanged: (val) =>
                            setDialogState(() => _newItemCategoryId = val),
                      ),
                    ],
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            productModel = ProductModel();
                            Navigator.of(context).pop();
                          },
                          child: Text(getTranslated(context, 'baclTolist')),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            _submit();
                            getTotal();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            getTranslated(context, 'add'),
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
        });
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
        if (value == null || value.trim().isEmpty) {
          return getTranslated(context, 'noEmpty');
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: getTranslated(context, 'nameArt'),
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
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
        labelText: getTranslated(context, 'price'),
        counterText: '',
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
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
          return getTranslated(context, 'onlyNumbers');
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
        labelText: getTranslated(context, 'quantity'),
        counterText: '',
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
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
          return getTranslated(context, 'onlyNumbers');
        }
      },
      keyboardType: TextInputType.numberWithOptions(decimal: true),
    );
  }

  void _submit() async {
    var it = items.length;
    if (!formKey.currentState!.validate()) return;

    formKey.currentState!.save();
    var prod = ProductModel(
        name: productModel.name,
        quantity: productModel.quantity,
        listId: listId,
        price: productModel.price,
        complete: 0,
        categoryId: _newItemCategoryId);

    // Optimistic update
    setState(() {
      items.insert(it, prod);
    });

    try {
      final insertedId = await DBProvider.db.newProd(prod);
      prod.id = insertedId;
    } catch (e) {
      setState(() {
        items.removeWhere((item) => item.name == prod.name && item.listId == prod.listId);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(getTranslated(context, 'errorSaveProduct'))),
        );
      }
    }

    productModel = ProductModel();
    _newItemCategoryId = null;

    formKey.currentState!.reset();
    myFocusNode.requestFocus();
  }

  void _mostrarAlertaEditarProducto(BuildContext context, int index) {
    _editItemCategoryId = items[index].categoryId;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              title: Text(getTranslated(context, 'EupdArt')),
              content: Form(
                key: editFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _editarNombreArticulo(index),
                    _editarcantidadArticulo(index),
                    _editarPrecioArticulo(index),
                    if (_categories.isNotEmpty) ...[
                      SizedBox(height: 12),
                      DropdownButtonFormField<int?>(
                        initialValue: _editItemCategoryId,
                        decoration: InputDecoration(
                          labelText: getTranslated(context, 'categories'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: [
                          DropdownMenuItem<int?>(
                            value: null,
                            child: Text(getTranslated(context, 'noCategory'),
                                style: TextStyle(color: Colors.grey[600])),
                          ),
                          ..._categories.map((cat) => DropdownMenuItem<int?>(
                                value: cat.id,
                                child: Row(
                                  children: [
                                    Text(cat.icon,
                                        style: TextStyle(fontSize: 16)),
                                    SizedBox(width: 8),
                                    Text(cat.name),
                                  ],
                                ),
                              )),
                        ],
                        onChanged: (val) =>
                            setDialogState(() => _editItemCategoryId = val),
                      ),
                    ],
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      getTranslated(context, 'leave'),
                      style: TextStyle(
                          color: (prefs.color == kColorGray)
                              ? Colors.white
                              : Theme.of(context).colorScheme.primary),
                    )),
                TextButton(
                    onPressed: () {
                      _editSubmit(index);
                      getTotal();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      getTranslated(context, 'save'),
                      style: TextStyle(
                          color: (prefs.color == kColorGray)
                              ? Colors.white
                              : Theme.of(context).colorScheme.primary),
                    )),
              ],
            );
          });
        });
  }

  void _editSubmit(int index) async {
    editFormKey.currentState!.save();
    items[index].categoryId = _editItemCategoryId;
    await DBProvider.db.updateProd(items[index]);

    if (!isNewList) {
      _updateLista();
    }
    setState(() {});
  }

  Widget _editarNombreArticulo(int index) {
    return TextFormField(
      initialValue: items[index].name,
      maxLength: 33,
      textCapitalization: TextCapitalization.sentences,
      textAlign: TextAlign.center,
      onSaved: (value) => items[index].name = value ?? '',
      decoration: InputDecoration(
        labelText: getTranslated(context, 'nameArt'),
        counterText: '',
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
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
        labelText: getTranslated(context, 'price'),
        counterText: '',
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
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
          return getTranslated(context, 'onlyNumbers');
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
        labelText: getTranslated(context, 'quantity'),
        counterText: '',
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
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
          return getTranslated(context, 'onlyNumbers');
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
        labelText: getTranslated(context, 'listName'),
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
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
        labelText: getTranslated(context, 'shopName'),
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
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
            label: getTranslated(context, 'buget'),
            value: utils.numberFormat(buget),
            color: bugetColor,
            onTap: () => _mostrarAlertaBuget(context),
          ),
          Divider(height: 16, thickness: 1),
          _buildStatRow(
            icon: Icons.shopping_cart,
            label: getTranslated(context, 'total'),
            value: utils.numberFormat(total),
            color: Theme.of(context).colorScheme.primary,
          ),
          Divider(height: 16, thickness: 1),
          _buildStatRow(
            icon: Icons.shuffle,
            label: getTranslated(context, 'difference'),
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
    if (items.length == 0) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.shopping_cart_outlined,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                ),
              ),
              SizedBox(height: 24),
              Text(
                getTranslated(context, 'noItems'),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.color
                      ?.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                getTranslated(context, 'noItems2'),
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => _mostrarAlertaProducto(context),
                icon: Icon(Icons.add, color: Colors.white),
                label: Text(
                  getTranslated(context, 'addFirstItem'),
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
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

    // ── Apply filter ──────────────────────────────────────
    final displayItems = items.where((item) {
      if (_filterCategoryId == null) return true;
      if (_filterCategoryId == -1) return item.categoryId == null;
      return item.categoryId == _filterCategoryId;
    }).toList();

    // ── Apply sort ────────────────────────────────────────
    displayItems.sort((a, b) {
      if (a.complete != b.complete) {
        return a.complete.compareTo(b.complete);
      }
      if (_sortByCategory) {
        final aCatName = _categories
            .firstWhere((c) => c.id == a.categoryId,
                orElse: () => CategoryModel(name: ''))
            .name;
        final bCatName = _categories
            .firstWhere((c) => c.id == b.categoryId,
                orElse: () => CategoryModel(name: ''))
            .name;
        final catCmp = aCatName.compareTo(bCatName);
        if (catCmp != 0) return catCmp;
      }
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });

    // ── Category chip filter bar ──────────────────────────
    final hasCategories =
        _categories.isNotEmpty && items.any((i) => i.categoryId != null);

    return Expanded(
      child: Column(
        children: [
          if (hasCategories || _sortByCategory)
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                children: [
                  // Filter chips
                  if (hasCategories)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                      child: Row(
                        children: [
                          // "All" chip
                          Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: FilterChip(
                              label: Text(
                                  getTranslated(context, 'filterByCategory')),
                              selected: _filterCategoryId == null,
                              onSelected: (_) =>
                                  setState(() => _filterCategoryId = null),
                              selectedColor: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.2),
                              checkmarkColor:
                                  Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          // Per-category chips
                          ..._categories
                              .where((cat) =>
                                  items.any((i) => i.categoryId == cat.id))
                              .map((cat) => Padding(
                                    padding: const EdgeInsets.only(right: 6),
                                    child: FilterChip(
                                      avatar: Text(cat.icon,
                                          style: const TextStyle(fontSize: 14)),
                                      label: Text(cat.name),
                                      selected: _filterCategoryId == cat.id,
                                      onSelected: (_) => setState(() =>
                                          _filterCategoryId =
                                              _filterCategoryId == cat.id
                                                  ? null
                                                  : cat.id),
                                      selectedColor:
                                          utils.cambiarColor().withOpacity(0.2),
                                      checkmarkColor:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  )),
                          // "No category" chip
                          if (items.any((i) => i.categoryId == null))
                            Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: FilterChip(
                                label:
                                    Text(getTranslated(context, 'noCategory')),
                                selected: _filterCategoryId == -1,
                                onSelected: (_) => setState(() =>
                                    _filterCategoryId =
                                        _filterCategoryId == -1 ? null : -1),
                                selectedColor: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.2),
                                checkmarkColor:
                                    Theme.of(context).colorScheme.primary,
                              ),
                            ),
                        ],
                      ),
                    ),
                  // Sort toggle row
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
                    child: Row(
                      children: [
                        Icon(Icons.sort,
                            size: 16, color: Theme.of(context).hintColor),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () => setState(() => _sortByCategory = false),
                          child: Text(
                            getTranslated(context, 'sortAlpha'),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: !_sortByCategory
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: !_sortByCategory
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).disabledColor,
                            ),
                          ),
                        ),
                        Text('  ·  ',
                            style: TextStyle(
                                color: Theme.of(context).dividerColor)),
                        GestureDetector(
                          onTap: () => setState(() => _sortByCategory = true),
                          child: Text(
                            getTranslated(context, 'sortByCategory'),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: _sortByCategory
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: _sortByCategory
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey[500],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: displayItems.length,
              itemBuilder: (BuildContext context, int index) {
                // Map displayItems index back to items index
                final itemIndex = items.indexOf(displayItems[index]);
                final item = displayItems[index];
                bool isComplete = item.complete == 1;

                bool esElPrimeroCompletado = index > 0 &&
                    displayItems[index - 1].complete == 0 &&
                    isComplete;

                // Category label for this item
                final itemCat = item.categoryId != null
                    ? _categories.firstWhere((c) => c.id == item.categoryId,
                        orElse: () => CategoryModel(name: '', icon: ''))
                    : null;

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
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    size: 16,
                                    color: Theme.of(context).disabledColor,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    getTranslated(context, 'completed'),
                                    style: TextStyle(
                                      color: Theme.of(context).disabledColor,
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
                                color: Theme.of(context).dividerColor,
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
                                Icon(Icons.delete, color: Colors.white),
                                Text(
                                  getTranslated(context, 'delete'),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                                SizedBox(width: 20),
                              ],
                            ),
                            alignment: Alignment.centerRight,
                          ),
                        ),
                      ),
                      key: Key(item.id.toString()),
                      onDismissed: (direction) {
                        showDeleteSnack(
                            context,
                            getTranslated(context, 'offLis'),
                            itemIndex,
                            item,
                            items);
                        DBProvider.db.deleteProd(item.id);
                        items.removeAt(itemIndex);
                        getTotal();
                        getDiference();
                        setState(() {});
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isComplete
                              ? Theme.of(context)
                                  .disabledColor
                                  .withOpacity(0.12)
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
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              decoration: isComplete
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none,
                                              decorationColor: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              decorationThickness: 2,
                                            ),
                                          ),
                                          if (itemCat != null &&
                                              itemCat.name.isNotEmpty)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 2),
                                              child: Row(
                                                children: [
                                                  Text(itemCat.icon,
                                                      style: TextStyle(
                                                          fontSize: 11)),
                                                  SizedBox(width: 3),
                                                  Text(
                                                    itemCat.name,
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall
                                                          ?.color
                                                          ?.withOpacity(0.6),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    Transform.scale(
                                      scale: 1.2,
                                      child: Checkbox(
                                        value: isComplete,
                                        onChanged: (valor) {
                                          HapticFeedback.mediumImpact();
                                          _marcarComoCompletado(
                                              itemIndex, valor ?? false);
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        activeColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () => _mostrarAlertaEditarProducto(
                                    context, itemIndex),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: isComplete
                                        ? Theme.of(context)
                                            .disabledColor
                                            .withOpacity(0.1)
                                        : utils
                                            .cambiarColor()
                                            .withOpacity(0.05),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      _buildItemDetail(
                                        icon: Icons.attach_money,
                                        label: getTranslated(context, 'price'),
                                        value: utils.numberFormat(item.price),
                                      ),
                                      Container(
                                          width: 1,
                                          height: 30,
                                          color: Theme.of(context)
                                              .dividerColor
                                              .withOpacity(0.2)),
                                      _buildItemDetail(
                                        icon: Icons.shopping_basket,
                                        label:
                                            getTranslated(context, 'quantity'),
                                        value: item.quantity.toString(),
                                      ),
                                      Container(
                                          width: 1,
                                          height: 30,
                                          color: Theme.of(context)
                                              .dividerColor
                                              .withOpacity(0.2)),
                                      _buildItemDetail(
                                        icon: Icons.calculate,
                                        label: getTranslated(context, 'total'),
                                        value: utils.numberFormat(
                                            item.quantity * item.price),
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
            ),
          ),
        ],
      ),
    );
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

  void _marcarComoCompletado(int index, bool valor) async {
    int complValue = valor ? 1 : 0;
    items[index].complete = complValue;
    await DBProvider.db.updateProd(items[index]);

    setState(() {});

    updatedCount(valor);

    utils.showSnack(
      context,
      valor ? getTranslated(context, 'onCart') : getTranslated(context, 'ofCart'),
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
                label: getTranslated(context, 'saveList'),
                onPressed: items.isEmpty ? null : () => _guardarLista(context),
                color: Colors.green,
              ),
              _buildNavButton(
                icon: Icons.delete_outline,
                label: getTranslated(context, 'clearList'),
                onPressed:
                    items.isEmpty ? null : () => _validateEliminarList(context),
                color: Colors.red,
              ),
            ] else
              Spacer(),

            FloatingActionButton(
              onPressed: () => _mostrarAlertaProducto(context),
              backgroundColor: Theme.of(context).colorScheme.primary,
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
            title: Text(getTranslated(context, 'deleteCont')),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    getTranslated(context, 'leave'),
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  )),
              TextButton(
                  onPressed: () => limpiarTodo(),
                  child: Text(
                    getTranslated(context, 'accept'),
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
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
            getTranslated(context, 'resetList') ?? 'Reiniciar lista',
          ),
          content: Text(
            getTranslated(context, 'resetListConfirm') ??
                '¿Deseas desmarcar todos los artículos completados?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(getTranslated(context, 'leave')),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetCompletedItems();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                getTranslated(context, 'accept'),
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
                  getTranslated(context, 'listComplete'),
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
                        getTranslated(context, 'save'),
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: (prefs.color == kColorGray)
                            ? Colors.white.withOpacity(0.9)
                            : Theme.of(context).colorScheme.primary,
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
                      getTranslated(context, 'clearList'),
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
                      getTranslated(context, 'resetList') ?? 'Reiniciar lista',
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
                      getTranslated(context, 'leave'),
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
      getTranslated(context, 'itemsReset') ?? 'Lista reiniciada',
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

      bugetColor = Theme.of(context).colorScheme.primary;
      colorBuget = Theme.of(context).colorScheme.primary;
    });
    Navigator.of(context).pop();
  }

  saveBudget(String value) {
    if (value.isEmpty) {
      return;
    }

    final parsed = double.tryParse(value);
    if (parsed == null) return;

    buget = parsed;

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

    try {
      await DBProvider.db.nuevoLista(nuevaLista);

      for (var i = 0; i < items.length; i++) {
        items[i].listId = nuevaLista.id;
      }
      await DBProvider.db.updateProdsBatch(items);

      items = [];
      lisForm.currentState!.reset();
      _dialogoCompletadoMostrado = false;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(getTranslated(context, 'errorSaveList'))),
        );
      }
    }
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
            title: Text(getTranslated(context, 'saveList')),
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
                    getTranslated(context, 'leave'),
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  )),
              TextButton(
                  onPressed: () async {
                    await saveList();
                    Navigator.pushNamed(context, 'home');
                    prefs.tempTotal = '0.00';
                    prefs.tempBuget = '0.00';
                  },
                  child: Text(
                    getTranslated(context, 'save'),
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
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
              getTranslated(context, 'listComplete') ??
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        action: SnackBarAction(
          label: getTranslated(context, 'undo'),
          textColor: (prefs.color == kColorGray)
              ? Colors.white
              : Colors.amber,
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
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void showcompletedSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, size: 20, color: Colors.green),
            SizedBox(width: 8),
            Text(msg),
          ],
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
