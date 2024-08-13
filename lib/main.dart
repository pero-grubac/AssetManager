import 'package:asset_manager/screens/asset_screen.dart';
import 'package:asset_manager/screens/home_screen.dart';
import 'package:asset_manager/screens/location_screen.dart';
import 'package:asset_manager/screens/workers_screen.dart';
import 'package:asset_manager/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: AssetManager(),
    ),
  );
}

class AssetManager extends StatelessWidget {
  const AssetManager({super.key});

  // final FlutterLocalization localization = FlutterLocalization.instance;

  /* @override
  void initState() {
    configureLocalization();
    super.initState();
  }
*/
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: HomeScreen.id,
      routes: {
        HomeScreen.id: (context) => const HomeScreen(),
        WorkersScreen.id: (context) => const WorkersScreen(),
        LocationScreen.id: (context) => const LocationScreen(),
        AssetScreen.id: (context) => const AssetScreen(),
      },
    );
  }
}
