import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mamicheckapp/models/user_model.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createUserDocument(UserModel user) async {
    final userMap = user.toMap();
    userMap['createdAt'] = FieldValue.serverTimestamp();
    await _db
      .collection('users')
      .doc(user.uid)
      .set(userMap, SetOptions(merge: true));
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromFirestore(doc);
  }

  Stream<UserModel?> watchUser(String? uid) {
    if (uid == null || uid.isEmpty) {return const Stream.empty();}

    return _db.collection('users').doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserModel.fromFirestore(doc);
    });
  }

  Future<String?> getUidByEmail(String email) async {
    final query = await _db.collection('users').where('email', isEqualTo: email).limit(1).get();
    if (query.docs.isEmpty) return null;
    return query.docs.first.id; // el UID es el ID del documento
  }

  Future<void> sendPregnancyInviteNotification({required String uid, required String pregnancyId, required String pregnancyName}) async {
    final docRef = _db.collection('users').doc(uid);

    final newNotification = {
      'pregnancyId': pregnancyId,
      'pregnancyName': pregnancyName,
      'timestamp': DateTime.now().toIso8601String(),
    };

    await docRef.update({
      'notifications': FieldValue.arrayUnion([newNotification])
    });
  }

  Future<void> deleteNotification({required String uid, required String pregnancyId, required String pregnancyName, required String timestamp }) async {
    final docRef = _db.collection('users').doc(uid);

    final notificationToRemove = {
      'pregnancyId': pregnancyId,
      'pregnancyName': pregnancyName,
      'timestamp': timestamp,
    };

    await docRef.update({
      'notifications': FieldValue.arrayRemove([notificationToRemove])
    });
  }
}