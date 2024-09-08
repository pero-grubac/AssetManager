import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class CensusList {
  static const String dbName = 'censusList';
  static const String dbFullName = 'assets.db';
  final String id;
  final String name;
  final DateTime creationDate;

  CensusList({
    String? id,
    required this.name,
    required this.creationDate,
  }) : id = id ?? uuid.v4() {
    if (name.isEmpty) throw ArgumentError('Name cannot be empty');
  }
  String get formatedDate {
    return DateFormat('dd.MM.yyyy').format(creationDate);
  }

  // Convert an InventoryList object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'creationDate': creationDate.toIso8601String(),
    };
  }

  // Convert a Map object into an InventoryList object
  factory CensusList.fromMap(Map<String, dynamic> map) {
    return CensusList(
      id: map['id'],
      name: map['name'],
      creationDate: DateTime.parse(map['creationDate']),
    );
  }

  // Convert an InventoryList object into a JSON object
  String toJson() => json.encode(toMap());

  // Convert a JSON object into an InventoryList object
  factory CensusList.fromJson(String source) =>
      CensusList.fromMap(json.decode(source));
}
