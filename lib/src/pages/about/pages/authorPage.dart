import 'package:PocketList/src/Shared_Prefs/Prefrecias_user.dart';
import 'package:flutter/material.dart';
import 'package:PocketList/src/widgets/Menu_widget.dart';
import 'package:PocketList/src/utils/utils.dart' as utils;
import 'package:PocketList/src/localization/localization_constant.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthorPage extends StatefulWidget {
  const AuthorPage({Key key}) : super(key: key);

  @override
  _AuthorPageState createState() => _AuthorPageState();
}

class _AuthorPageState extends State<AuthorPage> {
  final prefs = new PreferenciasUsuario();
  String appName;
  String packageName;
  String version = '1.0.0';
  String buildNumber;

  @override
  void initState() {
    //getBuildAndVersion();
    //prefs.ultimaPagina = 'about';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        //backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: utils.cambiarColor(),
          title: Text('Author'),
          //Text(getTranlated(context, 'aboutTitle')),
          //title: Text(getTranlated(context, 'aboutTitle')),
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
                              backgroundImage: AssetImage('assets/me.jpg'),
                              radius: 50.0,
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            'Neryad',
                            style:
                                TextStyle(fontSize: 22.0, color: Colors.white),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            '☕ 𝗖𝗼𝗳𝗳𝗲𝗲, 𝗖𝗼𝗱𝗲 💻  & 𝗥𝗲𝗽𝗲𝗮𝘁',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            '👋 Hi!  I am FullStack developer.',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    )),
              ),
              Expanded(
                  child: ListView(
                children: [
                  ListTile(
                    title: Text('Twitter',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        )),
                    subtitle: Text('@Neryadg'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      _launchURL('https://twitter.com/NeryadG');
                    },
                    //Text(

                    // version.toString(),
                    // style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    //)
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Instagram',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        )),
                    subtitle: Text('neryad_dev'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      _launchURL('https://www.instagram.com/neryad_dev/');
                    },
                  ),
                  ListTile(
                    title: Text(getTranlated(context, 'authorDonation'),
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        )),
                    subtitle: Text(getTranlated(context, 'authorDonation2')),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      _launchURL('https://www.buymeacoffee.com/neryad');
                    },
                  ),
                  Divider(),
                ],
              )),
            ],
          ),
        ));
  }

  void _launchURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch';
}
