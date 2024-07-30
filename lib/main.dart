import 'package:asset_manager/localization/locals.dart';
import 'package:asset_manager/screens/home_screen.dart';
import 'package:asset_manager/screens/loading_screen.dart';
import 'package:asset_manager/screens/workers_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

void main() {
  runApp(const AssetManager());
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
      initialRoute: WorkersScreen.id,
      routes: {
        HomeScreen.id: (context) => const HomeScreen(),
        LoadingScreen.id: (context) => const LoadingScreen(),
        WorkersScreen.id: (context) => const WorkersScreen(),
      },
    );
  }
}
