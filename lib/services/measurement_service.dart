import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mamicheckapp/models/measurement_model.dart';
import 'package:mamicheckapp/models/pregnancy_model.dart';

class MeasurementService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Crea una medición dentro del embarazo con ID [pregnancyId]
  Future<void> createMeasurement(PregnancyModel pregnancy, MeasurementModel measurement) async {
    // final measurementMap = measurement.toMap();
    //measurementMap['createdAt'] = FieldValue.serverTimestamp();
    // await _db
    //     .collection('pregnancies')
    //     .doc(pregnancyId)
    //     .collection('measurements')
    //     .add(measurementMap);

    // final pregnancyRef = _db.collection('pregnancies').doc(pregnancyId);
    // await pregnancyRef.update({'measurements':FieldValue.arrayUnion([measurement.toMap()])});
    final updatedMeasurements = [...pregnancy.measurements, measurement];
    await _db.collection('pregnancies').doc(pregnancy.id).update({
      'measurements': updatedMeasurements.map((m) => m.toMap()).toList()
    });

  }

  /// Puedes agregar más funciones como update, delete o listar si lo necesitas.
}
