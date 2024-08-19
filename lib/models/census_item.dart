import 'dart:convert';
import 'package:uuid/uuid.dart';

import 'identifiable.dart';

const uuid = Uuid();

class CensusItem implements Identifiable {
  static const String dbName = 'censusItem';
  static const String dbFullName = 'censusItem.db';
  @override
  final String id;
  final String censusListId;
  final String assetId;
  final String oldPersonId;
  final String newPersonId;
  final String oldLocationId;
  final String newLocationId;
  final DateTime createdAt;

  CensusItem({
    String? id,
    required this.censusListId,
    required this.assetId,
    required this.oldPersonId,
    required this.newPersonId,
    required this.oldLocationId,
    required this.newLocationId,
    DateTime? createdAt,
  })  : id = id ?? uuid.v4(),
        createdAt = createdAt ?? DateTime.now() {
    if (assetId.isEmpty) throw ArgumentError('Asset ID cannot be empty');
    if (oldPersonId.isEmpty) {
      throw ArgumentError('Current person ID must be a positive integer');
    }
    if (newPersonId.isEmpty) {
      throw ArgumentError('Current person ID must be a positive integer');
    }
    if (oldLocationId.isEmpty) {
      throw ArgumentError('Current location ID must be a positive integer');
    }
    if (newLocationId.isEmpty) {
      throw ArgumentError('Current location ID must be a positive integer');
    }
  }
  // Convert an InventoryItem object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'censusListId': censusListId,
      'assetId': assetId,
      'oldPersonId': oldPersonId,
      'newPersonId': newPersonId,
      'oldLocationId': oldLocationId,
      'newLocationId': newLocationId,
    };
  }

  // Convert a Map object into an InventoryItem object
  factory CensusItem.fromMap(Map<String, dynamic> map) {
    return CensusItem(
      id: map['id'],
      censusListId: map['censusListId'],
      assetId: map['assetId'],
      oldPersonId: map['oldPersonId'],
      newPersonId: map['newPersonId'],
      oldLocationId: map['oldLocationId'],
      newLocationId: map['newLocationId'],
    );
  }

  // Convert an InventoryItem object into a JSON object
  String toJson() => json.encode(toMap());

  // Convert a JSON object into an InventoryItem object
  factory CensusItem.fromJson(String source) =>
      CensusItem.fromMap(json.decode(source));
}
