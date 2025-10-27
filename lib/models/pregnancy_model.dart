// import 'package:cloud_firestore/cloud_firestore.dart';

// class PregnancyModel {
//   final String id;
//   final String name;
//   final String ownerId;
//   //final List<String> followers;
//   final bool isActive;

//   final DateTime lastMenstrualPeriod;
//   final int gravidity;
//   final int parity;
//   final DateTime interpregnancyInterval;
//   final bool previousHypertensiveDisorder;

//   final String multiplePregnancyType;
//   final bool assistedReproduction;

//   final int prePregnancyWeight;
//   final int prePregnancyHeight;

//   final String autoimmuneDisease;
//   final String diabetesHistory;
//   final bool familyHistoryPreeclampsia;
//   final bool chronicHypertension;
//   final bool chronicKidneyDisease;

//   PregnancyModel({
//     required this.id,
//     required this.name,
//     required this.ownerId,
//     //required this.followers,
//     required this.isActive,
//     required this.lastMenstrualPeriod,
//     required this.gravidity,
//     required this.parity,
//     required this.interpregnancyInterval,
//     required this.previousHypertensiveDisorder,
//     required this.multiplePregnancyType,
//     required this.assistedReproduction,
//     required this.prePregnancyWeight,
//     required this.prePregnancyHeight,
//     required this.autoimmuneDisease,
//     required this.diabetesHistory,
//     required this.familyHistoryPreeclampsia,
//     required this.chronicHypertension,
//     required this.chronicKidneyDisease,
//   });

//   factory PregnancyModel.fromFirestore(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     return PregnancyModel(
//       id: doc.id,
//       name: data['name'] ?? 'Embarazo sin Nombre',
//       ownerId: data['ownerId'] ?? '',
//       //followers: List<String>.from(data['followers'] ?? []),
//       isActive: data['isActive'] ?? true,

//       lastMenstrualPeriod: data['lastMenstrualPeriod']?.toDate() ?? DateTime.now(),
//       gravidity: data['gravidity'] ?? 1,
//       parity: data['parity'] ?? 0,
//       interpregnancyInterval: data['interpregnancyInterval']?.toDate() ?? DateTime.now(),
//       previousHypertensiveDisorder: data['previousHypertensiveDisorder'] ?? false,

//       multiplePregnancyType: data['multiplePregnancyType'] ?? 'Aun no sé',
//       assistedReproduction: data['assistedReproduction'] ?? false,

//       prePregnancyWeight: data['prePregnancyWeight'] ?? 57,
//       prePregnancyHeight: data['prePregnancyHeight'] ?? 151,

//       autoimmuneDisease: data['autoimmuneDisease'] ?? 'Ninguno',
//       diabetesHistory: data['diabetesHistory'] ?? 'Ninguno',
//       familyHistoryPreeclampsia: data['familyHistoryPreeclampsia'] ?? false,
//       chronicHypertension: data['chronicHypertension'] ?? false,
//       chronicKidneyDisease: data['chronicKidneyDisease'] ?? false,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'name': name,
//       'ownerId': ownerId,
//       //followers': followers,
//       'isActive': isActive,

//       'lastMenstrualPeriod': Timestamp.fromDate(lastMenstrualPeriod),
//       'gravidity': gravidity,
//       'parity': parity,
//       'interpregnancyInterval': Timestamp.fromDate(interpregnancyInterval),
//       'previousHypertensiveDisorder': previousHypertensiveDisorder,

//       'multiplePregnancyType': multiplePregnancyType,
//       'assistedReproduction': assistedReproduction,

//       'prePregnancyWeight': prePregnancyWeight,
//       'prePregnancyHeight': prePregnancyHeight,

//       'autoimmuneDisease': autoimmuneDisease,
//       'diabetesHistory': diabetesHistory,
//       'familyHistoryPreeclampsia': familyHistoryPreeclampsia,
//       'chronicHypertension': chronicHypertension,
//       'chronicKidneyDisease': chronicKidneyDisease,
//     };
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';

// class PregnancyModel {
//   final String id;
//   final String name;
//   final String ownerId;
//   final Map<String, String> followers;
//   final bool isActive;

//   final DateTime lastMenstrualPeriod;
//   final int gravidity;
//   final int parity;
//   final DateTime interpregnancyInterval;
//   final bool previousHypertensiveDisorder;

//   final String multiplePregnancyType;
//   final bool assistedReproduction;

//   final int prePregnancyWeight;
//   final int prePregnancyHeight;

//   final String autoimmuneDisease;
//   final String diabetesHistory;
//   final bool familyHistoryPreeclampsia;
//   final bool chronicHypertension;
//   final bool chronicKidneyDisease;

//   PregnancyModel({
//     required this.id,
//     required this.name,
//     required this.ownerId,
//     required this.followers,
//     required this.isActive,
//     required this.lastMenstrualPeriod,
//     required this.gravidity,
//     required this.parity,
//     required this.interpregnancyInterval,
//     required this.previousHypertensiveDisorder,
//     required this.multiplePregnancyType,
//     required this.assistedReproduction,
//     required this.prePregnancyWeight,
//     required this.prePregnancyHeight,
//     required this.autoimmuneDisease,
//     required this.diabetesHistory,
//     required this.familyHistoryPreeclampsia,
//     required this.chronicHypertension,
//     required this.chronicKidneyDisease,
//   });

//   factory PregnancyModel.fromFirestore(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;

//     return PregnancyModel(
//       id: doc.id,
//       name: data['name'] ?? 'Embarazo sin Nombre',
//       ownerId: data['ownerId'] ?? '',
//       followers: Map<String, String>.from(data['followers'] ?? {}),
//       isActive: data['isActive'] ?? true,
//       lastMenstrualPeriod: (data['lastMenstrualPeriod'] as Timestamp?)?.toDate() ?? DateTime.now(),
//       gravidity: data['gravidity'] ?? 1,
//       parity: data['parity'] ?? 0,
//       interpregnancyInterval: (data['interpregnancyInterval'] as Timestamp?)?.toDate() ?? DateTime.now(),
//       previousHypertensiveDisorder: data['previousHypertensiveDisorder'] ?? false,

//       multiplePregnancyType: data['multiplePregnancyType'] ?? 'Aun no sé',
//       assistedReproduction: data['assistedReproduction'] ?? false,

//       prePregnancyWeight: data['prePregnancyWeight'] ?? 57,
//       prePregnancyHeight: data['prePregnancyHeight'] ?? 151,

//       autoimmuneDisease: data['autoimmuneDisease'] ?? 'Ninguno',
//       diabetesHistory: data['diabetesHistory'] ?? 'Ninguno',
//       familyHistoryPreeclampsia: data['familyHistoryPreeclampsia'] ?? false,
//       chronicHypertension: data['chronicHypertension'] ?? false,
//       chronicKidneyDisease: data['chronicKidneyDisease'] ?? false,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'name': name,
//       'ownerId': ownerId,
//       'followers': followers,
//       'isActive': isActive,

//       'lastMenstrualPeriod': Timestamp.fromDate(lastMenstrualPeriod),
//       'gravidity': gravidity,
//       'parity': parity,
//       'interpregnancyInterval': Timestamp.fromDate(interpregnancyInterval),
//       'previousHypertensiveDisorder': previousHypertensiveDisorder,

//       'multiplePregnancyType': multiplePregnancyType,
//       'assistedReproduction': assistedReproduction,

//       'prePregnancyWeight': prePregnancyWeight,
//       'prePregnancyHeight': prePregnancyHeight,

//       'autoimmuneDisease': autoimmuneDisease,
//       'diabetesHistory': diabetesHistory,
//       'familyHistoryPreeclampsia': familyHistoryPreeclampsia,
//       'chronicHypertension': chronicHypertension,
//       'chronicKidneyDisease': chronicKidneyDisease,
//     };
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mamicheckapp/models/measurement_model.dart';

class PregnancyModel {
  final String id;
  final String name;
  final bool isActive;
  final DateTime lastMenstrualPeriod;
  
  final Map<String, int>? obstetricData;
  final List<String>? riskFactors;
  
  final Map<String, String> followers;
  final List<MeasurementModel> measurements;

  PregnancyModel({
    required this.id,
    required this.name,
    required this.isActive,
    required this.lastMenstrualPeriod,
    this.obstetricData,
    this.riskFactors,
    required this.followers,
    required this.measurements,
  });

  factory PregnancyModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return PregnancyModel(
      id: doc.id,
      name: data['name'] ?? 'Sin nombre',
      isActive: data['isActive'] ?? true,
      lastMenstrualPeriod: (data['lastMenstrualPeriod'] as Timestamp).toDate(),
      
      riskFactors: List<String>.from(data['riskFactors']),

      followers: Map<String, String>.from(data['followers'] ?? {}),
      measurements: (data['measurements'] as List<dynamic>? ?? []).map((m) => MeasurementModel.fromFirestore(Map<String, dynamic>.from(m))).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    final map = {
      'name': name,
      'isActive': isActive,
      'lastMenstrualPeriod': Timestamp.fromDate(lastMenstrualPeriod),
      'followers': followers,
      //'measurements': measurements,
      'measurements': measurements.map((m) => m.toMap()).toList(),
    };

    if (riskFactors != null) map['riskFactors'] = riskFactors!;
    if (obstetricData != null) map['obstetricData'] = obstetricData!;

    return map;
  }
}
