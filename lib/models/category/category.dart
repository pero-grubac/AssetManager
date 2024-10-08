import 'package:flutter/material.dart';

class Category {
  final String id;
  final String title;
  final Icon icon;
  final Widget body;
  const Category(
      {required this.id,
      required this.title,
      required this.icon,
      required this.body});
}
