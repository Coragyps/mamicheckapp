import 'package:cloud_firestore/cloud_firestore.dart';

class MeasurementModel {
  final String id;
  final DateTime date;
  final int age;

  final int? systolicBP;
  final int? diastolicBP;
  final int? bloodSugar;
  final int? temperature;
  final int? heartRate;
  final int? riskLevel;
  final String? notes;

  MeasurementModel({
    required this.id,
    required this.date,
    required this.age,
    this.systolicBP,
    this.diastolicBP,
    this.bloodSugar,
    this.temperature,
    this.heartRate,
    this.riskLevel,
    this.notes,
  });

  factory MeasurementModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MeasurementModel(
      id: doc.id,
      date: data['date']?.toDate() ?? DateTime(1900),
      age: data['age'] ?? 0,
      systolicBP: data['systolicBP'],
      diastolicBP: data['diastolicBP'],
      bloodSugar: data['bloodSugar'],
      temperature: data['temperature'],
      heartRate: data['heartRate'],
      riskLevel: data['riskLevel'],
      notes: data['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'date': Timestamp.fromDate(date),
      'age': age,
    };

    if (systolicBP != null) map['systolicBP'] = systolicBP;
    if (diastolicBP != null) map['diastolicBP'] = diastolicBP;
    if (bloodSugar != null) map['bloodSugar'] = bloodSugar;
    if (temperature != null) map['temperature'] = temperature;
    if (heartRate != null) map['heartRate'] = heartRate;
    if (riskLevel != null) map['riskLevel'] = riskLevel;
    if (notes != null && notes!.trim().isNotEmpty) map['notes'] = notes;

    return map;
  }
}