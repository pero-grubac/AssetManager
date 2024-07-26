import 'dart:convert';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Asset {
  final String id;
  final String name;
  final String description;
  final int barcode;
  final double price;
  final DateTime creationDate;
  final String assignedPerson;
  final String assignedLocation;
  final String imagePath;

  Asset({
    String? id,
    required this.name,
    required this.description,
    required this.barcode,
    required this.price,
    required this.creationDate,
    required this.assignedPerson,
    required this.assignedLocation,
    required this.imagePath,
  }) : id = id ?? uuid.v4() {
    // Basic validation
    if (name.isEmpty) throw ArgumentError('Name cannot be empty');
    if (description.isEmpty) throw ArgumentError('Description cannot be empty');
    if (barcode <= 0) throw ArgumentError('Barcode must be a positive integer');
    if (price <= 0) throw ArgumentError('Price must be a positive number');
    if (assignedPerson.isEmpty) {
      throw ArgumentError('Assigned person cannot be empty');
    }
    if (assignedLocation.isEmpty) {
      throw ArgumentError('Assigned location cannot be empty');
    }
    if (imagePath.isEmpty) throw ArgumentError('Image path cannot be empty');
  }

  // Convert an Asset object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'barcode': barcode,
      'price': price,
      'creationDate': creationDate.toIso8601String(),
      'assignedPerson': assignedPerson,
      'assignedLocation': assignedLocation,
      'imagePath': imagePath,
    };
  }

  // Convert a Map object into an Asset object
  factory Asset.fromMap(Map<String, dynamic> map) {
    return Asset(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      barcode: map['barcode'],
      price: map['price'],
      creationDate: DateTime.parse(map['creationDate']),
      assignedPerson: map['assignedPerson'],
      assignedLocation: map['assignedLocation'],
      imagePath: map['imagePath'],
    );
  }

  // Convert an Asset object into a JSON object
  String toJson() => json.encode(toMap());

  // Convert a JSON object into an Asset object
  factory Asset.fromJson(String source) => Asset.fromMap(json.decode(source));
}
