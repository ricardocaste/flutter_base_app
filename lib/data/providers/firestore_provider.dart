import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/infrastructure/firestore_utils.dart';
import 'package:flutter_app/domain/entities/user.dart' as mem;

class FirestoreProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUser(mem.User user) async {
    user.token = await FirestoreUtils.getIdTokenFromFirestore();
    try {
      await _firestore.collection('users').doc(user.uid).set(user.toJson());
    } catch (e) {
      if (kDebugMode) {
        print('Error creating user in Firestore: $e');
      }
    }
  }

  Future<void> saveLanguage(String uid, String language) {
    return _firestore.collection('users').doc(uid).update({'language': language});
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getStreamUser(String uid) {
    return _firestore.collection('users').doc(uid).snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUser(String uid) {
    return _firestore.collection('users').doc(uid).get();
  }

  Future<bool> existUser(String uid) async{
    DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore.collection('users').doc(uid).get();
    return snapshot.exists;
  }

  Future<void> updateAppUser(mem.User user) async {
    user.updatedAt = Timestamp.now();
    await _firestore.collection('users').doc(user.uid).update(user.toJson());
  }
 
  Future<void> updateAvatarUser(String uid, String photoUrl) async {
    await _firestore.collection('users').doc(uid).update({'avatar': photoUrl});
  }

  Future<bool> existUserWithEmail(String email) async{
    final snapshot = (await _firestore.collection('users')
        .where("email", isEqualTo: email).get());
    return snapshot.docs.isNotEmpty;
  }
  
  Future<void> purchase(mem.User user) async{
    user.hasPurchased = true;
    await _firestore.collection('users').doc(user.uid).update(user.toJson());
  }

}
