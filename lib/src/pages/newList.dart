//Navigator.pushNamed(context, 'quickList');
import 'package:flutter/material.dart';

class NewList extends StatefulWidget {
  NewList({Key key}) : super(key: key);

  @override
  _NewListState createState() => _NewListState();
}

class _NewListState extends State<NewList> {
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
      body: Container(),
      bottomNavigationBar: __bNavbar(),
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
}

Widget __bNavbar() {
  return BottomNavigationBar(items: [
    BottomNavigationBarItem(
              icon: Icon(Icons.monetization_on), 
              title: Text(
                'Presupuesto: 50,000',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0))),
    BottomNavigationBarItem(
      
        icon: Icon(Icons.monetization_on),
        title: Text(
          'Total : 10,000.00',
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
    child: Column(
      children: <Widget>[
        TextField(
          decoration: InputDecoration(
              labelText: 'Producto',
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                color: Color.fromRGBO(255, 111, 94, 1),
              ))),
        ),
        TextField(
            decoration: InputDecoration(
                labelText: 'Precio',
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                  color: Color.fromRGBO(255, 111, 94, 1),
                ))),
            keyboardType: TextInputType.number),
        // TextField(
        //     decoration: InputDecoration(
        //         labelText: 'Cantidad',
        //         focusedBorder: UnderlineInputBorder(
        //             borderSide: BorderSide(
        //           color: Color.fromRGBO(255, 111, 94, 1),
        //         ))),
        //     keyboardType: TextInputType.number),
        FlatButton(
          onPressed: () {},
          color: Color.fromRGBO(255, 111, 94, 1),
          child: Text(
            'Guardar',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );
}
