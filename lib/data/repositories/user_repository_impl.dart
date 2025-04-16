import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/data/providers/firestore_provider.dart';
import 'package:flutter_app/domain/entities/user.dart';
import 'package:flutter_app/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {

  final FirestoreProvider _firestoreProvider;

  UserRepositoryImpl(this._firestoreProvider);

  @override
  Stream<User> getStreamAppUser(String userId) async* {
    if (userId.isEmpty) yield* const Stream.empty();
    try {
      Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser = _firestoreProvider.getStreamUser(userId);
      yield* streamUser.map((DocumentSnapshot<Map<String, dynamic>> snapshot) => User.fromDocumentSnapshot(snapshot));
    } catch (e) {
      yield* Stream.error(e);
    }
  }

  @override
  Future<User> getAppUser(String userId) async {
    if (userId.isNotEmpty) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestoreProvider.getUser(userId);
      return User.fromDocumentSnapshot(snapshot);
    }
    return User(uid: '', email: '', name: '', hasPurchased: false, createdAt: Timestamp.now(), updatedAt: Timestamp.now());
  }

  @override
  Future<bool> existUser(String userId) async {
    return await _firestoreProvider.existUser(userId);
  }

  @override
  Future<void> updateAvatarAppUser(String uid, String avatar) async {
    await _firestoreProvider.updateAvatarUser(uid, avatar);
  }

  @override
  Future<void> updateAppUser(User user) async {
    await _firestoreProvider.updateAppUser(user);
  }

  @override
  Future<void> saveLanguage(String uid, String language) async {
    await _firestoreProvider.saveLanguage(uid, language);
  }
  
  @override
  Future<void> purchase(User user) async{
    await _firestoreProvider.purchase(user);
  }
  
  @override
  Future<void> createUser(User user) {
    return _firestoreProvider.createUser(user);
  }
  
  @override
  Future<bool> existUserWithEmail(String email) {
    return _firestoreProvider.existUserWithEmail(email);
  }
  
  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>> getStreamUser(String uid) {
    return _firestoreProvider.getStreamUser(uid);
  }
  
  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> getUser(String uid) {
    return _firestoreProvider.getUser(uid);
  }
  
  @override
  Future<void> updateAvatarUser(String uid, String photoUrl) {
    return _firestoreProvider.updateAvatarUser(uid, photoUrl);
  }
}