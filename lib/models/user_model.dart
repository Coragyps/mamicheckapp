import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final String telephoneNumber;
  final bool isPregnant;

  UserModel({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.telephoneNumber,
    required this.isPregnant,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '???',
      firstName: data['firstName'] ?? '???',
      lastName: data['lastName'] ?? '???',
      birthDate: data['birthDate']?.toDate() ?? DateTime.now(),
      telephoneNumber: data['telephoneNumber'] ?? '???',
      isPregnant: data['isPregnant'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'birthDate': Timestamp.fromDate(birthDate),
      'telephoneNumber': telephoneNumber,
      'isPregnant': isPregnant,
    };
  }
}