import 'package:mavx_flutter/app/data/models/complete_profile_model.dart';
import 'package:mavx_flutter/app/data/models/user_registered_model.dart';
import 'package:mavx_flutter/app/domain/repositories/profile_repository.dart';

class ProfileUseCase {
    final ProfileRepository profileRepository;
    ProfileUseCase(this.profileRepository);

    Future<UserProfile> getProfile() async {
      return await profileRepository.getProfile();
    }
    Future<UserRegisteredModel> getRegisteredProfile() async {
      return await profileRepository.getRegisteredProfile();
    }

}