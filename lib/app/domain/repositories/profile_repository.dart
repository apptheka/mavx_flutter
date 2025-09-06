import 'package:mavx_flutter/app/data/models/complete_profile_model.dart';
import 'package:mavx_flutter/app/data/models/user_registered_model.dart';

abstract class ProfileRepository {
  Future<UserProfile> getProfile();
  Future<UserRegisteredModel> getRegisteredProfile();
  Future<UserProfile> updatePreferences(Map<String, dynamic> preferences);
  Future<UserProfile> updateExperience(Map<String, dynamic> experience);
  Future<UserProfile> updateEducation(Map<String, dynamic> education);
  Future<UserProfile> updateAboutMe(String description);
  Future<UserProfile> updateLanguages(Map<String, dynamic> languages);
  Future<UserProfile> updateOnlineProfiles(Map<String, dynamic> onlineProfiles);
  Future<UserProfile> updateBasicDetails(Map<String, dynamic> basicDetails);
  Future<UserProfile> updateSkills(Map<String, dynamic> skills);
  

}