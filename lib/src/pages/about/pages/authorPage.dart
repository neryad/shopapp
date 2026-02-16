// import 'dart:io';

// import 'package:pocketlist/src/Shared_Prefs/Prefrecias_user.dart';
// import 'package:flutter/material.dart';
// import 'package:pocketlist/src/utils/utils.dart' as utils;
// import 'package:pocketlist/src/localization/localization_constant.dart';
// import 'package:url_launcher/url_launcher.dart';

// class AuthorPage extends StatefulWidget {
//   const AuthorPage({Key? key}) : super(key: key);

//   @override
//   _AuthorPageState createState() => _AuthorPageState();
// }

// class _AuthorPageState extends State<AuthorPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         resizeToAvoidBottomInset: false,
//         //backgroundColor: Colors.white,
//         appBar: AppBar(
//           backgroundColor: utils.cambiarColor(),
//           title: Text('Author'),
//           //Text(getTranlated(context, 'aboutTitle')),
//           //title: Text(getTranlated(context, 'aboutTitle')),
//           elevation: 0.0,
//         ),
//         // drawer: MenuWidget(),
//         body: Container(
//           child: Column(
//             children: [
//               Container(
//                 decoration: BoxDecoration(color: utils.cambiarColor()),
//                 child: Container(
//                     width: double.infinity,
//                     height: 225,
//                     child: Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: <Widget>[
//                           CircleAvatar(
//                             radius: 55,
//                             backgroundColor: Colors.black38,
//                             child: CircleAvatar(
//                               backgroundImage: AssetImage('assets/me.jpg'),
//                               radius: 50.0,
//                             ),
//                           ),
//                           SizedBox(
//                             height: 5.0,
//                           ),
//                           Text(
//                             'Neryad',
//                             style:
//                                 TextStyle(fontSize: 22.0, color: Colors.white),
//                           ),
//                           SizedBox(
//                             height: 5.0,
//                           ),
//                           Text(
//                             '☕ 𝗖𝗼𝗳𝗳𝗲𝗲, 𝗖𝗼𝗱𝗲 💻  & 𝗥𝗲𝗽𝗲𝗮𝘁',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                           Text(
//                             '👋 Hi!  I am FullStack developer.',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ],
//                       ),
//                     )),
//               ),
//               Expanded(
//                   child: ListView(
//                 children: [
//                   ListTile(
//                     title: Text('Twitter',
//                         style: TextStyle(
//                           fontSize: 20.0,
//                           fontWeight: FontWeight.bold,
//                         )),
//                     subtitle: Text('@Neryadg'),
//                     trailing: Icon(Icons.arrow_forward_ios),
//                     onTap: () {
//                       _launchURL('https://twitter.com/NeryadG');
//                     },
//                     //Text(

//                     // version.toString(),
//                     // style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
//                     //)
//                   ),
//                   Divider(),
//                   ListTile(
//                     title: Text('Instagram',
//                         style: TextStyle(
//                           fontSize: 20.0,
//                           fontWeight: FontWeight.bold,
//                         )),
//                     subtitle: Text('neryad_dev'),
//                     trailing: Icon(Icons.arrow_forward_ios),
//                     onTap: () {
//                       _launchURL('https://www.instagram.com/neryad_dev/');
//                     },
//                   ),
//                   Divider(),
//                   ListTile(
//                     title: Text(getTranlated(context, 'webPageTitle'),
//                         style: TextStyle(
//                           fontSize: 20.0,
//                           fontWeight: FontWeight.bold,
//                         )),
//                     subtitle: Text(getTranlated(context, 'webPageSubTitle')),
//                     trailing: Icon(Icons.arrow_forward_ios),
//                     onTap: () {
//                       _launchURL('https://neryad.dev/');
//                     },
//                   ),
//                   // Platform.isIOS
//                   //     ? Container()
//                   //     : ListTile(
//                   //         title: Text(getTranlated(context, 'authorDonation'),
//                   //             style: TextStyle(
//                   //               fontSize: 20.0,
//                   //               fontWeight: FontWeight.bold,
//                   //             )),
//                   //         subtitle:
//                   //             Text(getTranlated(context, 'authorDonation2')),
//                   //         trailing: Icon(Icons.arrow_forward_ios),
//                   //         onTap: () {
//                   //           _launchURL('https://www.buymeacoffee.com/neryad');
//                   //         },
//                   //       ),
//                   //Divider(),
//                 ],
//               )),
//             ],
//           ),
//         ));
//   }

//   void _launchURL(String url) async =>
//       await canLaunch(url) ? await launch(url) : throw 'Could not launch';
// }
import 'package:pocketlist/src/Shared_Prefs/Prefrecias_user.dart';
import 'package:flutter/material.dart';
import 'package:pocketlist/src/utils/utils.dart' as utils;
import 'package:pocketlist/src/localization/localization_constant.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthorPage extends StatefulWidget {
  const AuthorPage({Key? key}) : super(key: key);

  @override
  _AuthorPageState createState() => _AuthorPageState();
}

class _AuthorPageState extends State<AuthorPage> {
  final prefs = PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: utils.cambiarColor(),
        title: Text(
          'Desarrollador',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 32),

            // --- Foto de perfil ---
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: utils.cambiarColor(),
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: utils.cambiarColor().withOpacity(0.3),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/me.jpg'),
                backgroundColor: colorScheme.surfaceContainerHighest,
              ),
            ),

            SizedBox(height: 20),

            // --- Nombre y tagline ---
            Text(
              'Neryad',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 8),

            Text(
              'FullStack Developer',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),

            SizedBox(height: 4),

            Text(
              '☕ Coffee, Code 💻 & Repeat',
              style: TextStyle(
                fontSize: 14,
                color: utils.cambiarColor(),
                fontStyle: FontStyle.italic,
              ),
            ),

            SizedBox(height: 32),

            // --- Redes sociales ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Conecta Conmigo',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: [
                      _socialButton(
                        context,
                        icon: Icons.close_rounded,
                        label: 'Twitter',
                        url: 'https://twitter.com/NeryadG',
                      ),
                      _socialButton(
                        context,
                        icon: Icons.camera_alt_outlined,
                        label: 'Instagram',
                        url: 'https://www.instagram.com/neryad_dev/',
                      ),
                      _socialButton(
                        context,
                        icon: Icons.language_rounded,
                        label: 'Website',
                        url: 'https://neryad.dev/',
                      ),
                      _socialButton(
                        context,
                        icon: Icons.code_rounded,
                        label: 'GitHub',
                        url: 'https://github.com/neryad',
                      ),
                      _socialButton(
                        context,
                        icon: Icons.business_rounded,
                        label: 'LinkedIn',
                        url: 'https://www.linkedin.com/in/dayern-gomez/',
                      ),
                      _socialButton(
                        context,
                        icon: Icons.mail_outline_rounded,
                        label: 'Email',
                        url: 'mailto:contact@neryad.dev',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 32),

            // --- Botones de acción ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Acciones',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  if (!kIsWeb)
                    _actionButton(
                      context,
                      icon: Icons.favorite_outline,
                      label: 'Apoya el proyecto',
                      subtitle: 'Donar en PayPal',
                      onTap: () => _launchUrl('https://www.paypal.me/neryad'),
                    ),
                  if (!kIsWeb) SizedBox(height: 12),
                  _actionButton(
                    context,
                    icon: Icons.share_outlined,
                    label: 'Compartir App',
                    subtitle: 'Recomienda PocketList',
                    onTap: () => _shareApp(context),
                  ),
                  SizedBox(height: 12),
                  _actionButton(
                    context,
                    icon: Icons.bug_report_outlined,
                    label: 'Reportar Bug',
                    subtitle: 'Enviar email',
                    onTap: () => _launchUrl(
                        'mailto:contact@neryad.dev?subject=Bug%20Report%20-%20PocketList'),
                  ),
                  SizedBox(height: 12),
                  _actionButton(
                    context,
                    icon: Icons.star_outline_rounded,
                    label: 'Calificar App',
                    subtitle: 'En la tienda',
                    onTap: () => _rateApp(),
                  ),
                ],
              ),
            ),

            SizedBox(height: 32),

            // --- Información del desarrollador ---
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: utils.cambiarColor().withOpacity(0.1),
                border: Border.all(
                  color: utils.cambiarColor().withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: utils.cambiarColor(),
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Sobre el Desarrollador',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: utils.cambiarColor(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Desarrollador apasionado por crear aplicaciones útiles y fáciles de usar. Especializado en Flutter y desarrollo multiplataforma.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 16),
                  _infoRow('Stack', 'Flutter • Dart • Firebase'),
                  SizedBox(height: 8),
                  _infoRow('Experiencia', 'Full Stack Developer'),
                  SizedBox(height: 8),
                  _infoRow('Ubicación', 'República Dominicana 🇩🇴'),
                ],
              ),
            ),

            SizedBox(height: 32),

            // --- Footer ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text(
                    '© ${DateTime.now().year} Neryad',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Hecho con ❤️ y Flutter',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _socialButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String url,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _launchUrl(url),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: utils.cambiarColor(),
                size: 32,
              ),
              SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: utils.cambiarColor().withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: utils.cambiarColor(),
                size: 28,
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: utils.cambiarColor(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _launchUrl(String urlString) async {
    try {
      final Uri url = Uri.parse(urlString);

      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No se pudo abrir el enlace'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al abrir el enlace: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

  void _shareApp(BuildContext context) {
    Share.share(
      '¡Descarga PocketList! 🛒\n\nLa mejor app para gestionar tus listas de compras de forma fácil y rápida.\n\n🌐 Visita:\nhttps://pockelist-web.neryad.dev/\n\n📱 ¡Pruébala ahora!',
      subject: 'Descarga PocketList',
    );
  }

  void _rateApp() {
    // URL de la app en las tiendas
    final String storeUrl = kIsWeb
        ? 'https://pocketlist.app'
        : 'https://play.google.com/store/apps/details?id=com.neryad.pocketlist';

    _launchUrl(storeUrl);
  }
}
