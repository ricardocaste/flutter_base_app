import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String? email;
  final String? name;
  late String? avatar;
  late String? token;
  late String language;
  late Timestamp? createdAt;
  late Timestamp? updatedAt;
  late bool hasPurchased = false;

  User({required this.uid, required this.email, required this.name, required this.hasPurchased, required this.createdAt, required this.updatedAt});

  User.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : uid = snapshot.id,
        name = snapshot.data()?['name'] ?? '',
        createdAt = snapshot.data()?['createdAt'] ?? Timestamp.now(),
        updatedAt = snapshot.data()?['updatedAt'] ?? Timestamp.now(),
        email = snapshot.data()?['email'] ?? '',
        language = snapshot.data()?['language'] ?? 'en',
        avatar = snapshot.data()?['avatar'] ?? '',
        token = snapshot.data()?['token'] ?? '',
        hasPurchased = snapshot.data()?['hasPurchased'] ?? false;

  factory User.fromJson(Map<String, dynamic> json) {
      return User(
        uid: json['uid'] ?? '',
        email: json['email'] ?? '',
        name: json['name'] ?? '',
        hasPurchased:  json['hasPurchased'] ?? false,
        createdAt: json['createdAt'] ?? Timestamp.now(),
        updatedAt: json['updatedAt'] ?? Timestamp.now(),
      );
    }

  Map<String, dynamic> toJson() =>
      {
        'uid': uid,
        'email': email,
        'name': name,
        'token': token,
        'hasPurchased': hasPurchased,
        'createdAt': createdAt,
        'updatedAt': updatedAt, 
      };
}