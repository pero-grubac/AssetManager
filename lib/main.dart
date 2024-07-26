import 'package:asset_manager/localization/locals.dart';
import 'package:asset_manager/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

void main() {
  runApp(const AssetManager());
}

class AssetManager extends StatefulWidget {
  const AssetManager({super.key});

  @override
  State<AssetManager> createState() => _AssetManagerState();
}

class _AssetManagerState extends State<AssetManager> {
  final FlutterLocalization localization = FlutterLocalization.instance;

  @override
  void initState() {
    configureLocalization();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
        useMaterial3: true,
      ),
      supportedLocales: localization.supportedLocales,
      localizationsDelegates: localization.localizationsDelegates,
      home: HomeScreen(),
    );
  }

  void configureLocalization() {
    localization.init(mapLocales: LOCALS, initLanguageCode: "en");
    localization.onTranslatedLanguage = onTranslatedLanguage;
  }

  void onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }
}
