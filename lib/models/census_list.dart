import 'dart:convert';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class CensusList {
  final String id;
  final String name;

  CensusList({
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
  factory CensusList.fromMap(Map<String, dynamic> map) {
    return CensusList(
      id: map['id'],
      name: map['name'],
    );
  }

  // Convert an InventoryList object into a JSON object
  String toJson() => json.encode(toMap());

  // Convert a JSON object into an InventoryList object
  factory CensusList.fromJson(String source) =>
      CensusList.fromMap(json.decode(source));
}
