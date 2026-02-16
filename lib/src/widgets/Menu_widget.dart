import 'package:pocketlist/src/Shared_Prefs/Prefrecias_user.dart';
import 'package:flutter/material.dart';

import 'package:pocketlist/src/localization/localization_constant.dart';

class MenuWidget extends StatelessWidget {
  final prefs = new PreferenciasUsuario();
  late Locale _locale;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final hasName = prefs.nombreUsuario.isNotEmpty;
    final userInitial = hasName ? prefs.nombreUsuario[0].toUpperCase() : '';

    return Drawer(
      child: Column(
        children: <Widget>[
          // Header
          InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, 'userPage');
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                  top: 60, left: 24, bottom: 24, right: 24),
              color: colorScheme.primaryContainer,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 32,
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
                            size: 32,
                            color: colorScheme.onPrimary,
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
                  Text(
                    hasName
                        ? prefs.nombreUsuario
                        : getTranlated(context, 'guestUser'),
                    style: textTheme.titleLarge?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: <Widget>[
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
                  routeName: 'newList',
                ),
                _createMenuItem(
                  context,
                  icon: Icons.sync_alt,
                  activeIcon: Icons.sync,
                  title: 'Import / Export',
                  routeName: 'exportImport',
                ),
                const Divider(indent: 12, endIndent: 12),
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

          // Footer
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'PocketList v1.0.0',
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createMenuItem(
    BuildContext context, {
    required IconData icon,
    required IconData activeIcon,
    required String title,
    required String routeName,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentRoute = ModalRoute.of(context)?.settings.name;
    final isSelected = currentRoute == routeName;

    return ListTile(
      leading: Icon(
        isSelected ? activeIcon : icon,
        color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? colorScheme.primary : colorScheme.onSurface,
        ),
      ),
      selected: isSelected,
      selectedTileColor: colorScheme.primaryContainer.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onTap: () {
        Navigator.pop(context);
        if (!isSelected) {
          Navigator.pushNamed(context, routeName);
        }
      },
    );
  }
}
