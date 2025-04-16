import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/domain/entities/user.dart' as app;

abstract class UserRepository {
  Stream<app.User> getStreamAppUser(String userId);
  Future<app.User> getAppUser(String userId);
  Future<bool> existUser(String userId);
  Future<void> updateAvatarAppUser(String uid, String avatar);
  Future<void> updateAppUser(app.User user);
  Future<void> saveLanguage(String uid, String language);
  Future<void> purchase(app.User user);
  Future<void> createUser(app.User user);
  Stream<DocumentSnapshot<Map<String, dynamic>>> getStreamUser(String uid);
  Future<DocumentSnapshot<Map<String, dynamic>>> getUser(String uid) ;
  Future<bool> existUserWithEmail(String email);
  Future<void> updateAvatarUser(String uid, String photoUrl);
}