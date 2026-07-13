import 'package:flutter/material.dart';
import 'package:pocketlist/main.dart';
import 'package:pocketlist/src/Shared_Prefs/Preferencias_user.dart';
import 'package:pocketlist/src/data/class/language.dart';
import 'package:pocketlist/src/localization/localization_constant.dart';
import 'package:pocketlist/src/pages/settings/category_management_page.dart';
import 'package:pocketlist/src/utils/package_info_mixin.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> with PackageInfoMixin {
  final prefs = PreferenciasUsuario();

  @override
  void initState() {
    super.initState();
    initPackageInfo();
  }

  void _changeLanguage(Language language) async {
    Locale _temp = await setLocal(language.languageCode);
    prefs.lnge = language.languageCode;
    MyApp.setLocale(context, _temp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(getTranslated(context, 'settTitle')),
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // Header decorativo
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(24, 16, 24, 32),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getTranslated(context, 'settTitle'),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          getTranslated(context, 'settSubtitle'),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 16),

          // Sección: Apariencia
          _buildSectionHeader(getTranslated(context, 'settAppearance')),
          _buildSettingCard(
            icon: Icons.color_lens_rounded,
            title: getTranslated(context, 'themTitle'),
            subtitle: getTranslated(context, 'settCustomColors'),
            onTap: () => Navigator.pushNamed(context, 'colorPage'),
            trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16),
          ),

          _buildSettingCard(
            icon: Icons.dark_mode_rounded,
            title: getTranslated(context, 'darkMode'),
            subtitle: prefs.darkLightTheme
                ? getTranslated(context, 'settDarkOn')
                : getTranslated(context, 'settLightOn'),
            trailing: Transform.scale(
              scale: 0.8,
              child: Switch(
                value: prefs.darkLightTheme,
                onChanged: (value) {
                  setState(() {
                    _selectedRadio(value);
                  });
                },
                activeThumbColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),

          SizedBox(height: 16),

          // Sección: Cuenta
          _buildSectionHeader(getTranslated(context, 'settAccount')),
          _buildSettingCard(
            icon: Icons.person_rounded,
            title: getTranslated(context, 'userTitle'),
            subtitle: prefs.nombreUsuario.isEmpty
                ? getTranslated(context, 'settConfigProfile')
                : prefs.nombreUsuario,
            onTap: () => Navigator.pushNamed(context, 'userPage'),
            trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16),
          ),

          SizedBox(height: 16),

          // Sección: Categorías
          _buildSectionHeader(getTranslated(context, 'categories')),
          _buildSettingCard(
            icon: Icons.label_outline,
            title: getTranslated(context, 'categoryManagement'),
            subtitle: getTranslated(context, 'filterByCategory'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const CategoryManagementPage(),
              ),
            ),
            trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16),
          ),

          SizedBox(height: 16),

          // Sección: Datos
          _buildSectionHeader(getTranslated(context, 'settDataSection')),
          _buildSettingCard(
            icon: Icons.storage_rounded,
            title: getTranslated(context, 'dataTitle'),
            subtitle: getTranslated(context, 'settManageData'),
            onTap: () => Navigator.pushNamed(context, 'dataPage'),
            trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16),
          ),

          SizedBox(height: 16),

          // Sección: Idioma
          _buildSectionHeader(getTranslated(context, 'settLangRegion')),
          _buildSettingCard(
            icon: Icons.language_rounded,
            title: getTranslated(context, 'lngTitle'),
            subtitle: _getCurrentLanguageName(),
            trailing: _buildLanguageSelector(),
          ),

          SizedBox(height: 16),

          // Sección: Legal
          _buildSectionHeader(getTranslated(context, 'settLegal')),
          _buildSettingCard(
            icon: Icons.description_rounded,
            title: getTranslated(context, 'Terms'),
            subtitle: getTranslated(context, 'settTermsConditions'),
            onTap: () => _launchURL(
                'https://neryad.github.io/pocketPage/docs/Terms.pdf'),
            trailing: Icon(Icons.open_in_new, size: 16),
          ),

          _buildSettingCard(
            icon: Icons.privacy_tip_rounded,
            title: getTranslated(context, 'privacyPol'),
            subtitle: getTranslated(context, 'privacyPol'),
            onTap: () => _launchURL(
                'https://neryad.github.io/pocketPage/docs/PrivacyPolicy.pdf'),
            trailing: Icon(Icons.open_in_new, size: 16),
          ),

          _buildSettingCard(
            icon: Icons.shield_rounded,
            title: getTranslated(context, 'settCCPA'),
            subtitle: getTranslated(context, 'settCCPADesc'),
            onTap: () => _showCCPAInfo(context),
            trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16),
          ),

          SizedBox(height: 32),

          // Footer con versión
          Center(
            child: Column(
              children: [
                Text(
                  'PocketList',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${getTranslated(context, 'settVersion')} ${packageInfo.version}',
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
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 8, 24, 8),
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

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: Theme.of(context).colorScheme.primary,
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
                      if (subtitle != null) ...[
                        SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  SizedBox(width: 8),
                  trailing,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        // ← Cambiar a String
        value: prefs.lnge, // ← Usar directamente el código guardado
        underline: SizedBox(),
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
        isDense: true,
        items: Language.languageList()
            .map<DropdownMenuItem<String>>(
              // ← Cambiar a String
              (lang) => DropdownMenuItem(
                value: lang.languageCode, // ← Usar código como valor
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      lang.flag,
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(width: 8),
                    Text(
                      lang.languageCode.toUpperCase(),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
        onChanged: (String? languageCode) {
          // ← Cambiar a String
          if (languageCode != null) {
            // Buscar el objeto Language correspondiente
            final language = Language.languageList().firstWhere(
              (lang) => lang.languageCode == languageCode,
            );
            setState(() {
              _changeLanguage(language);
            });
          }
        },
      ),
    );
  }

  String _getCurrentLanguageName() {
    try {
      final currentLang = Language.languageList().firstWhere(
        (lang) => lang.languageCode == prefs.lnge,
      );
      return '${currentLang.flag} ${currentLang.name}';
    } catch (e) {
      // Si no encuentra el idioma, devolver un valor por defecto
      return getTranslated(context, 'lngTitle');
    }
  }

  void _selectedRadio(bool valor) {
    prefs.darkLightTheme = valor;
    MyApp.stateSet(context);
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(getTranslated(context, 'settOpenLinkError')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showCCPAInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.shield_rounded, color: Theme.of(context).colorScheme.primary),
            SizedBox(width: 12),
            Text(getTranslated(context, 'settCCPA')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(getTranslated(context, 'settCCPAInfo')),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'California Consumer Privacy Act (CCPA)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'You have the right to:',
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(height: 4),
                  Text('• Know what personal information is collected', style: TextStyle(fontSize: 12)),
                  Text('• Request deletion of your personal information', style: TextStyle(fontSize: 12)),
                  Text('• Opt out of the sale or sharing of your data', style: TextStyle(fontSize: 12)),
                  Text('• Non-discrimination for exercising your rights', style: TextStyle(fontSize: 12)),
                  SizedBox(height: 8),
                  Text(
                    'To exercise your rights, contact us at neryadg@gmail.com',
                    style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(getTranslated(context, 'accept')),
          ),
        ],
      ),
    );
  }
}
