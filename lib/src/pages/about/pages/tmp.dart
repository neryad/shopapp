import 'package:pocketlist/src/Shared_Prefs/Prefrecias_user.dart';
import 'package:flutter/material.dart';
import 'package:pocketlist/src/utils/utils.dart' as utils;
import 'package:pocketlist/src/localization/localization_constant.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final prefs = new PreferenciasUsuario();
  String appName = '';
  String packageName = '';
  String version = '1.0.0';
  String buildNumber = '';

  @override
  void initState() {
    super.initState();
    //getBuildAndVersion();
    //prefs.ultimaPagina = 'about';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(getTranlated(context, 'aboutTitle')),
          //title: Text(getTranlated(context, 'aboutTitle')),
          elevation: 0.0,
        ),
        // drawer: MenuWidget(),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                decoration:
                    BoxDecoration(color: Theme.of(context).colorScheme.primary),
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
                                        Text(
                                            getTranlated(
                                                context, 'versionTitle'),
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                fontSize: 22.0,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(version,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                fontSize: 22.0,
                                                fontWeight: FontWeight.w200)),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                            getTranlated(
                                                context, 'authorTitle'),
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                fontSize: 22.0,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text('Neryad',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                fontSize: 22.0,
                                                fontWeight: FontWeight.w200)),
                                      ],
                                    ),
                                  ),
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
                        getTranlated(context, 'descpTitle'),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontStyle: FontStyle.normal,
                            fontSize: 28.0),
                      ),
                      SizedBox(height: 5.0),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          getTranlated(context, 'descpText'),
                          style: TextStyle(
                              fontSize: 20.0,
                              //fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              letterSpacing: 2.0),
                        ),
                      ),
                      Divider(),
                      Row(
                        children: [
                          Text(
                            'Neryad ©️ 2020',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  ),
                )),
              ),
            ],
          ),
        ));
  }

  getBuildAndVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appName = packageInfo.appName;
    packageName = packageInfo.packageName;
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
  }
}
