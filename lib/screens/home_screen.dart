import 'package:asset_manager/models/category/category.dart';
import 'package:asset_manager/models/category/category_data.dart';
import 'package:asset_manager/widgets/category/category_grid_item.dart';
import 'package:asset_manager/widgets/util/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  static const id = 'home_screen';
  const HomeScreen({super.key});
  void _selectCategory(BuildContext context, Category category) {
    Navigator.of(context).pushNamed(category.id);
  }

  @override
  Widget build(BuildContext context) {
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
