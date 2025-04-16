import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/domain/entities/profile.dart';

class ProfileRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Profile> getProfile(String userId) async {

    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final profileDoc = await _firestore.collection('profiles').doc(userId).get();

      if (!profileDoc.exists || !userDoc.exists) {
        throw Exception('Perfil no encontrado');
      }

      return Profile(
        name: userDoc.get('displayName') ?? '',
        email: userDoc.get('email') ?? '',
        ranking: profileDoc.get('ranking') ?? '0%',
        studyStreak: profileDoc.get('studyStreak') ?? 0,
        challengesInProgress: profileDoc.get('challengesInProgress') ?? 0,

        achievements: (profileDoc.get('achievements') as List?)
            ?.map((achievementJson) => Achievement(
          name: achievementJson['name'],
          level: achievementJson['level'],
        ))
            .toList().cast<Achievement>() ?? [],
      );
    } catch (e) {
      throw Exception('Error al obtener el perfil: $e');
    }
  }

  Future<void> claimAchievement(String userId, String achievementId) async {
    try {
      final profileDocRef = _firestore.collection('profiles').doc(userId);
      await profileDocRef.update({
        'achievements': FieldValue.arrayUnion([
          {'name': achievementId, 'claimed': true}
        ])
      });
    } catch (e) {
      throw Exception('Error claiming achievement: $e');
    }
  }
}