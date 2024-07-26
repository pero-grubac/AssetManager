import 'package:uuid/uuid.dart';
import 'dart:convert';

const uuid = Uuid();

class PlaceLocation {
  final String id;
  final double latitude;
  final double longitude;
  final String address;

  PlaceLocation(
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
  factory PlaceLocation.fromMap(Map<String, dynamic> map) {
    return PlaceLocation(
      id: map['id'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      address: map['address'],
    );
  }

  // Convert a PlaceLocation object into a JSON object
  String toJson() => json.encode(toMap());

  // Convert a JSON object into a PlaceLocation object
  factory PlaceLocation.fromJson(String source) =>
      PlaceLocation.fromMap(json.decode(source));
}
