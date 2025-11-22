import 'package:pocketlist/src/Shared_Prefs/Prefrecias_user.dart';
import 'package:flutter/material.dart';
import 'package:pocketlist/src/utils/utils.dart' as utils;
import 'package:pocketlist/src/localization/localization_constant.dart';
import 'package:package_info_plus/package_info_plus.dart'; // Cambiado
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart'; // Agregado para kIsWeb

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

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
    super.initState(); // Mueve esto al inicio
    _initPackageInfo();
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
        appBar: AppBar(
          backgroundColor: utils.cambiarColor(),
          title: Text(getTranlated(context, 'aboutTitle')),
          elevation: 0.0,
        ),
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
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
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
                  // Usa kIsWeb en lugar de Platform.isIOS
                  if (!kIsWeb) // Solo muestra en móvil, no en web
                    ListTile(
                      title: Text(getTranlated(context, 'dantions'),
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          )),
                      subtitle: Text(getTranlated(context, 'aboutDonation')),
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

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
