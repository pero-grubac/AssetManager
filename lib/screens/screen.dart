import 'package:flutter/material.dart';

class Screen extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onAddButtonPressed;
  final Widget body;
  final String hintText;

  const Screen({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.onAddButtonPressed,
    required this.body,
    this.hintText = 'Search...',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
          ),
          onChanged: onSearchChanged,
        ),
        actions: [
          IconButton(
            onPressed: onAddButtonPressed,
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
