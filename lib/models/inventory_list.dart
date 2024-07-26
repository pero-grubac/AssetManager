import 'dart:convert';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class InventoryList {
  final String id;
  final String name;

  InventoryList({
    String? id,
    required this.name,
  }) : id = id ?? uuid.v4() {
    if (name.isEmpty) throw ArgumentError('Name cannot be empty');
  }

  // Convert an InventoryList object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  // Convert a Map object into an InventoryList object
  factory InventoryList.fromMap(Map<String, dynamic> map) {
    return InventoryList(
      id: map['id'],
      name: map['name'],
    );
  }

  // Convert an InventoryList object into a JSON object
  String toJson() => json.encode(toMap());

  // Convert a JSON object into an InventoryList object
  factory InventoryList.fromJson(String source) =>
      InventoryList.fromMap(json.decode(source));
}
