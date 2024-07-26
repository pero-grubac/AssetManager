import 'dart:convert';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Person {
  final String id;
  final String firstName;
  final String lastName;
  final String position;

  Person({
    String? id,
    required this.firstName,
    required this.lastName,
    required this.position,
  }) : id = id ?? uuid.v4() {
    if (firstName.isEmpty) throw ArgumentError('First name cannot be empty');
    if (lastName.isEmpty) throw ArgumentError('Last name cannot be empty');
    if (position.isEmpty) throw ArgumentError('Position cannot be empty');
  }

  // Convert a Person object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'position': position,
    };
  }

  // Convert a Map object into a Person object
  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      position: map['position'],
    );
  }

  // Convert a Person object into a JSON object
  String toJson() => json.encode(toMap());

  // Convert a JSON object into a Person object
  factory Person.fromJson(String source) => Person.fromMap(json.decode(source));
}
