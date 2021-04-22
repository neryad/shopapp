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
        body: ListView(
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
                          style: TextStyle(fontSize: 22.0, color: Colors.white),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text('☕ 𝗖𝗼𝗳𝗳𝗲𝗲, 𝗖𝗼𝗱𝗲 💻  & 𝗥𝗲𝗽𝗲𝗮𝘁'),
                        Text('👋 Hi!  I am FullStack developer.'),
                        //Text('🔨  Tools:'),
                        // Text('- JS, Angular, Ionic, NodeJs, Flutter'),

                        // style: TextStyle(fontSize: 22.0, color: Colors.white),
                      ],
                    ),
                  )),
            ),
            // SizedBox(
            //   height: 5.0,
            // ),
            // Text('Redes Sociales',
            //     style: TextStyle(
            //       fontSize: 20.0,
            //       fontWeight: FontWeight.bold,
            //     )),
            // Divider(),
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
              title: Text('Would you give me a coffee?',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  )),
              subtitle: Text('Some coffee to continue writing code'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                _launchURL('https://www.buymeacoffee.com/neryad');
              },
            ),
            Divider(),
            // ListTile(
            //   title: Text(getTranlated(context, 'versionTitle'),
            //       style: TextStyle(
            //         fontSize: 20.0,
            //         fontWeight: FontWeight.bold,
            //       )),
            //   onTap: () => {
            //     // Navigator.pop(context),
            //     Navigator.pushNamed(context, 'colorPage')
            //   },
            //   trailing: Text(
            //     version.toString(),
            //     style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            //   ),
            // ),
            // Divider(),
          ],
        )
        // SingleChildScrollView(
        //   child: Column(
        //     children: <Widget>[
        //       Container(
        //         decoration: BoxDecoration(color: utils.cambiarColor()),
        //         child: Container(
        //             width: double.infinity,
        //             height: 300,
        //             child: Center(
        //               child: Column(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 crossAxisAlignment: CrossAxisAlignment.center,
        //                 children: <Widget>[
        //                   CircleAvatar(
        //                     radius: 55,
        //                     backgroundColor: Colors.black38,
        //                     child: CircleAvatar(
        //                       backgroundImage: AssetImage('assets/logo.png'),
        //                       radius: 50.0,
        //                     ),
        //                   ),
        //                   SizedBox(
        //                     height: 20.0,
        //                   ),
        //                   Text(
        //                     'PocketList',
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
        //                                 Text(
        //                                     getTranlated(
        //                                         context, 'versionTitle'),
        //                                     style: TextStyle(
        //                                         color: utils.cambiarColor(),
        //                                         fontSize: 22.0,
        //                                         fontWeight: FontWeight.bold)),
        //                                 SizedBox(
        //                                   height: 10.0,
        //                                 ),
        //                                 Text(version,
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
        //                                 Text(
        //                                     getTranlated(
        //                                         context, 'authorTitle'),
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
        //                         ],
        //                       ),
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             )),
        //       ),
        //       Card(
        //         child: Container(
        //             child: Padding(
        //           padding: const EdgeInsets.symmetric(
        //               horizontal: 30.0, vertical: 8.0),
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: <Widget>[
        //               Text(
        //                 getTranlated(context, 'descpTitle'),
        //                 style: TextStyle(
        //                     color: utils.cambiarColor(),
        //                     fontStyle: FontStyle.normal,
        //                     fontSize: 28.0),
        //               ),
        //               SizedBox(height: 5.0),
        //               Padding(
        //                 padding: const EdgeInsets.all(8.0),
        //                 child: Text(
        //                   getTranlated(context, 'descpText'),
        //                   style: TextStyle(
        //                       fontSize: 20.0,
        //                       //fontStyle: FontStyle.italic,
        //                       fontWeight: FontWeight.w300,
        //                       color: Colors.black,
        //                       letterSpacing: 2.0),
        //                 ),
        //               ),
        //               Divider(),
        //               Row(
        //                 children: [
        //                   Text(
        //                     'Neryad ©️ 2020',
        //                     style: TextStyle(fontWeight: FontWeight.bold),
        //                   ),
        //                 ],
        //               )
        //             ],
        //           ),
        //         )),
        //       ),
        //     ],
        //   ),
        // )
        );
  }

  void _launchURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch';
}
