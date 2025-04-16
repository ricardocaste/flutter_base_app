import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthenticationRepository {
  Future<UserCredential?> signInWithApple();
  Future<UserCredential?> signInWithGoogle();
  Future<UserCredential?> signInWithEmailAndPassword({required String email, required String password});
  Future<UserCredential?> createUserWithEmailAndPassword({required String email, required String password});
  Future<void> signOut();
  Stream<User?> get user; // Firebase User stream
  User? getCurrentUser();
}