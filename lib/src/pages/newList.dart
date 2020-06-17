//Navigator.pushNamed(context, 'quickList');
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopapp/src/models/product_model.dart';
import 'package:shopapp/src/provider/dummy_provider.dart';
import 'package:shopapp/src/utils/utils.dart' as utils;
import 'package:shopapp/src/widgets/counter.dart';
import 'package:intl/intl.dart';

class NewList extends StatefulWidget {
 
  NewList({Key key}) : super(key: key);

  @override
  _NewListState createState() => _NewListState();
}

class _NewListState extends State<NewList> {
  double buget =3000.00;
  double total = 0.00;


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
      appBar:PreferredSize(
        preferredSize: Size(double.infinity, 100),
        
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(
              color: Colors.black12,
              spreadRadius: 5,
              blurRadius: 2
            )]
          ),
          width: MediaQuery.of(context).size.width,
          height: 140,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
            ),
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: Row(
                
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                     padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                     margin: EdgeInsets.symmetric(horizontal: 10),
                     child: Column(children:<Widget>[
                    FlatButton.icon(onPressed: (){}, icon: Icon(Icons.account_balance_wallet), label: Text("Presupuesto")),
                    Text(utils.numberFormat(buget),style: TextStyle(fontSize: 20,color:  Color.fromRGBO(255, 111, 94, 1)),),
                    ], ), 
                  ),
  //                 Container(
  //                   child: Text('Nueva compra',overflow: TextOverflow.ellipsis, style: TextStyle(
  //   decoration: TextDecoration.underline, fontWeight: FontWeight.w900, fontSize: 15
  // )),
  //                 ),
                    //Text("Foodbar",style: TextStyle(fontSize: 30,color: Colors.white),),
                 Container(
                   padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                   margin: EdgeInsets.symmetric(horizontal: 10),
                   child:  Column(children:<Widget>[
                    FlatButton.icon(onPressed: (){}, icon: Icon(Icons.shopping_cart), label: Text("Total")),
                    Text(utils.numberFormat(total),style: TextStyle(fontSize: 20,color:  Color.fromRGBO(255, 111, 94, 1)),),
                    ], ),
                 ),
                  
                 // Icon(Icons.navigate_before,size: 40,color: Colors.white,),
                
                  //Icon(Icons.navigate_before,color: Colors.transparent,),
                ],
              ),
            ),
          ),
        ),
      ),

      body: Container(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
                key: Key('items[index]'),
                child: Card(
                  elevation: 4,
                  margin: EdgeInsets.all(15),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    height: 50.00,
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceAround,

                      children: <Widget>[
                        Expanded(
                            flex: 2,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  child: Icon(Icons.add_shopping_cart,
                                      color: Color.fromRGBO(255, 111, 94, 1)),
                                ),
                                Expanded(
                                  flex:1,
                                  child: Container(
                                    child: Text(
                                      items[index]['name'],
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                   // flex: 2,
                                    child: TextField(
                                      decoration:
                                          InputDecoration(hintText: 'precio'),
                                      keyboardType: TextInputType.number,
                                      onChanged: (text) {
                                        items[index]['price'] =
                                            num.parse(text);
                                      },
                                    )),
                                // SizedBox(
                                //   width: 5,
                                // ),
                                Expanded(
                                    // flex: 1,
                                    child: Row(
                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 2,
                                          child: FloatingActionButton(
                                            backgroundColor:
                                                Color.fromRGBO(255, 111, 94, 1),
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
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            "88",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: FloatingActionButton(
                                            backgroundColor:
                                                Color.fromRGBO(255, 111, 94, 1),
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
                                      ],
                                    )),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Text(
                                      utils.numberFormat(
                                        items[index]['quantity'] *
                                            items[index]['price'],
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ))
                      ],
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
              FlatButton(onPressed: (){}, 
              child: null,
              
              )
              // _buget(),
              // Icon(Icons.swap_horiz),
              // _total(),
              
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

  _resProduct(int index) {
    setState(() {
      if (items[index]['quantity'] == 0) {
        return;
      }
      items[index]['quantity']--;
      
      getTotal();
    });
  }

  void getTotal() {
    if (items != null) {
      total = 0;
      for (int i = 0; i < items.length; i++) {
        setState(() {
          total += (items[i]['price'] * items[i]['quantity']);
        });
      }
    }
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
            Text(utils.numberFormat(total)),
          ],
        ));
  }
}
