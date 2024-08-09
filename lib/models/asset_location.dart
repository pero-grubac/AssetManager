import 'package:uuid/uuid.dart';
import 'dart:convert';

const uuid = Uuid();

class AssetLocation {
  final String id;
  final double latitude;
  final double longitude;
  final String address;

  AssetLocation(
      {String? id,
      required this.latitude,
      required this.longitude,
      required this.address})
      : id = id ?? uuid.v4() {
    if (address.isEmpty) throw ArgumentError('Address cannot be empty');
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }

  // Convert a Map object into a PlaceLocation object
  factory AssetLocation.fromMap(Map<String, dynamic> map) {
    return AssetLocation(
      id: map['id'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      address: map['address'],
    );
  }

  // Convert a PlaceLocation object into a JSON object
  String toJson() => json.encode(toMap());

  // Convert a JSON object into a PlaceLocation object
  factory AssetLocation.fromJson(String source) =>
      AssetLocation.fromMap(json.decode(source));
}
