import 'package:asset_manager/widgets/util/helper_widgets.dart';
import 'package:flutter/material.dart';

import '../../screens/settings_screen.dart';
import '../../theme/drawer_header_theme.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final drawerHeaderTheme = Theme.of(context).extension<DrawerHeaderTheme>();

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(20),
            decoration: drawerHeaderTheme?.drawerHeaderDecoration,
            child: Row(
              children: [
                Icon(
                  Icons.business_center,
                  size: 48,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                addHorizontalSpace(18),
                const Text('Asset manager'),
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              size: 26,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text('Settings'),
            onTap: () {
              Navigator.of(context).pushNamed(SettingsScreen.id);
            },
          )
        ],
      ),
    );
  }
}
