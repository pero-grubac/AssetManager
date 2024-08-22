import 'package:asset_manager/widgets/util/centered_circular_loading.dart';
import 'package:asset_manager/widgets/util/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../screens/settings_screen.dart';
import '../../theme/drawer_header_theme.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  Future<void> _delayUIUpdate() async {
    // Introduce a short delay to allow the theme to fully apply
    await Future.delayed(const Duration(milliseconds: 50));
  }

  @override
  Widget build(BuildContext context) {
    final drawerHeaderTheme = Theme.of(context).extension<DrawerHeaderTheme>();

    return FutureBuilder(
      future: _delayUIUpdate(),
      builder: (context, snapshot) {
        // While waiting for the delay, show an empty container or a loading spinner if desired
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CenteredCircularLoading(); // Optionally, you can show a loading indicator here
        }

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
                    Text(AppLocalizations.of(context)!.assetManager),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.settings,
                  size: 26,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(AppLocalizations.of(context)!.settings),
                onTap: () {
                  Navigator.of(context).pushNamed(SettingsScreen.id);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
