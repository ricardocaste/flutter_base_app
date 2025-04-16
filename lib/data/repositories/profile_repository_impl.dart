import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/data/datasources/profile_remote_datasource.dart';
import 'package:flutter_app/domain/entities/profile.dart';
import 'package:flutter_app/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<Profile> getProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Usuario no autenticado');
    }
    return _remoteDataSource.getProfile(user.uid);
  }


  @override
  Future<void> claimAchievement(String achievementId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Usuario no autenticado');
    }
    await _remoteDataSource.claimAchievement(user.uid, achievementId);
  }
}