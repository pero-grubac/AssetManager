import 'package:uuid/uuid.dart';
import 'dart:convert';

const uuid = Uuid();

class Location {
  final String id;
  final double latitude;
  final double longitude;
  final String address;

  Location(
      {String? id,
      required this.latitude,
      required this.longitude,
      required this.address})
      : id = id ?? uuid.v4() {
    if (address.isEmpty) throw ArgumentError('Address cannot be empty');
  }
  Location.fromStrings({
    String? id,
    required String latitude,
    required String longitude,
    required this.address,
  })  : id = id ?? uuid.v4(),
        latitude = double.parse(latitude),
        longitude = double.parse(longitude) {
    if (address.isEmpty) throw ArgumentError('Address cannot be empty');

    if (longitude.isEmpty) {
      throw ArgumentError('Longitude type is wrong.');
    }
    if (latitude.isEmpty) {
      throw ArgumentError('Latitude type is wrong.');
    }
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
  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      id: map['id'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      address: map['address'],
    );
  }

  // Convert a PlaceLocation object into a JSON object
  String toJson() => json.encode(toMap());

  // Convert a JSON object into a PlaceLocation object
  factory Location.fromJson(String source) =>
      Location.fromMap(json.decode(source));
}
