import 'package:asset_manager/models/category/category.dart';
import 'package:asset_manager/screens/general_screen.dart';
import 'package:asset_manager/screens/workers_screen.dart';
import 'package:asset_manager/widgets/category/category_grid_item.dart';
import 'package:asset_manager/widgets/util/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'asset_screen.dart';
import 'census_list_screen.dart';
import 'location_screen.dart';

class HomeScreen extends StatelessWidget {
  static const id = 'home_screen';
  const HomeScreen({super.key});

  void _selectCategory(BuildContext context, Category category) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => GeneralScreen(body: category.body)));
  }

  @override
  Widget build(BuildContext context) {
    var categories = [
      Category(
        id: LocationScreen.id,
        title: AppLocalizations.of(context)!.locations,
        icon: const Icon(Icons.location_city),
        body: const LocationScreen(),
      ),
      Category(
        id: WorkersScreen.id,
        title: AppLocalizations.of(context)!.workers,
        icon: const Icon(Icons.person_2),
        body: const WorkersScreen(),
      ),
      Category(
        id: AssetScreen.id,
        title: AppLocalizations.of(context)!.assets,
        icon: const Icon(Icons.business_center),
        body: const AssetScreen(),
      ),
      Category(
          id: CensusListScreen.id,
          title: AppLocalizations.of(context)!.censusList,
          icon: const Icon(Icons.checklist),
          body: const CensusListScreen()),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.homeScreenTitle),
      ),
      drawer: const MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          children: categories
              .map(
                (cat) => CategoryGridItem(
                  category: cat,
                  onTap: () {
                    _selectCategory(context, cat);
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
