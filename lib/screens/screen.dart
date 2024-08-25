import 'package:asset_manager/screens/location_screen.dart';
import 'package:asset_manager/widgets/util/curved_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/asset_location.dart';

class Screen extends StatelessWidget {
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final Widget body;
  final VoidCallback? onIconPressed;
  const Screen({
    super.key,
    this.searchController,
    this.onSearchChanged,
    required this.body,
    required this.onIconPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: onSearchChanged != null
            ? TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.search,
                  border: InputBorder.none,
                  hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
                ),
                onChanged: onSearchChanged,
              )
            : null,
      ),
      body: Column(
        children: [
          Expanded(
            child: body,
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: onIconPressed,
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: const Icon(Icons.add),
      ),
    );
  }
}
