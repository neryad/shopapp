//Navigator.pushNamed(context, 'newList');
//import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopapp/src/models/product_model.dart';
import 'package:shopapp/src/utils/utils.dart' as utils;
// import 'package:shopapp/src/widgets/counter.dart';
// import 'package:intl/intl.dart';

class NewList extends StatefulWidget {
  NewList({Key key}) : super(key: key);

  @override
  _NewListState createState() => _NewListState();
}

class _NewListState extends State<NewList> {
  double buget = 00.00;
  double total = 0.00;
  double diference = 0.00;
  
  Color colorBuget = Color.fromRGBO(255, 111, 94, 1);
  Color bugetColor = Color.fromRGBO(255, 111, 94, 1);
  // String bugetText = "Presupuesto";
  TextEditingController _articlesCtrl = new TextEditingController();

  // List<dynamic> items = [
  //   {"name": "pan", "price": 0.00, "quantity": 0},
  //   {"name": "cafe", "price": 0.00, "quantity": 0},
  //   {"name": "desodorante", "price": 888.58, "quantity": 0}
  // ];

  List<ProductModel> items = [];

  final formKey = GlobalKey<FormState>();
  ProductModel productModel = new ProductModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 200),
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(color: Colors.black12, spreadRadius: 5, blurRadius: 2)
            ]),
            width: MediaQuery.of(context).size.width,
            height: 140,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                      child: Column(
                        children: <Widget>[
                          FlatButton.icon(
                              onPressed: () => _mostrarAlerta(context),
                              icon: Icon(Icons.account_balance_wallet),
                              label: Text("Presupuesto")),
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
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                      child: Column(
                        children: <Widget>[
                          FlatButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.shopping_cart),
                              label: Text("Total")),
                          Text(
                            utils.numberFormat(total),
                            style: TextStyle(
                                fontSize: 20,
                                color: Color.fromRGBO(255, 111, 94, 1),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Container(
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                      child: Column(
                        children: <Widget>[
                          FlatButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.shuffle),
                              label: Text("Diferencia")),
                          Text(
                            utils.numberFormat(diference),
                            style: TextStyle(
                                fontSize: 20,
                                color: colorBuget,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Column(
          
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                     background: Card(color: Colors.red,elevation: 4, margin: EdgeInsets.all(15),),
                     // key: UniqueKey(),
                      key: Key('items[index]'),
                        
       direction: DismissDirection.horizontal,
       onDismissed: (direction) {
          setState(() {
              items.removeAt(index);
              getTotal();
            });
        
       },
                    child: Card(
                      
                      elevation: 4,
                      margin: EdgeInsets.all(15),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        height: 50.00,
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceAround,

                          children: <Widget>[
                            Expanded(
                                flex: 2,
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Icon(Icons.add_shopping_cart,
                                          color:
                                              Color.fromRGBO(255, 111, 94, 1)),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        child: Text(
                                          items[index].name,
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
                                          InputDecoration(hintText: '0.0'),
                                      keyboardType: TextInputType.number,
                                      onChanged: (text) {
                                        items[index].price =
                                            num.parse(text).toDouble();
                                        setState(() {
                                          getTotal();
                                        });
                                      },
                                    )),
                                    // SizedBox(
                                    //   width: 5,
                                    // ),
                                    Expanded(
                                        // flex: 1,
                                        child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                            items[index].quantity.toString(),
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
                                            items[index].quantity *
                                                items[index].price,
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
                    ),
                  );
                },
              ),
            ),
            _newProducto(),
          ],
        ));
  }

  _sumProduct(int index) {
    setState(() {
      items[index].quantity++;
      getTotal();
    });
  }

  _resProduct(int index) {
    setState(() {
      if (items[index].quantity == 0) {
        return;
      }
      items[index].quantity--;

      getTotal();
    });
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
            bugetColor = Color.fromRGBO(255, 111, 94, 1);
          }
        });
      }
    }
  }

  void getDiference() {
    double calDiferecen = buget - total;
    if (calDiferecen < 0) {
      colorBuget = Colors.red[900];
    } else if (calDiferecen == 0) {
      colorBuget = Color.fromRGBO(255, 111, 94, 1);
    } else {
      colorBuget = Colors.green[400];
    }
    diference = calDiferecen;
  }

  void _mostrarAlerta(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(' Presupuesto'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _crearIpunt(),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancelar')),
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Aceptar')),
            ],
          );
        });
  }

  Widget _crearIpunt() {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'Ingresar nuevo presupuesto',
        suffixIcon: Icon(
          Icons.account_balance_wallet,
          color: Color.fromRGBO(255, 111, 94, 1),
        ),
        //       enabledBorder: UnderlineInputBorder(
        // borderSide: BorderSide(color: Color.fromRGBO(255, 111, 94, 1)),
        // ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(255, 111, 94, 1)),
        ),
      ),
      onChanged: (value) {
        if (value == null) {
          return;
        } else {
          buget = double.parse(value);
        }
      },
    );
  }

  Widget _newProducto() {
    var it = items.length;
    return Container(
      color: Colors.white60,
      child: TextField(
      textAlign: TextAlign.center,
      
        controller: _articlesCtrl,
        onSubmitted: (text) {
          // insertar(it,text);
          items.insert(
              it, new ProductModel(name: text, quantity: 1, price: 0.00));
          _articlesCtrl.clear();
          setState(() {});
        },
        decoration: InputDecoration(

           focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(255, 111, 94, 1)),
        ),

          hintText: 'Nuevo articulo',
          hintStyle: TextStyle( color: Color.fromRGBO(255, 111, 94, 1)),
          
         //border:  OutlineInputBorder(),
        ),
      ),
    );
  }

}
