import 'package:flutter/material.dart';

class Screen extends StatelessWidget {
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final Widget body;
  final Widget overlay;
  final String hintText;

  const Screen({
    super.key,
    this.searchController,
    this.onSearchChanged,
    required this.body,
    required this.overlay,
    this.hintText = 'Search...',
  });

  @override
  Widget build(BuildContext context) {
    void openAddOverlay() {
      showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => overlay,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: onSearchChanged != null
            ? TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: hintText,
                  border: InputBorder.none,
                  hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
                ),
                onChanged: onSearchChanged,
              )
            : null,
        actions: [
          IconButton(
            onPressed: openAddOverlay,
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
