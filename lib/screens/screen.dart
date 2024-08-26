import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        actions: [
          IconButton(
            onPressed: onIconPressed,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: body,
          ),
        ],
      ),
    );
  }
}
