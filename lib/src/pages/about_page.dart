import 'package:flutter/material.dart';
import 'package:shopapp/src/widgets/Menu_widget.dart';
import 'package:shopapp/src/utils/utils.dart' as utils;

class AboutPage extends StatelessWidget {
  const AboutPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
            backgroundColor: utils.cambiarColor(),
            title: Text(
              'Acerca de',
            )),
        drawer: MenuWidget(),
        body: SingleChildScrollView(
                  child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.redAccent, Colors.pink])),
                child: Container(
                    width: double.infinity,
                    height: 300,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                                'https://cdn.the-scientist.com/assets/articleNo/67431/hImg/37292/lemur-wrist-glands-scent-pheromones-primates-testosterone-mating-breeding-sexual-communication-x.png'),
                            radius: 50.0,
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            'AppName',
                            style: TextStyle(fontSize: 22.0, color: Colors.white),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Card(
                            margin: EdgeInsets.symmetric(horizontal: 20.0, vertical:8.0),
                            clipBehavior: Clip.antiAlias,
                            color: Colors.white,
                            elevation: 8.0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical:8.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                    children: <Widget>[
                                      Text('Version',style:TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold
                                      )),
                                        SizedBox(
                              height: 10.0,
                          ),
                                      Text('1.0.0',style:TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w200
                                      )),
                                  ],
                                  ),
                                  ),
                                     Expanded(
                                    child: Column(
                                    children: <Widget>[
                                      Text('Author',style:TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold
                                      )),
                                        SizedBox(
                              height: 10.0,
                          ),
                                      Text('Neryad',style:TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w200
                                      )),
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
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical:8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                    Text("Descripción",
                    style:TextStyle(
                      color: Colors.redAccent,
                      fontStyle: FontStyle.normal,
                      fontSize: 28.0
                    ),
                    ),
                    SizedBox(height:10.0),
                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum vel orci nec tellus mattis sodales sit amet id est. Praesent ut tempor ligula. Nullam venenatis, risus vel tristique viverra, nibh diam vehicula eros, eu hendrerit magna massa at velit. Mauris ultrices nulla eget nunc rutrum, eu porttitor orci iaculis.",
                      style: TextStyle(
                        fontSize:20.0,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                        letterSpacing: 2.0
                        
                      ),
                    ),
                  ],
                  ),
               ) ),
            ],
          ),
        ));
  }
}
