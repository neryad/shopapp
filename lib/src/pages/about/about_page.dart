import 'dart:io';

import 'package:PocketList/src/Shared_Prefs/Prefrecias_user.dart';
import 'package:flutter/material.dart';
import 'package:PocketList/src/utils/utils.dart' as utils;
import 'package:PocketList/src/localization/localization_constant.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
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
    print(_packageInfo.version);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        //backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: utils.cambiarColor(),
          title: Text(getTranlated(context, 'aboutTitle')),
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
                    height: 225,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            radius: 55,
                            backgroundColor: Colors.black38,
                            child: CircleAvatar(
                              backgroundImage: AssetImage('assets/logo.png'),
                              radius: 50.0,
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            'PocketList',
                            style:
                                TextStyle(fontSize: 22.0, color: Colors.white),
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
                  ListTile(
                    title: Text(getTranlated(context, 'versionTitle'),
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        )),
                    trailing: Text(
                      _packageInfo.version,
                      //version.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                    //subtitle: Text('Build: ${_packageInfo.buildNumber}'),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(getTranlated(context, 'authorTitle'),
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        )),
                    onTap: () => {Navigator.pushNamed(context, 'authorPage')},
                    trailing: Icon(Icons.arrow_forward_ios),
                    subtitle: Text('Neryad'),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(getTranlated(context, 'aImgs'),
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        )),
                    subtitle: Text(getTranlated(context, 'aImgs2')),
                    onTap: () =>
                        {_launchURL('https://undraw.co/illustrations')},
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(getTranlated(context, 'lDesign'),
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        )),
                    onTap: () => {
                      _launchURL('https://www.instagram.com/plus.logodesign/')
                    },
                    trailing: Icon(Icons.arrow_forward_ios),
                    subtitle: Text(getTranlated(context, 'studio')),
                  ),
                  Divider(),
                  Platform.isIOS
                      ? Container()
                      : ListTile(
                          title: Text(getTranlated(context, 'dantions'),
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              )),
                          subtitle:
                              Text(getTranlated(context, 'aboutDonation')),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            _launchURL('https://www.paypal.me/neryad');
                          },
                        ),
                ],
              ))
            ],
          ),
        ));
  }

  void _launchURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch';
}
