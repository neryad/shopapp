import 'package:pocketlist/src/Shared_Prefs/Prefrecias_user.dart';
import 'package:flutter/material.dart';
import 'package:pocketlist/src/utils/utils.dart' as utils;
import 'package:pocketlist/src/localization/localization_constant.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final prefs = PreferenciasUsuario();

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _packageInfo = info;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(getTranlated(context, 'aboutTitle')),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header con logo
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(24, 32, 24, 40),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                // Logo con efecto de sombra
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/logo.png'),
                      radius: 55,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'PocketList',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'v${_packageInfo.version}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Lista de información
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),

                  // Sección: Información de la App
                  _buildSectionHeader('Información de la App'),
                  SizedBox(height: 12),

                  _buildInfoCard(
                    icon: Icons.info_outline,
                    iconColor: Colors.blue,
                    title: getTranlated(context, 'versionTitle'),
                    subtitle:
                        'v${_packageInfo.version} (${_packageInfo.buildNumber})',
                  ),

                  SizedBox(height: 24),

                  // Sección: Créditos
                  _buildSectionHeader('Créditos'),
                  SizedBox(height: 12),

                  _buildInfoCard(
                    icon: Icons.person_outline,
                    iconColor: Colors.purple,
                    title:
                        getTranlated(context, 'authorTitle') ?? 'Desarrollador',
                    subtitle: 'Neryad',
                    onTap: () => Navigator.pushNamed(context, 'authorPage'),
                    showArrow: true,
                  ),

                  // SizedBox(height: 12),

                  // _buildInfoCard(
                  //   icon: Icons.palette_outlined,
                  //   iconColor: Colors.orange,
                  //   title: getTranlated(context, 'aImgs') ?? 'Ilustraciones',
                  //   subtitle: getTranlated(context, 'aImgs2') ?? 'unDraw',
                  //   onTap: () => _launchUrl('https://undraw.co/illustrations'),
                  //   showArrow: true,
                  // ),

                  SizedBox(height: 12),

                  _buildInfoCard(
                    icon: Icons.brush_outlined,
                    iconColor: Colors.pink,
                    title: getTranlated(context, 'lDesign') ?? 'Diseño de Logo',
                    subtitle:
                        getTranlated(context, 'studio') ?? 'Plus Logo Design',
                    onTap: () => _launchUrl(
                        'https://www.instagram.com/plus.logodesign/'),
                    showArrow: true,
                  ),

                  // Donaciones (solo en móvil)
                  if (!kIsWeb) ...[
                    SizedBox(height: 24),
                    _buildSectionHeader('Soporte'),
                    SizedBox(height: 12),
                    _buildInfoCard(
                      icon: Icons.favorite_outline,
                      iconColor: Colors.red,
                      title: getTranlated(context, 'dantions') ?? 'Donaciones',
                      subtitle: getTranlated(context, 'aboutDonation') ??
                          'Apoya el desarrollo de la app',
                      onTap: () => _launchUrl('https://www.paypal.me/neryad'),
                      showArrow: true,
                    ),
                  ],

                  SizedBox(height: 24),

                  // Links importantes
                  _buildSectionHeader('Enlaces'),
                  SizedBox(height: 12),

                  _buildInfoCard(
                    icon: Icons.code_outlined,
                    iconColor: Colors.teal,
                    title: 'Código Fuente',
                    subtitle: 'GitHub',
                    onTap: () => _launchUrl('https://github.com/neryad'),
                    showArrow: true,
                  ),

                  SizedBox(height: 12),

                  _buildInfoCard(
                    icon: Icons.privacy_tip_outlined,
                    iconColor: Colors.indigo,
                    title: 'Política de Privacidad',
                    subtitle: 'Ver documento',
                    onTap: () => _launchUrl(
                        'https://neryad.github.io/pocketPage/docs/PrivacyPolicy.pdf'),
                    showArrow: true,
                  ),

                  SizedBox(height: 32),

                  // Footer
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Hecho con ❤️ por Neryad',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '© 2024 PocketList',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    bool showArrow = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                if (showArrow)
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    try {
      final Uri url = Uri.parse(urlString);

      // Detectar si es Instagram y intentar abrir la app primero
      if (urlString.contains('instagram.com')) {
        // Extraer el username
        final username = urlString.split('/').where((s) => s.isNotEmpty).last;
        final instagramAppUrl =
            Uri.parse('instagram://user?username=$username');

        // Intentar abrir la app de Instagram primero
        if (await canLaunchUrl(instagramAppUrl)) {
          await launchUrl(
            instagramAppUrl,
            mode: LaunchMode.externalApplication,
          );
          return;
        }
      }

      // Detectar si es Twitter/X
      if (urlString.contains('twitter.com') || urlString.contains('x.com')) {
        final username = urlString.split('/').where((s) => s.isNotEmpty).last;
        final twitterAppUrl = Uri.parse('twitter://user?screen_name=$username');

        if (await canLaunchUrl(twitterAppUrl)) {
          await launchUrl(
            twitterAppUrl,
            mode: LaunchMode.externalApplication,
          );
          return;
        }
      }

      // Para cualquier otra URL o si la app no está instalada
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw 'No se pudo abrir $urlString';
      }
    } catch (e) {
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
  }
}
