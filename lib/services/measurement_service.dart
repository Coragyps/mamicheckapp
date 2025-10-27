import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mamicheckapp/models/measurement_model.dart';

class MeasurementService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Crea una medición dentro del embarazo con ID [pregnancyId]
  Future<void> createMeasurement(String pregnancyId, List<MeasurementModel> currentMeasurements, MeasurementModel newMeasurement) async {
    final updatedMeasurements = [...currentMeasurements, newMeasurement];
    await _db.collection('pregnancies').doc(pregnancyId).update({'measurements': updatedMeasurements.map((m) => m.toMap()).toList()});
  }

  /// Edita una medición existente dentro del embarazo (identificada por la fecha)
  Future<void> editMeasurement(String pregnancyId, List<MeasurementModel> currentMeasurements, MeasurementModel updatedMeasurement) async {
    // Buscamos la medición existente por fecha
    final index = currentMeasurements.indexWhere(
      (m) => m.date.isAtSameMomentAs(updatedMeasurement.date),
    );

    if (index == -1) {throw Exception('La medición a editar no existe.');}
    currentMeasurements[index] = updatedMeasurement;
    await _db.collection('pregnancies').doc(pregnancyId).update({'measurements': currentMeasurements.map((m) => m.toMap()).toList()});
  }

  ///nueva version
  Future<void> updateMeasurement({required String pregnancyId, required List<MeasurementModel> currentMeasurements, required MeasurementModel updatedMeasurement}) async {
    final updatedList = currentMeasurements.map((m) {
      return m.date == updatedMeasurement.date ? updatedMeasurement : m;
    }).toList();

    await FirebaseFirestore.instance.collection('pregnancies').doc(pregnancyId).update({'measurements': updatedList.map((m) => m.toMap()).toList(),});
  }
}
