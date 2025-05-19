import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final bool isPregnant;

  UserModel({
    required this.uid,
    this.email = '???',
    this.firstName = '???',
    this.lastName = '???',
    DateTime? birthDate,
    this.isPregnant = true,
  }) : birthDate = birthDate ?? DateTime.now();

  factory UserModel.fromJson(Map<String, dynamic> json, String uid) {
    return UserModel(
      uid: uid,
      email: json['email'] ?? '???',
      firstName: json['firstName'] ?? '???',
      lastName: json['lastName'] ?? '???',
      birthDate: json['birthDate'] is Timestamp
          ? (json['birthDate'] as Timestamp).toDate()
          : DateTime.now(),
      isPregnant: json['isPregnant'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'birthDate': Timestamp.fromDate(birthDate),
      'isPregnant': isPregnant,
    };
  }
}