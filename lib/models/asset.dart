import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'identifiable.dart';

const uuid = Uuid();

class Asset implements Identifiable {
  static const String dbName = 'assets';
  static const String dbFullName = 'assets.db';

  @override
  final String id;
  final String name;
  final String description;
  final int barcode;
  final double price;
  final DateTime creationDate;
  late File image;

  Asset({
    String? id,
    required this.name,
    required this.description,
    required this.barcode,
    required this.price,
    required this.creationDate,
    required this.image,
  }) : id = id ?? uuid.v4() {
    if (name.isEmpty) throw ArgumentError('Name cannot be empty');
    if (description.isEmpty) throw ArgumentError('Description cannot be empty');
    if (barcode <= 0) throw ArgumentError('Barcode must be a positive integer');
    if (price <= 0) throw ArgumentError('Price must be a positive number');

    if (image.path.isEmpty) throw ArgumentError('Image  cannot be empty');
  }

  String get formatedDate {
    return DateFormat('dd.MM.yyyy').format(creationDate);
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
      image: File(map['imagePath']),
    );
  }

  // Convert an Asset object into a JSON object
  String toJson() => json.encode(toMap());

  // Convert a JSON object into an Asset object
  factory Asset.fromJson(String source) => Asset.fromMap(json.decode(source));
}
