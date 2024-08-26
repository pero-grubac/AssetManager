import 'package:asset_manager/screens/asset_screen.dart';
import 'package:asset_manager/screens/home_screen.dart';
import 'package:asset_manager/screens/location_screen.dart';
import 'package:asset_manager/screens/settings_screen.dart';
import 'package:asset_manager/screens/workers_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'census_list_screen.dart';

class GeneralScreen extends StatefulWidget {
  const GeneralScreen({super.key, required this.body});
  final Widget body;
  @override
  State<GeneralScreen> createState() => _GeneralScreenState();
}

class _GeneralScreenState extends State<GeneralScreen> {
  int selected = 0;
  Widget? body;

  @override
  void initState() {
    body = widget.body;
    switch (body.runtimeType) {
      case LocationScreen _:
        selected = 2;
        break;
      case WorkersScreen _:
        selected = 3;
        break;
      case AssetScreen _:
        selected = 4;
        break;
      case CensusListScreen _:
        selected = 5;
        break;
      default:
        selected = 0;
    }
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      selected = index;
      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, SettingsScreen.id);
          break;
        case 1:
          Navigator.pushReplacementNamed(context, HomeScreen.id);
          break;
        case 2:
          body = const LocationScreen();
          break;
        case 3:
          body = const WorkersScreen();
          break;
        case 4:
          body = const AssetScreen();
          break;
        case 5:
          body = const CensusListScreen();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var categories = [
      Icon(
        Icons.settings,
        color: Theme.of(context).colorScheme.surface,
      ),
      Icon(
        Icons.home,
        color: Theme.of(context).colorScheme.surface,
      ),
      Icon(
        Icons.location_city,
        color: Theme.of(context).colorScheme.surface,
      ),
      Icon(
        Icons.person_2,
        color: Theme.of(context).colorScheme.surface,
      ),
      Icon(
        Icons.business_center,
        color: Theme.of(context).colorScheme.surface,
      ),
      Icon(
        Icons.checklist,
        color: Theme.of(context).colorScheme.surface,
      ),
    ];
    return Scaffold(
      body: body,
      bottomNavigationBar: CurvedNavigationBar(
        index: selected,
        items: categories.toList(),
        color: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        onTap: (index) {
          _onItemTapped(index);
        },
      ),
    );
  }
}
