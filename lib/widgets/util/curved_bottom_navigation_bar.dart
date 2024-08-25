import 'package:asset_manager/screens/home_screen.dart';
import 'package:asset_manager/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import '../../models/category/category.dart';
import '../../screens/asset_screen.dart';
import '../../screens/census_list_screen.dart';
import '../../screens/location_screen.dart';
import '../../screens/workers_screen.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({
    super.key,
  });
  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, SettingsScreen.id);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, HomeScreen.id);
        break;
      case 2:
        Navigator.pushReplacementNamed(context, LocationScreen.id);
        break;
      case 3:
        Navigator.pushReplacementNamed(context, WorkersScreen.id);
        break;
      case 4:
        Navigator.pushReplacementNamed(context, AssetScreen.id);
        break;
      case 5:
        Navigator.pushReplacementNamed(context, CensusListScreen.id);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var categories = [
      Category(
        id: SettingsScreen.id,
        title: AppLocalizations.of(context)!.settings,
        icon: Icon(
          Icons.settings,
          color: Theme.of(context).colorScheme.surface,
        ),
      ),
      Category(
        id: HomeScreen.id,
        title: AppLocalizations.of(context)!.assetManager,
        icon: Icon(
          Icons.home,
          color: Theme.of(context).colorScheme.surface,
        ),
      ),
      Category(
        id: LocationScreen.id,
        title: AppLocalizations.of(context)!.locations,
        icon: Icon(
          Icons.location_city,
          color: Theme.of(context).colorScheme.surface,
        ),
      ),
      Category(
        id: WorkersScreen.id,
        title: AppLocalizations.of(context)!.workers,
        icon: Icon(
          Icons.person_2,
          color: Theme.of(context).colorScheme.surface,
        ),
      ),
      Category(
        id: AssetScreen.id,
        title: AppLocalizations.of(context)!.assets,
        icon: Icon(
          Icons.business_center,
          color: Theme.of(context).colorScheme.surface,
        ),
      ),
      Category(
        id: CensusListScreen.id,
        title: AppLocalizations.of(context)!.censusList,
        icon: Icon(
          Icons.checklist,
          color: Theme.of(context).colorScheme.surface,
        ),
      ),
    ];

    return StylishBottomBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      items: categories
          .map(
            (el) => BottomBarItem(
              icon: el.icon,
              title: const Text(''),
            ),
          )
          .toList(),
      option: AnimatedBarOptions(
        iconSize: 30, // Adjust the size of the icons as needed
        padding: const EdgeInsets.symmetric(vertical: 10),
        opacity: 0.3,
        barAnimation: BarAnimation.fade, // Smooth animation
        iconStyle: IconStyle.simple, // Keep icons simple without bouncing
      ),
      iconSpace: 12.0,
      hasNotch: true,
      fabLocation: StylishBarFabLocation.end,
      notchStyle: NotchStyle.circle,
      onTap: (index) {
        _onItemTapped(index);
      },
    );
  }
}
