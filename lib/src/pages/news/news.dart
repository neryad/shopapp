import 'package:PocketList/src/Shared_Prefs/Prefrecias_user.dart';
import 'package:flutter/material.dart';
import 'package:PocketList/src/widgets/Menu_widget.dart';
import 'package:PocketList/src/utils/utils.dart' as utils;
import 'package:PocketList/src/localization/localization_constant.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final prefs = new PreferenciasUsuario();

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  @override
  void initState() {
    _initPackageInfo();
    //getBuildAndVersion();
    //prefs.ultimaPagina = 'about';
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        //backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: utils.cambiarColor(),
          title: Text(getTranlated(context, 'mNewsTitle')),
          elevation: 0.0,
        ),
        // drawer: MenuWidget(),
        body: Container(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(color: utils.cambiarColor()),
                child: Container(
                    width: double.infinity,
                    height: 100,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            getTranlated(context, 'fanNTitel'),
                            style:
                                TextStyle(fontSize: 22.0, color: Colors.white),
                          ),
                          Text(
                            'Version:${_packageInfo.version}',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                        ],
                      ),
                    )),
              ),
              Expanded(
                  child: ListView(
                children: [
                  // ListTile(
                  //   title: Text(getTranlated(context, 'new1'),
                  //       style: TextStyle(
                  //         fontSize: 16.0,
                  //         fontWeight: FontWeight.bold,
                  //       )),
                  //   trailing: ElevatedButton(
                  //     style:
                  //         ElevatedButton.styleFrom(primary: Colors.green[300]),
                  //     onPressed: () {},
                  //     child: (Text(getTranlated(context, 'new0'))),
                  //   ),
                  // ),
                  // Divider(),
                  // ListTile(
                  //   title: Text(getTranlated(context, 'new2'),
                  //       style: TextStyle(
                  //         fontSize: 16.0,
                  //         fontWeight: FontWeight.bold,
                  //       )),
                  //   trailing: ElevatedButton(
                  //     style:
                  //         ElevatedButton.styleFrom(primary: Colors.green[300]),
                  //     onPressed: () {},
                  //     child: (Text(getTranlated(context, 'new0'))),
                  //   ),
                  // ),
                  // Divider(),
                  // ListTile(
                  //   title: Text(getTranlated(context, 'new3'),
                  //       style: TextStyle(
                  //         fontSize: 16.0,
                  //         fontWeight: FontWeight.bold,
                  //       )),
                  //   trailing: ElevatedButton(
                  //     style:
                  //         ElevatedButton.styleFrom(primary: Colors.green[300]),
                  //     onPressed: () {},
                  //     child: (Text(getTranlated(context, 'new0'))),
                  //   ),
                  // ),
                  // Divider(),
                  // ListTile(
                  //   title: Text(getTranlated(context, 'new4'),
                  //       style: TextStyle(
                  //         fontSize: 16.0,
                  //         fontWeight: FontWeight.bold,
                  //       )),
                  //   trailing: ElevatedButton(
                  //     style:
                  //         ElevatedButton.styleFrom(primary: Colors.green[300]),
                  //     onPressed: () {},
                  //     child: (Text(getTranlated(context, 'new0'))),
                  //   ),
                  // ),
                  // Divider(),
                  // ListTile(
                  //   title: Text(getTranlated(context, 'new5'),
                  //       style: TextStyle(
                  //         fontSize: 16.0,
                  //         fontWeight: FontWeight.bold,
                  //       )),
                  //   trailing: ElevatedButton(
                  //     style:
                  //         ElevatedButton.styleFrom(primary: Colors.green[300]),
                  //     onPressed: () {},
                  //     child: (Text(getTranlated(context, 'new0'))),
                  //   ),
                  // ),
                  // Divider(),
                  // ListTile(
                  //   title: Text(getTranlated(context, 'new6'),
                  //       style: TextStyle(
                  //         fontSize: 16.0,
                  //         fontWeight: FontWeight.bold,
                  //       )),
                  //   trailing: ElevatedButton(
                  //     style:
                  //         ElevatedButton.styleFrom(primary: Colors.green[300]),
                  //     onPressed: () {},
                  //     child: (Text(getTranlated(context, 'new0'))),
                  //   ),
                  // ),
                  // Divider(),
                  ListTile(
                    title: Text(getTranlated(context, 'new1'),
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        )),
                    trailing: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: Colors.green[300]),
                      onPressed: () {},
                      child: (Text(getTranlated(context, 'new0'))),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(getTranlated(context, 'fix1'),
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        )),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.amberAccent[400]),
                      onPressed: () {},
                      child: (Text(getTranlated(context, 'fix0'))),
                    ),
                  ),
                  // Divider(),
                  // ListTile(
                  //   title: Text(getTranlated(context, 'fix2'),
                  //       style: TextStyle(
                  //         fontSize: 16.0,
                  //         fontWeight: FontWeight.bold,
                  //       )),
                  //   trailing: ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //         primary: Colors.amberAccent[400]),
                  //     onPressed: () {},
                  //     child: (Text(getTranlated(context, 'fix0'))),
                  //   ),
                  // ),
                  // Divider(),
                  // ListTile(
                  //   title: Text(getTranlated(context, 'fix3'),
                  //       style: TextStyle(
                  //         fontSize: 16.0,
                  //         fontWeight: FontWeight.bold,
                  //       )),
                  //   trailing: ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //         primary: Colors.amberAccent[400]),
                  //     onPressed: () {},
                  //     child: (Text(getTranlated(context, 'fix0'))),
                  //   ),
                  // ),
                  // Divider(),
                ],
              ))
            ],
          ),
        ));
  }

  void _launchURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch';
}
