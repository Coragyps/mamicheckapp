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

  // Future<UserModel?> getUser(String uid) async {
  //   final doc = await _db.collection('users').doc(uid).get();

  //   if (!doc.exists) {
  //     debugPrint('⚠️ Usuario con UID $uid no encontrado en Firestore.');
  //     return null;
  //   }

  //   final userModel = UserModel.fromFirestore(doc);
  //   debugPrint('✅ Usuario cargado desde Firestore: ${userModel.toMap()}');
  //   return userModel;
  // }
}