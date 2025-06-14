import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mamicheckapp/models/pregnancy_model.dart';

class PregnancyService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future <void> createPregnancyDocument(PregnancyModel pregnancy) async {
    final pregnancyMap = pregnancy.toMap();
    pregnancyMap['createdAt'] = FieldValue.serverTimestamp();
    await _db
      .collection('pregnancies')
      .doc()
      .set(pregnancyMap, SetOptions(merge: true));
  }

  Future<PregnancyModel?> getPregnancy(String id) async {
    final doc = await _db.collection('pregnancies').doc(id).get();
    if (!doc.exists) return null;
    return PregnancyModel.fromFirestore(doc);
  }

  Future<void> updatePregnancy(String id, Map<String, dynamic> data) async {
    await _db.collection('pregnancies').doc(id).update(data);
  }

  /// Obtiene todos los embarazos donde el UID sea owner o esté en la lista de followers.
  Future<List<PregnancyModel>> getPregnanciesForUser(String uid) async {
    final querySnapshot = await _db
        .collection('pregnancies')
        .where('followers', arrayContains: uid)
        .get();

    final ownerQuerySnapshot = await _db
        .collection('pregnancies')
        .where('ownerId', isEqualTo: uid)
        .get();

    // Combinar sin duplicados
    final allDocs = {...querySnapshot.docs, ...ownerQuerySnapshot.docs};
    return allDocs.map((doc) => PregnancyModel.fromFirestore(doc)).toList();
  }

  Future<void> addFollower(String pregnancyId, String uid) async {
    final docRef = FirebaseFirestore.instance.collection('pregnancies').doc(pregnancyId);
    await docRef.update({'followers.$uid': 'companion'});
  }

  Future<void> removeFollower(String pregnancyId, String uid) async {
    final docRef = FirebaseFirestore.instance.collection('pregnancies').doc(pregnancyId);
    await docRef.update({'followers.$uid': FieldValue.delete()});
  }

  // Stream<List<PregnancyModel>> watchFollowedPregnancies(String uid) {
  //   return _db
  //       .collection('pregnancies')
  //       .where('followers', arrayContains: uid)
  //       .snapshots()
  //       .map((QuerySnapshot snapshot) {
  //         return snapshot.docs
  //             .where((doc) => doc.exists)
  //             .map((doc) => PregnancyModel.fromFirestore(doc))
  //             .toList();
  //       });
  // }

  Stream<List<PregnancyModel>> watchFollowedPregnancies(String uid) {
    return _db
      .collection('pregnancies')
      .where('followers.$uid', whereIn: ["owner", "companion"])
      .snapshots()
      .map((QuerySnapshot snapshot) {
        return snapshot.docs
          .where((doc) => doc.exists)
          .map((doc) => PregnancyModel.fromFirestore(doc))
          .toList();
      });
  }
}