import 'dart:developer';

import 'package:get/get.dart';
import 'package:mavx_flutter/app/data/models/complete_profile_model.dart';
import 'package:mavx_flutter/app/data/models/user_registered_model.dart'; 
import 'package:mavx_flutter/app/domain/usecases/profile_usecases.dart';

class ProfileController extends GetxController {
  final ProfileUseCase profileUseCase = Get.find<ProfileUseCase>();  
  final Rx<AboutMe> aboutMeList = AboutMe().obs;
  final RxList<Experience> experienceList = RxList<Experience>();
  final RxList<Education> educationList = RxList<Education>();
  final RxList<Skill> skillList = RxList<Skill>();
  final RxList<Language> languageList = RxList<Language>();
  final RxList<OnlineProfile> onlineProfileList = RxList<OnlineProfile>();
  final Rx<BasicDetails> basicDetailsList = BasicDetails().obs;
  final Rx<Preferences> preferences = Preferences().obs;
  final Rx<UserRegisteredModel> registeredProfile = UserRegisteredModel().obs;
  final RxBool loading = false.obs;
  final RxString error = ''.obs;
  final RxInt profileCompletion = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
    fetchRegisteredProfile();
  }

  Future<void> fetchProfile() async {
    loading.value = true;
    error.value = '';
    try {
      final response = await profileUseCase.getProfile();
      aboutMeList.value = response.aboutMe!;
      experienceList.value = response.experience!;
      educationList.value = response.education!;
      skillList.value = response.skills!;
      languageList.value = response.languages!;
      onlineProfileList.value = response.onlineProfiles!;
      basicDetailsList.value = response.basicDetails!;
      if (response.preferences != null) {
        preferences.value = response.preferences!;
      }
      _recalculateCompletion();
    } catch (_) {
      error.value = 'Failed to load profile';
    } finally {
      loading.value = false;
    }
  }

  Future<void> fetchRegisteredProfile() async {
    loading.value = true;
    error.value = '';
    try {
      final response = await profileUseCase.getRegisteredProfile(); 
      log("response========> ${response.toString()}");
      registeredProfile.value = response;
    } catch (e) {
      log("error========> ${e.toString()}");
      error.value = 'Failed to load profile';
    } finally {
      loading.value = false;
    }
  }
 
  void _recalculateCompletion() {
    int completionScore = 10; // base score for registration data

    // Weights mirroring the web logic
    const int wBasicDetails = 5;
    const int wAboutMe = 20;
    const int wExperience = 20;
    const int wEducation = 20;
    const int wSkills = 5;
    const int wLanguages = 10;
    const int wOnlineProfiles = 5;
    const int wPreferences = 5;

    final bd = basicDetailsList.value;
    if ((bd.email != null && bd.email!.trim().isNotEmpty) ||
        (bd.phone != null && bd.phone!.trim().isNotEmpty) ||
        (bd.gender != null && bd.gender!.trim().isNotEmpty) ||
        (bd.dateOfBirth != null)) {
      completionScore += wBasicDetails;
    }

    final about = aboutMeList.value;
    if (about.description != null && about.description!.trim().isNotEmpty) {
      completionScore += wAboutMe;
    }

    if (experienceList.isNotEmpty) {
      completionScore += wExperience;
    }

    if (educationList.isNotEmpty) {
      completionScore += wEducation;
    }

    if (skillList.isNotEmpty) {
      completionScore += wSkills;
    }

    if (languageList.isNotEmpty) {
      completionScore += wLanguages;
    }

    if (onlineProfileList.isNotEmpty) {
      completionScore += wOnlineProfiles;
    }

    final pref = preferences.value;
    // If any preference fields present
    if ((pref.lookingFor != null && pref.lookingFor!.trim().isNotEmpty) ||
        (pref.preferredBudget != null && pref.preferredBudget!.trim().isNotEmpty) ||
        (pref.workType != null && pref.workType!.trim().isNotEmpty) ||
        (pref.availabilityType != null && pref.availabilityType!.trim().isNotEmpty) ||
        (pref.preferredDurationType != null && pref.preferredDurationType!.trim().isNotEmpty)) {
      completionScore += wPreferences;
    }

    if (completionScore > 100) completionScore = 100;
    profileCompletion.value = completionScore;
  }
  
}