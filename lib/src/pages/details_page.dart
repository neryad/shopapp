import 'package:flutter/material.dart';
import 'package:shopapp/src/models/List_model.dart';
import 'package:shopapp/src/models/product_model.dart';
import 'package:shopapp/src/providers/db_provider.dart';
import 'package:shopapp/src/utils/utils.dart' as utils;
import 'package:shopapp/src/widgets/Menu_widget.dart';
class DetailsPage extends StatefulWidget {
 final  Lista savelist;
  DetailsPage({Key key, this.savelist}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
 
 //@override
 List<ProductModel> articulos = [];
  Widget build(BuildContext context) {
    // Lista listaModel = widget.savelist;
      Lista listaModel = widget.savelist;
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
            backgroundColor: utils.cambiarColor(),
            title: Text(
              listaModel.id.toString(),
            )),
        drawer: MenuWidget(),
        body: Column(children: <Widget>[
          _bodyWidget(listaModel.id)
        ],)
        
        // SingleChildScrollView(
        //   child: Column(
        //     children: <Widget>[
        //       Container(
        //         decoration: BoxDecoration(color: utils.cambiarColor()
        //             // gradient: LinearGradient(
        //             //     begin: Alignment.topCenter,
        //             //     end: Alignment.bottomCenter,
        //             //     colors: [utils.cambiarColor(), Colors.blueGrey])
        //             ),
        //         child: Container(
        //             width: double.infinity,
        //             height: 300,
        //             child: Center(
        //               child: Column(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 crossAxisAlignment: CrossAxisAlignment.center,
        //                 children: <Widget>[
        //                   CircleAvatar(
        //                     backgroundImage: AssetImage(
        //                         'assets/undraw_online_groceries_a02y.png'),

        //                     // NetworkImage(
        //                     //     'https://cdn.the-scientist.com/assets/articleNo/67431/hImg/37292/lemur-wrist-glands-scent-pheromones-primates-testosterone-mating-breeding-sexual-communication-x.png'
        //                     //     ),
        //                     radius: 50.0,
        //                   ),
        //                   SizedBox(
        //                     height: 20.0,
        //                   ),
        //                   Text(
        //                     widget.savelist.id.toString(),
        //                     style:
        //                         TextStyle(fontSize: 22.0, color: Colors.white),
        //                   ),
        //                   SizedBox(
        //                     height: 10.0,
        //                   ),
        //                   Card(
        //                     margin: EdgeInsets.symmetric(
        //                         horizontal: 20.0, vertical: 8.0),
        //                     clipBehavior: Clip.antiAlias,
        //                     color: Colors.white,
        //                     elevation: 8.0,
        //                     child: Padding(
        //                       padding: const EdgeInsets.symmetric(
        //                           horizontal: 22.0, vertical: 8.0),
        //                       child: Row(
        //                         children: <Widget>[
        //                           Expanded(
        //                             child: Column(
        //                               children: <Widget>[
        //                                 Text('Version',
        //                                     style: TextStyle(
        //                                         color: utils.cambiarColor(),
        //                                         fontSize: 22.0,
        //                                         fontWeight: FontWeight.bold)),
        //                                 SizedBox(
        //                                   height: 10.0,
        //                                 ),
        //                                 Text('0.0.1',
        //                                     style: TextStyle(
        //                                         color: utils.cambiarColor(),
        //                                         fontSize: 22.0,
        //                                         fontWeight: FontWeight.w200)),
        //                               ],
        //                             ),
        //                           ),
        //                           Expanded(
        //                             child: Column(
        //                               children: <Widget>[
        //                                 Text('Author',
        //                                     style: TextStyle(
        //                                         color: utils.cambiarColor(),
        //                                         fontSize: 22.0,
        //                                         fontWeight: FontWeight.bold)),
        //                                 SizedBox(
        //                                   height: 10.0,
        //                                 ),
        //                                 Text('Neryad',
        //                                     style: TextStyle(
        //                                         color: utils.cambiarColor(),
        //                                         fontSize: 22.0,
        //                                         fontWeight: FontWeight.w200)),
        //                               ],
        //                             ),
        //                           ),
        //                           //          Expanded(
        //                           //         child: Column(
        //                           //         children: <Widget>[
        //                           //           Text('Version',style:TextStyle(
        //                           //             color: Colors.redAccent,
        //                           //             fontSize: 22.0,
        //                           //             fontWeight: FontWeight.bold
        //                           //           )),
        //                           //             SizedBox(
        //                           //   height: 10.0,
        //                           // ),
        //                           //           Text('1.0.0',style:TextStyle(
        //                           //             color: Colors.redAccent,
        //                           //             fontSize: 22.0,
        //                           //             fontWeight: FontWeight.w200
        //                           //           )),
        //                           //       ],
        //                           //       ),
        //                           //       ),
        //                         ],
        //                       ),
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             )),
        //       ),
        //       Container(
        //           child: Padding(
        //         padding:
        //             const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: <Widget>[
        //             Text(
        //               "Descripción",
        //               style: TextStyle(
        //                   color: utils.cambiarColor(),
        //                   fontStyle: FontStyle.normal,
        //                   fontSize: 28.0),
        //             ),
        //             SizedBox(height: 10.0),
        //             Text(
        //               "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum vel orci nec tellus mattis sodales sit amet id est. Praesent ut tempor ligula. Nullam venenatis, risus vel tristique viverra, nibh diam vehicula eros, eu hendrerit magna massa at velit. Mauris ultrices nulla eget nunc rutrum, eu porttitor orci iaculis.",
        //               style: TextStyle(
        //                   fontSize: 20.0,
        //                   fontStyle: FontStyle.italic,
        //                   fontWeight: FontWeight.w300,
        //                   color: Colors.black,
        //                   letterSpacing: 2.0),
        //             ),
        //           ],
        //         ),
        //       )),
        //     ],
        //   ),
        );
  }
   _bodyWidget(String id) {
    return FutureBuilder<List<ProductModel>>(
        // builder: null
        future: DBProvider.db.getprodId(id),
        builder: (context, AsyncSnapshot<List<ProductModel>> snapshot) {
          if (snapshot.hasData && snapshot.data.length > 0) {
            final art = snapshot.data;

            articulos = art;
          }

          if (articulos.length == 0) {
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

          articulos.sort((a, b) => a.name.compareTo(b.name));

          return Expanded(
              child: ListView.builder(
            itemCount: articulos.length,
            itemBuilder: (BuildContext context, int index) {
              //_controllers.add(new TextEditingController());
              //var wawa = toBoolean(articulos[index].complete);
              bool isComplete = (articulos[index].complete == 1) ? true : false;
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
                key: Key(articulos[index].name + articulos.length.toString()),
                onDismissed: (direction) {
                  utils.showSnack(context, 'Artículo eliminado de la lista');
                 // DBProvider.db.deleteTmpProd(articulos[index].id);
                  articulos.removeAt(index);

                  // getTotal();
                  // getDiference();
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
                            articulos[index].name,
                            style: TextStyle(fontWeight: FontWeight.w900),
                            textAlign: TextAlign.start,
                          ),
                          Spacer(),
                          Checkbox(
                            value: isComplete,
                            onChanged: (valor) {
                              int complValue = (valor == true) ? 1 : 0;
                              articulos[index].complete = complValue;
                              DBProvider.db.updatetempProd(articulos[index]);
                              setState(() {});

                              (valor == true)
                                  ? utils.showSnack(
                                      context, 'Artículo agregado al carrito')
                                  : utils.showSnack(context,
                                      'Artículo removido del carrito'); //   showSnack(context, 'Artículo agregado');
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
                          //_mostrarAlertaEditarProducto(context, index);
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
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(utils.numberFormat(articulos[index].price),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text('Precio')
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
                                    Text(articulos[index].quantity.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text('Cantidad')
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
                                            articulos[index].quantity *
                                                articulos[index].price),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
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
                    ],
                  )),
                ),
              );
            },
          ));
        });
  }
}
