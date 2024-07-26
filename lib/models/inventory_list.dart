import 'dart:convert';
import 'package:uuid/uuid.dart';

import 'inventory_item.dart';

const uuid = Uuid();

class InventoryList {
  final String id;
  final String name;
  final List<InventoryItem> items;

  InventoryList({
    String? id,
    required this.name,
    required this.items,
  }) : id = id ?? uuid.v4() {
    if (name.isEmpty) throw ArgumentError('Name cannot be empty');
  }

  // Convert an InventoryList object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'items': items.map((item) => item.toMap()).toList(),
    };
  }

  // Convert a Map object into an InventoryList object
  factory InventoryList.fromMap(Map<String, dynamic> map) {
    return InventoryList(
      id: map['id'],
      name: map['name'],
      items: List<InventoryItem>.from(
          map['items']?.map((item) => InventoryItem.fromMap(item))),
    );
  }

  // Convert an InventoryList object into a JSON object
  String toJson() => json.encode(toMap());

  // Convert a JSON object into an InventoryList object
  factory InventoryList.fromJson(String source) =>
      InventoryList.fromMap(json.decode(source));
}
