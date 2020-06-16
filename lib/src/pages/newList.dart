//Navigator.pushNamed(context, 'quickList');
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopapp/src/models/product_model.dart';
import 'package:shopapp/src/provider/dummy_provider.dart';
import 'package:shopapp/src/utils/utils.dart' as utils;
import 'package:shopapp/src/widgets/counter.dart';
import 'package:intl/intl.dart';

class NewList extends StatefulWidget {
  final Counter counter;
  NewList({Key key, this.counter}) : super(key: key);

  @override
  _NewListState createState() => _NewListState();
}

class _NewListState extends State<NewList> {
  double buget = 00.00;
  double total = 0.00;
  int itemTotal = 0;
  

  List<dynamic> items = [
    {"name": "pan", "price": 20.5, "quantity": 0},
    {"name": "cafe", "price": 10.15, "quantity": 0},
    {"name": "desodorante", "price": 888.58, "quantity": 0}
  ];

  final formKey = GlobalKey<FormState>();
  ProductModel productModel = new ProductModel();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New list',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0.0,
        backgroundColor: Color.fromRGBO(255, 111, 94, 1),
        iconTheme: new IconThemeData(color: Color.fromRGBO(255, 111, 94, 1)),
      ),
      backgroundColor: Colors.white,
      
      body: Container(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
                key: Key('items[index]'),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    elevation: 5.0,
                    child: Container(
                      height: 50.00,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Icon(Icons.shopping_cart,
                              color: Color.fromRGBO(255, 111, 94, 1)),

                          Text(items[index]['name']),
                          Container(
                              width: 50.0,
                              child: TextField(
                                
                                  onChanged: (text) {
                                    items[index]['price'] = num.parse(text);
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration:
                                      InputDecoration(hintText: 'precio'),
                                  style: TextStyle(

                                      // fontSize: 40.0,
                                      height: 2.0,
                                      color: Colors.black))),
                          //Text(items[index]['price'].toString()),
                          Container(
                            width: 20.0,
                            height: 20.0,
                            child: FloatingActionButton(
                              backgroundColor: Color.fromRGBO(255, 111, 94, 1),
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 15.0,
                              ),
                              onPressed: () {
                                _sumProduct(index);
                              
                              },
                            ),
                          ),
                          Text(items[index]['quantity'].toString()),
                         
                          Container(
                            width: 20.0,
                            height: 20.0,
                            child: FloatingActionButton(
                              backgroundColor: Color.fromRGBO(255, 111, 94, 1),
                              child: Icon(
                                Icons.remove,
                                color: Colors.white,
                                size: 15.0,
                              ),
                              onPressed: () {
                                _resProduct(index);
                              },
                            ),
                          ),
                           Text(utils.numberFormat((items[index]['quantity'] * items[index]['price']))),
                        ],
                      ),
                    ),
                  ),
                ));
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 80.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buget(),
              Icon(Icons.swap_horiz),
              _total(),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: __bNavbar(buget, total),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   heroTag: null,
      //   onPressed: () => {
      //     _settingModalBottomSheet(context)
      //   }, //_settingModalBottomSheet(context),
      //   child: Icon(Icons.add_shopping_cart),
      //   backgroundColor: Color.fromRGBO(255, 111, 94, 1),
      // ),
    );
  }
//}

  Widget __bNavbar(double buget, double total) {
    return Container();
    // return BottomNavigationBar(items: [
    //   BottomNavigationBarItem(
    //       icon: Icon(Icons.monetization_on),
    //       title: Text('Presupuesto: $buget',
    //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0))),
    //   BottomNavigationBarItem(
    //       icon: Icon(Icons.monetization_on),
    //       title: Text(
    //         'Total : $total',
    //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
    //       )),
    // ]);
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
          children: <Widget>[_crearNombre(), _crearPrecio(), _crearBoton()],
        ),
      ),
    );
  }

  Widget _crearPrecio() {
    return TextFormField(
      initialValue: '',
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: 'Precio'),
      onSaved: (value) => productModel.price = double.parse(value),
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
    if (!formKey.currentState.validate()) {
      return;
    }

    formKey.currentState.save();
    items.add(productModel.name);
    print('object');
    print(productModel.name);
    print(productModel.price);
  }

  _sumProduct(int index) {
    setState(() {
      items[index]['quantity']++;
      getTotal();
    });
  }
// int _iteTotal(int index){
//   num sum = 0;
// for (num e in [1,2,3]) {
//   sum += e;

//   print(sum);
// }
// return sum;
// //   int mmg;
// //  if (items[index]['quantity'] == 0) {
// //       itemTotal = 0;
// //       for (int i = 0; i < items.length; i++) {
// //         setState(() {
// //           mmg =  items[i]['quantity'];
// //           print( items[i]['quantity']);
// //           return mmg;
// //           //total = num.parse(total.toStringAsFixed(2));
// //            //itemTotal = (items[i]['price'] * items[i]['quantity']);
// //           //  format(total);
// //         });
// //       }
// //     }
// }
  _resProduct(int index) {
    setState(() {
      if (items[index]['quantity'] == 0) {
        return;
      }
      items[index]['quantity']--;
      itemTotal = items[index]['quantity'];
      getTotal();
    });
  }

  void getTotal() {
    if (items != null) {
      total = 0;
      for (int i = 0; i < items.length; i++) {
        setState(() {
          total += (items[i]['price'] * items[i]['quantity']);
          //total = num.parse(total.toStringAsFixed(2));
           //itemTotal = (items[i]['price'] * items[i]['quantity']);
          //  format(total);
          // double value = 1000000;
          //   print(numberFormat(total));
          //   total = numberFormat()


        });
      }
    }
  }
String numberFormat(double x) {
  List<String> parts = x.toString().split(',');
  RegExp re = RegExp(r'\B(?=(\d{3})+(?!\d))');

  parts[0] = parts[0].replaceAll(re, ',');
  if (parts.length == 1) {
    // parts.add('00');
  } else {
    parts[1] = parts[1].padRight(2, '0').substring(0, 2);
  }
  return parts.join(',');
}
  Widget _buget() {
    return Container(
        child: Column(
      children: <Widget>[
        Icon(Icons.account_balance_wallet),
        Text(utils.numberFormat(total)),
      ],
    ));
  }

  Widget _total() {
    return Container(
        padding: EdgeInsets.symmetric(),
        child: Column(
          children: <Widget>[
            Icon(Icons.monetization_on),
            Text(  utils.numberFormat(total)),
          ],
        ));
  }
}
