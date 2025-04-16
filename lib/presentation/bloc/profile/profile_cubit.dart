import 'package:flutter_app/domain/entities/profile.dart';
import 'package:flutter_app/domain/repositories/profile_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this.profileRepository) : super(ProfileInitial());

  final ProfileRepository profileRepository;

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    try {
      final profile = await profileRepository.getProfile();
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError('Error loading profile: $e'));
    }
  }

  Future<void> claimAchievement(String achievementId) async {
    try {
      emit(ProfileLoading());
      await profileRepository.claimAchievement(achievementId);
      final profile = await profileRepository.getProfile();
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError('Error claiming achievement: $e'));
    }
  }
}
