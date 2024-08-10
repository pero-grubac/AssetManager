import 'dart:convert';
import 'dart:io';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Asset {
  final String id;
  final String name;
  final String description;
  final int barcode;
  final double price;
  final DateTime creationDate;
  final String assignedPersonId;
  final String assignedLocationId;
  late File image;

  Asset({
    String? id,
    required this.name,
    required this.description,
    required this.barcode,
    required this.price,
    required this.creationDate,
    required this.assignedPersonId,
    required this.assignedLocationId,
    required this.image,
  }) : id = id ?? uuid.v4() {
    // Basic validation
    if (name.isEmpty) throw ArgumentError('Name cannot be empty');
    if (description.isEmpty) throw ArgumentError('Description cannot be empty');
    if (barcode <= 0) throw ArgumentError('Barcode must be a positive integer');
    if (price <= 0) throw ArgumentError('Price must be a positive number');
    if (assignedPersonId.isEmpty) {
      throw ArgumentError('Assigned person id must be a positive number');
    }
    if (assignedLocationId.isEmpty) {
      throw ArgumentError('Assigned location id cannot be empty');
    }
    if (image == null) throw ArgumentError('Image  cannot be empty');
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
      'assignedPersonId': assignedPersonId,
      'assignedLocationId': assignedLocationId,
      'imagePath': image.path,
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
      assignedPersonId: map['assignedPersonId'],
      assignedLocationId: map['assignedLocationId'],
      image: File(map['imagePath']),
    );
  }

  // Convert an Asset object into a JSON object
  String toJson() => json.encode(toMap());

  // Convert a JSON object into an Asset object
  factory Asset.fromJson(String source) => Asset.fromMap(json.decode(source));
}
