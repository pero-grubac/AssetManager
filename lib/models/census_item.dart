import 'dart:convert';
import 'package:uuid/uuid.dart';

import 'identifiable.dart';

const uuid = Uuid();

class CensusItem implements Identifiable {
  @override
  final String id;
  final String assetListId;
  final String assetId;
  final String currentPersonId;
  final String newPersonId;
  final String currentLocationId;
  final String newLocationId;

  CensusItem({
    String? id,
    required this.assetListId,
    required this.assetId,
    required this.currentPersonId,
    required this.newPersonId,
    required this.currentLocationId,
    required this.newLocationId,
  }) : id = id ?? uuid.v4() {
    if (assetId.isEmpty) throw ArgumentError('Asset ID cannot be empty');
    if (currentPersonId.isEmpty) {
      throw ArgumentError('Current person ID must be a positive integer');
    }
    if (newPersonId.isEmpty) {
      throw ArgumentError('New person ID must be a positive integer');
    }
    if (currentLocationId.isEmpty) {
      throw ArgumentError('Current location ID must be a positive integer');
    }
    if (newLocationId.isEmpty) {
      throw ArgumentError('New location ID must be a positive integer');
    }
  }
  // Convert an InventoryItem object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'assetListId': assetListId,
      'assetId': assetId,
      'currentPersonId': currentPersonId,
      'newPersonId': newPersonId,
      'currentLocationId': currentLocationId,
      'newLocationId': newLocationId,
    };
  }

  // Convert a Map object into an InventoryItem object
  factory CensusItem.fromMap(Map<String, dynamic> map) {
    return CensusItem(
      id: map['id'],
      assetListId: map['assetListId'],
      assetId: map['assetId'],
      currentPersonId: map['currentPersonId'],
      newPersonId: map['newPersonId'],
      currentLocationId: map['currentLocationId'],
      newLocationId: map['newLocationId'],
    );
  }

  // Convert an InventoryItem object into a JSON object
  String toJson() => json.encode(toMap());

  // Convert a JSON object into an InventoryItem object
  factory CensusItem.fromJson(String source) =>
      CensusItem.fromMap(json.decode(source));
}
