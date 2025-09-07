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

  Future<UserProfile> updatePreferences(Map<String, dynamic> preferences) async {
    return await profileRepository.updatePreferences(preferences);
  }

  Future<UserProfile> updateExperience(Map<String, dynamic> experience) async {
    return await profileRepository.updateExperience(experience);
  }

  Future<UserProfile> updateEducation(Map<String, dynamic> education) async {
    return await profileRepository.updateEducation(education);
  }

  Future<UserProfile> updateAboutMe(String description) async {
    return await profileRepository.updateAboutMe(description);
  }

  Future<UserProfile> updateLanguages(Map<String, dynamic> languages) async {
    return await profileRepository.updateLanguages(languages);
  }

  Future<UserProfile> updateOnlineProfiles(Map<String, dynamic> onlineProfiles) async {
    return await profileRepository.updateOnlineProfiles(onlineProfiles);
  }

  Future<UserProfile> updateBasicDetails(Map<String, dynamic> basicDetails) async {
    return await profileRepository.updateBasicDetails(basicDetails);
  }

  Future<UserProfile> updateSkills(Map<String, dynamic> skills) async {
    return await profileRepository.updateSkills(skills);
  }

  // Deletions
  Future<UserProfile> deleteExperience(int id) async {
    return await profileRepository.deleteExperience(id);
  }

  Future<UserProfile> deleteEducation(int id) async {
    return await profileRepository.deleteEducation(id);
  }

  Future<UserProfile> deleteLanguage(int id) async {
    return await profileRepository.deleteLanguage(id);
  }

  Future<UserProfile> deleteOnlineProfile(int id) async {
    return await profileRepository.deleteOnlineProfile(id);
  }
}
