import 'package:cloud_firestore/cloud_firestore.dart';

class MeasurementModel {
  final DateTime date;
  final int age;
  final int systolicBP;
  final int diastolicBP;
  final int heartRate;
  final double? bloodSugar;
  final double? temperature;
  final int? riskLevel;
  final String? notes;

  MeasurementModel({
    required this.date,
    required this.age,
    required this.systolicBP,
    required this.diastolicBP,
    required this.heartRate,
    this.bloodSugar,
    this.temperature,
    this.riskLevel,
    this.notes,
  });

  factory MeasurementModel.fromFirestore(Map<String, dynamic> data) {
    return MeasurementModel(
      date: data['date']?.toDate() ?? DateTime(1900),
      age: data['age'] ?? 0,
      systolicBP: data['systolicBP'] ?? 0,
      diastolicBP: data['diastolicBP'] ?? 0,
      heartRate: data['heartRate'] ?? 0,
      bloodSugar: (data['bloodSugar'] is num)
          ? (data['bloodSugar'] as num).toDouble()
          : null,
      temperature: (data['temperature'] is num)
          ? (data['temperature'] as num).toDouble()
          : null,
      riskLevel: data['riskLevel'],
      notes: data['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    final map = {
      'date': Timestamp.fromDate(date),
      'age': age,
      'systolicBP': systolicBP,
      'diastolicBP': diastolicBP,
      'heartRate': heartRate,
    };

    if (bloodSugar != null) map['bloodSugar'] = bloodSugar!;
    if (temperature != null) map['temperature'] = temperature!;
    if (riskLevel != null) map['riskLevel'] = riskLevel!;
    if (notes != null && notes!.trim().isNotEmpty) map['notes'] = notes!;

    return map;
  }

  MeasurementModel copyWith({
    int? systolicBP,
    int? diastolicBP,
    int? heartRate,
    int? age,
    double? bloodSugar,
    double? temperature,
    int? riskLevel,
    String? notes,
    DateTime? date,
  }) {
    return MeasurementModel(
      systolicBP: systolicBP ?? this.systolicBP,
      diastolicBP: diastolicBP ?? this.diastolicBP,
      heartRate: heartRate ?? this.heartRate,
      age: age ?? this.age,
      bloodSugar: bloodSugar ?? this.bloodSugar,
      temperature: temperature ?? this.temperature,
      riskLevel: riskLevel ?? this.riskLevel,
      notes: notes ?? this.notes,
      date: date ?? this.date,
    );
  }
}
