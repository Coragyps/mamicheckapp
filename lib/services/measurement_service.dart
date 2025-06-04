import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mamicheckapp/models/measurement_model.dart';

class MeasurementService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Crea una medición dentro del embarazo con ID [pregnancyId]
  Future<void> createMeasurement(String pregnancyId, MeasurementModel measurement ) async {
    final measurementMap = measurement.toMap();
    measurementMap['createdAt'] = FieldValue.serverTimestamp();

    await _db
        .collection('pregnancies')
        .doc(pregnancyId)
        .collection('measurements')
        .add(measurementMap);
  }

  /// Puedes agregar más funciones como update, delete o listar si lo necesitas.
}
