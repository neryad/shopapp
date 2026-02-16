import 'package:package_info_plus/package_info_plus.dart';
import 'package:pocketlist/src/Shared_Prefs/Prefrecias_user.dart';
import 'package:pocketlist/src/pages/New-List/newList.dart';

import 'package:flutter/material.dart';
import 'package:pocketlist/src/localization/localization_constant.dart';

class MenuWidget extends StatefulWidget {
  @override
  State<MenuWidget> createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  final prefs = PreferenciasUsuario();
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

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final hasName = prefs.nombreUsuario.isNotEmpty;
    final userInitial = hasName ? prefs.nombreUsuario[0].toUpperCase() : '';

    return Drawer(
      child: Column(
        children: <Widget>[
          // Header mejorado con gradiente
          InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, 'userPage');
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                  top: 60, left: 24, bottom: 24, right: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primaryContainer,
                    colorScheme.primaryContainer.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'user_avatar',
                    child: CircleAvatar(
                      radius: 36,
                      backgroundColor: colorScheme.primary,
                      child: hasName
                          ? Text(
                              userInitial,
                              style: textTheme.headlineMedium?.copyWith(
                                color: colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : Icon(
                              Icons.person,
                              size: 36,
                              color: colorScheme.onPrimary,
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    hasName
                        ? getTranlated(context, 'greattin1')
                        : getTranlated(context, 'setProfile'),
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hasName
                        ? prefs.nombreUsuario
                        : getTranlated(context, 'guestUser'),
                    style: textTheme.titleLarge?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (!hasName) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: colorScheme.primary.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.edit,
                            size: 14,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Completar perfil',
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: <Widget>[
                // Sección Principal
                _createSectionHeader(context, 'Principal'),
                _createMenuItem(
                  context,
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home,
                  title: getTranlated(context, 'mHomeTitle'),
                  routeName: 'home',
                ),
                _createMenuItem(
                  context,
                  icon: Icons.add_circle_outline,
                  activeIcon: Icons.add_circle,
                  title: getTranlated(context, 'mMyLisTitle'),
                  onTap: () {
                    Navigator.pop(context); // Cerrar drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShoppingListPage(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 8),
                const Divider(indent: 12, endIndent: 12),
                const SizedBox(height: 8),

                // Sección Datos
                _createSectionHeader(context, 'Datos'),
                _createMenuItem(
                  context,
                  icon: Icons.sync_alt,
                  activeIcon: Icons.sync,
                  title: 'Import / Export',
                  routeName: 'exportImport',
                ),

                const SizedBox(height: 8),
                const Divider(indent: 12, endIndent: 12),
                const SizedBox(height: 8),

                // Sección Configuración
                _createSectionHeader(context, 'Configuración'),
                _createMenuItem(
                  context,
                  icon: Icons.settings_outlined,
                  activeIcon: Icons.settings,
                  title: getTranlated(context, 'mSettingTitle'),
                  routeName: 'settings',
                ),
                _createMenuItem(
                  context,
                  icon: Icons.info_outline,
                  activeIcon: Icons.info,
                  title: getTranlated(context, 'mAboutTitle'),
                  routeName: 'about',
                ),
              ],
            ),
          ),

          // Footer mejorado
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: colorScheme.outlineVariant.withOpacity(0.5),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  'PocketList v${_packageInfo.version} (${_packageInfo.buildNumber})',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _createSectionHeader(BuildContext context, String title) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 8, bottom: 4),
      child: Text(
        title.toUpperCase(),
        style: textTheme.labelSmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _createMenuItem(
    BuildContext context, {
    required IconData icon,
    required IconData activeIcon,
    required String title,
    String? routeName,
    VoidCallback? onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final currentRoute = ModalRoute.of(context)?.settings.name;
    final isSelected = currentRoute == routeName;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          leading: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              isSelected ? activeIcon : icon,
              key: ValueKey(isSelected),
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
              size: 24,
            ),
          ),
          title: Text(
            title,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? colorScheme.primary : colorScheme.onSurface,
            ),
          ),
          trailing: isSelected
              ? Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                )
              : null,
          selected: isSelected,
          selectedTileColor: colorScheme.primaryContainer.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          onTap: onTap ??
              () {
                Navigator.pop(context);
                if (!isSelected && routeName != null) {
                  Navigator.pushNamed(context, routeName);
                }
              },
        ),
      ),
    );
  }
}
