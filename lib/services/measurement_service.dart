import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mamicheckapp/models/measurement_model.dart';
import 'package:mamicheckapp/models/pregnancy_model.dart';

class MeasurementService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Crea una medición dentro del embarazo con ID [pregnancyId]
  Future<void> createMeasurement(PregnancyModel pregnancy, MeasurementModel measurement) async {
    final updatedMeasurements = [...pregnancy.measurements, measurement];
    await _db.collection('pregnancies').doc(pregnancy.id).update({
      'measurements': updatedMeasurements.map((m) => m.toMap()).toList()
    });
  }

  /// Edita una medición existente dentro del embarazo (identificada por la fecha)
  Future<void> editMeasurement(PregnancyModel pregnancy, MeasurementModel updatedMeasurement) async {
    // Clonamos la lista actual
    final updatedMeasurements = [...pregnancy.measurements];

    // Buscamos la medición existente por fecha
    final index = updatedMeasurements.indexWhere(
      (m) => m.date.isAtSameMomentAs(updatedMeasurement.date),
    );

    if (index == -1) {
      throw Exception('La medición a editar no existe.');
    }

    // Reemplazamos la medición
    updatedMeasurements[index] = updatedMeasurement;

    // Guardamos en Firestore
    await _db.collection('pregnancies').doc(pregnancy.id).update({
      'measurements': updatedMeasurements.map((m) => m.toMap()).toList()
    });
  }

  ///nueva version
  Future<void> updateMeasurement({required String pregnancyId, required List<MeasurementModel> currentMeasurements, required MeasurementModel updatedMeasurement}) async {
    final updatedList = currentMeasurements.map((m) {
      return m.date == updatedMeasurement.date ? updatedMeasurement : m;
    }).toList();

    await FirebaseFirestore.instance.collection('pregnancies').doc(pregnancyId).update({
      'measurements': updatedList.map((m) => m.toMap()).toList(),
    });
  }
}
