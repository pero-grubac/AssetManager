import 'package:asset_manager/screens/settings_screen.dart';
import 'package:flutter/material.dart';

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
            child: const Row(
              children: [
                Icon(
                  Icons.business_center,
                  size: 48,
                ),
                SizedBox(
                  width: 18,
                ),
                Text('Asset manager'),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.settings,
              size: 26,
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
