//Navigator.pushNamed(context, 'quickList');
import 'package:flutter/material.dart';
import 'package:shopapp/src/models/product_model.dart';
import 'package:shopapp/src/utils/utils.dart' as utils;

class NewList extends StatefulWidget {
  NewList({Key key}) : super(key: key);

  @override
  _NewListState createState() => _NewListState();
}

class _NewListState extends State<NewList> {
  double buget = 50.00;
  double total = 50.00;
  final formKey = GlobalKey<FormState>();
  ProductModel productModel = new ProductModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New list',
          style: TextStyle(color: Color.fromRGBO(255, 111, 94, 1)),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: new IconThemeData(color: Color.fromRGBO(255, 111, 94, 1)),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(padding: EdgeInsets.all(15.0), child: Center()),
      ),
      bottomNavigationBar: __bNavbar(buget, total),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          _settingModalBottomSheet(context)
        }, //_settingModalBottomSheet(context),
        child: Icon(Icons.add_shopping_cart),
        backgroundColor: Color.fromRGBO(255, 111, 94, 1),
      ),
    );
  }
//}

  Widget __bNavbar(double buget, double total) {
    return BottomNavigationBar(items: [
      BottomNavigationBarItem(
          icon: Icon(Icons.monetization_on),
          title: Text('Presupuesto: $buget',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0))),
      BottomNavigationBarItem(
          icon: Icon(Icons.monetization_on),
          title: Text(
            'Total : $total',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          )),
    ]);
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: _Fromularios()),
                  SizedBox(height: 5),
                ],
              ),
            ));
  }

  Widget _Fromularios() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            _crearNombre(),
            _crearPrecio(),
            _crearBoton()
          ],
        ),
      ),
    );
  }

  Widget _crearPrecio() {
    return TextFormField(
      initialValue: '',
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: 'Precio'),
       onSaved: (value) => productModel.price = double.parse( value),
      validator: (value) {
        if (utils.isNumeric(value)) {
          return null;
        } else {
          return 'No se permiten campos vacios';
        }
      },
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: productModel.name,
      decoration: InputDecoration(labelText: 'Producto'),
      onSaved: (value) => productModel.name = value,
      validator: (value) {
        if (value.length < 3) {
          return 'No se permiten campos vacios';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearBoton() {
    return FlatButton.icon(
      icon: Icon(
        Icons.save,
        color: Colors.white,
      ),
      label: Text('Guardar', style: TextStyle(color: Colors.white)),
      onPressed: _submit,
      color: Color.fromRGBO(255, 111, 94, 1),
    );
  }

  void _submit() {
    if(!formKey.currentState.validate()){
        return;
    }

    formKey.currentState.save();

    print('object');
    print(productModel.name);
    print(productModel.price);
  }
}
