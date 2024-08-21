import 'package:asset_manager/providers/settings_provider.dart';
import 'package:asset_manager/screens/asset_screen.dart';
import 'package:asset_manager/screens/census_item_details.dart';
import 'package:asset_manager/screens/census_list_items_screen.dart';
import 'package:asset_manager/screens/census_list_screen.dart';
import 'package:asset_manager/screens/home_screen.dart';
import 'package:asset_manager/screens/loading_screen.dart';
import 'package:asset_manager/screens/location_screen.dart';
import 'package:asset_manager/screens/map_screen.dart';
import 'package:asset_manager/screens/scan_barcode_screen.dart';
import 'package:asset_manager/screens/settings_screen.dart';
import 'package:asset_manager/screens/workers_screen.dart';
import 'package:asset_manager/theme/theme_constants.dart';
import 'package:asset_manager/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/settings.dart';

void main() {
  runApp(
    const ProviderScope(
      child: AssetManager(),
    ),
  );
}

class AssetManager extends ConsumerWidget {
  const AssetManager({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);

    return AnimatedTheme(
      data: settings.themeMode == Settings.darkMode
          ? ThemeData.dark()
          : ThemeData.light(),
      duration: const Duration(milliseconds: 300),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: settings.themeMode == Settings.darkMode
            ? ThemeMode.dark
            : ThemeMode.light,
        initialRoute: HomeScreen.id,
        routes: {
          HomeScreen.id: (context) => const HomeScreen(),
          WorkersScreen.id: (context) => const WorkersScreen(),
          LocationScreen.id: (context) => const LocationScreen(),
          AssetScreen.id: (context) => const AssetScreen(),
          MapScreen.id: (context) => const MapScreen(),
          SettingsScreen.id: (context) => const SettingsScreen(),
          ScanBarcodeScreen.id: (context) => const ScanBarcodeScreen(),
          CensusItemDetails.id: (context) => const CensusItemDetails(),
          CensusListScreen.id: (context) => const CensusListScreen(),
          CensusListItemsScreen.id: (context) => const CensusListItemsScreen(),
        },
      ),
    );
  }
}
