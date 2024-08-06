import 'dart:convert';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Worker {
  final String id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;

  Worker({
    String? id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
  }) : id = id ?? uuid.v4() {
    if (firstName.isEmpty) throw ArgumentError('First name cannot be empty');
    if (lastName.isEmpty) throw ArgumentError('Last name cannot be empty');
    if (phoneNumber.isEmpty || !_isValidPhoneNumber(phoneNumber)) {
      throw ArgumentError('Please enter a valid phone number');
    }
    if (email.isEmpty || !_isValidEmail(email)) {
      throw ArgumentError('Please enter a valid email address');
    }
  }

  static bool _isValidPhoneNumber(String phoneNumber) {
    final RegExp phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');
    return phoneRegex.hasMatch(phoneNumber);
  }

  static bool _isValidEmail(String email) {
    final RegExp emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  bool isEmpty() {
    return firstName.isEmpty || lastName.isEmpty || phoneNumber.isEmpty;
  }

  String get fullName {
    return "$firstName $lastName";
  }

  // Convert a Person object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'email': email,
    };
  }

  // Convert a Map object into a Person object
  factory Worker.fromMap(Map<String, dynamic> map) {
    return Worker(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      phoneNumber: map['phoneNumber'],
      email: map['email'],
    );
  }

  // Convert a Person object into a JSON object
  String toJson() => json.encode(toMap());

  // Convert a JSON object into a Person object
  factory Worker.fromJson(String source) => Worker.fromMap(json.decode(source));
}
