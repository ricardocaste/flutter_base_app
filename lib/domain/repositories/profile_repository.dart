import 'package:flutter_app/domain/entities/profile.dart';

abstract class ProfileRepository {
  Future<Profile> getProfile();
  Future<void> claimAchievement(String achievementId);
}