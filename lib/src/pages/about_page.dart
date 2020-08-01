import 'package:flutter/material.dart';
import 'package:shopapp/src/widgets/Menu_widget.dart';
import 'package:shopapp/src/utils/utils.dart' as utils;

class AboutPage extends StatelessWidget {
  const AboutPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: utils.cambiarColor(),
          title: Text(
            'Acerca de',
          ),
          elevation: 0.0,
        ),
        drawer: MenuWidget(),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(color: utils.cambiarColor()),
                child: Container(
                    width: double.infinity,
                    height: 300,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            radius: 55,
                            backgroundColor: Colors.black38,
                            child: CircleAvatar(
                              backgroundImage: AssetImage(
                                  'assets/undraw_online_groceries_a02y.png'),
                              radius: 50.0,
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            'AppName',
                            style:
                                TextStyle(fontSize: 22.0, color: Colors.white),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 8.0),
                            clipBehavior: Clip.antiAlias,
                            color: Colors.white,
                            elevation: 8.0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 22.0, vertical: 8.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Text('Version',
                                            style: TextStyle(
                                                color: utils.cambiarColor(),
                                                fontSize: 22.0,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text('0.0.1',
                                            style: TextStyle(
                                                color: utils.cambiarColor(),
                                                fontSize: 22.0,
                                                fontWeight: FontWeight.w200)),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Text('Author',
                                            style: TextStyle(
                                                color: utils.cambiarColor(),
                                                fontSize: 22.0,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text('Neryad',
                                            style: TextStyle(
                                                color: utils.cambiarColor(),
                                                fontSize: 22.0,
                                                fontWeight: FontWeight.w200)),
                                      ],
                                    ),
                                  ),
                                  //          Expanded(
                                  //         child: Column(
                                  //         children: <Widget>[
                                  //           Text('Version',style:TextStyle(
                                  //             color: Colors.redAccent,
                                  //             fontSize: 22.0,
                                  //             fontWeight: FontWeight.bold
                                  //           )),
                                  //             SizedBox(
                                  //   height: 10.0,
                                  // ),
                                  //           Text('1.0.0',style:TextStyle(
                                  //             color: Colors.redAccent,
                                  //             fontSize: 22.0,
                                  //             fontWeight: FontWeight.w200
                                  //           )),
                                  //       ],
                                  //       ),
                                  //       ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
              Card(
                child: Container(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Descripción",
                        style: TextStyle(
                            color: utils.cambiarColor(),
                            fontStyle: FontStyle.normal,
                            fontSize: 28.0),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        "AppName es una simple aplicación para ayudar de forma simple y con mejor manejo a las personas con sus listas de compras. © 2020 Neryad. Todos los derechos reservados",
                        style: TextStyle(
                            fontSize: 20.0,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            letterSpacing: 2.0),
                      ),
                    ],
                  ),
                )),
              ),
            ],
          ),
        ));
  }
}
