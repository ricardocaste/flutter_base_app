import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_app/domain/repositories/authentication_repository.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {

  late final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthenticationRepositoryImpl() {
      _firebaseAuth = FirebaseAuth.instance;
  }

  @override
  Stream<User?> get user => _firebaseAuth.authStateChanges();

  @override
  Future<UserCredential?> createUserWithEmailAndPassword({required String email, required String password}) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    } catch (e) {
      throw Exception('Error creating user: $e');
    }
  }

  @override
  Future<UserCredential?> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      return await _firebaseAuth.signInWithCredential(oauthCredential);
    } catch (e) {
      throw Exception('Error signing in with Apple: $e');
    }
  }

  @override
  Future<UserCredential?> signInWithEmailAndPassword({required String email, required String password})  async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {

      throw FirebaseAuthException(code: e.code, message: e.message);
    } catch (e) {
      throw Exception('Error signing in with email and password: $e');
    }
  }

  @override
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      throw Exception('Error signing in with Google: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();  
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Error signing out: $e');
    }
  }

  @override
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }
}