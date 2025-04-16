import 'package:firebase_auth/firebase_auth.dart';

class FirestoreUtils<T, K> {
  FirestoreUtils._internal();

  static double loadDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.parse(value);
    return 0.0;
  }


  static Future<String?> getIdTokenFromFirestore() async {
    final tokenResult = FirebaseAuth.instance.currentUser;
    final idToken = await tokenResult?.getIdToken();
    return idToken;
  }
}
