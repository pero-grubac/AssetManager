import 'package:flutter/material.dart';

class BuildTextField extends StatelessWidget {
  const BuildTextField({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType = TextInputType.text,
    required this.isEditable,
  });
  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;
  final bool isEditable;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
      ),
      keyboardType: keyboardType,
      readOnly: isEditable,
    );
  }
}
