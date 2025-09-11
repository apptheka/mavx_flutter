import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/data/models/complete_profile_model.dart';
import 'package:mavx_flutter/app/data/models/user_registered_model.dart';
import 'package:mavx_flutter/app/domain/usecases/profile_usecases.dart';
import 'package:mavx_flutter/app/core/services/storage_service.dart';
import 'package:mavx_flutter/app/presentation/widgets/snackbar.dart';

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
  bool _profileCompleteNotified = false; // persisted flag

  @override
  void onInit() {
    super.onInit();
    // Load persisted flag so popup is shown only once ever
    try {
      final storage = Get.find<StorageService>();
      _profileCompleteNotified =
          storage.prefs.getBool('profile_complete_notified') ?? false;
    } catch (_) {
      _profileCompleteNotified = false;
    }
    fetchProfile();
    fetchRegisteredProfile();
  }

  Future<void> fetchProfile() async {
    loading.value = true;
    error.value = '';
    try {
      final response = await profileUseCase.getProfile();
      aboutMeList.value = response.aboutMe ?? AboutMe();
      experienceList.value = RxList<Experience>(response.experience ?? []);
      educationList.value = RxList<Education>(response.education ?? []);
      skillList.value = RxList<Skill>(response.skills ?? []);
      languageList.value = RxList<Language>(response.languages ?? []);
      onlineProfileList.value = RxList<OnlineProfile>(
        response.onlineProfiles ?? [],
      );
      basicDetailsList.value = response.basicDetails ?? BasicDetails();
      preferences.value = response.preferences ?? Preferences();
      _recalculateCompletion();
    } catch (_) {
      error.value = 'Failed to load profile';
    } finally {
      loading.value = false;
    }
  }

  Future<void> fetchRegisteredProfile() async {
    // Do not toggle the global loading/error flags here to avoid
    // masking the main profile load state on the page.
    try {
      final response = await profileUseCase.getRegisteredProfile();
      log("response========> ${response.toString()}");
      registeredProfile.value = response;
    } catch (e) {
      log("error========> ${e.toString()}");
      // Keep UI visible even if registered profile fetch fails.
      // Avoid setting the shared error flag here.
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
        (pref.preferredBudget != null &&
            pref.preferredBudget!.trim().isNotEmpty) ||
        (pref.workType != null && pref.workType!.trim().isNotEmpty) ||
        (pref.availabilityType != null &&
            pref.availabilityType!.trim().isNotEmpty) ||
        (pref.preferredDurationType != null &&
            pref.preferredDurationType!.trim().isNotEmpty)) {
      completionScore += wPreferences;
    }

    if (completionScore > 100) completionScore = 100;
    profileCompletion.value = completionScore;

    // Show a one-time popup when profile reaches 100% (persisted across restarts)
    if (completionScore == 100 && !_profileCompleteNotified) {
      _profileCompleteNotified = true;
      // Persist flag
      try {
        final storage = Get.find<StorageService>();
        storage.prefs.setBool('profile_complete_notified', true);
      } catch (_) {}
      Future.delayed(const Duration(milliseconds: 600), () {
        if (Get.isOverlaysOpen == false) {
          Get.dialog(
            AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text('Profile Complete!'),
              content: const Text(
                'Your profile is complete. Great job!\n\nThis will improve your chances of being discovered for future jobs.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('OK'),
                ),
              ],
            ),
            barrierDismissible: true,
          );
        }
      });
    } else {
      // no-op
    }
  }

  Future<void> updateProfile() async {
    loading.value = true;
    error.value = '';
    try {
      final response = await profileUseCase.getProfile();
      aboutMeList.value = response.aboutMe ?? AboutMe();
      experienceList.value = RxList<Experience>(response.experience ?? []);
      educationList.value = RxList<Education>(response.education ?? []);
      skillList.value = RxList<Skill>(response.skills ?? []);
      languageList.value = RxList<Language>(response.languages ?? []);
      onlineProfileList.value = RxList<OnlineProfile>(
        response.onlineProfiles ?? [],
      );
      basicDetailsList.value = response.basicDetails ?? BasicDetails();
      preferences.value = response.preferences ?? Preferences();
      _recalculateCompletion();
    } catch (_) {
      error.value = 'Failed to load profile';
    } finally {
      loading.value = false;
    }
  }

  // ===== Update helpers (thin wrappers over usecases) =====
  Future<void> saveAboutMe(String description) async {
    try {
      loading.value = true;
      await profileUseCase.updateAboutMe({
        'id': aboutMeList.value.id,
        'description': description,
      });
      await updateProfile();
      showSnackBar(
        title: 'Updated',
        message: 'About Me updated',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      showSnackBar(
        title: 'Error',
        message: 'Failed to update About Me',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      loading.value = false;
    }
  }

  Future<void> savePreferences({
    required String lookingFor,
    required String preferredBudget,
    required String budgetCurrency,
    required String budgetPeriod,
    required int availabilityHoursPerWeek,
    required String availabilityType,
    required int preferredDurationMin,
    required int preferredDurationMax,
    required String preferredDurationType,
    required String workType,
  }) async {
    try {
      loading.value = true;
      final payload = {
        // ensure we update the same preferences row
        'id': preferences.value.id,
        'looking_for': lookingFor,
        'preferred_budget': preferredBudget,
        'budget_currency': budgetCurrency,
        'budget_period': budgetPeriod,
        'availability_hours_per_week': availabilityHoursPerWeek,
        'availability_type': availabilityType,
        'preferred_duration_min': preferredDurationMin,
        'preferred_duration_max': preferredDurationMax,
        'preferred_duration_type': preferredDurationType,
        'work_type': workType.toLowerCase(),
      };
      await profileUseCase.updatePreferences(payload);
      await updateProfile();
      Get.back();
      showSnackBar(
        title: 'Updated',
        message: 'Preferences saved',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      showSnackBar(
        title: 'Error',
        message: 'Failed to update preferences',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      loading.value = false;
    }
  }

  // The methods below are kept for completeness and future dialogs
  Future<void> saveBasicDetails(Map<String, dynamic> basicDetails) async {
    try {
      loading.value = true;
      await profileUseCase.updateBasicDetails(basicDetails);
      await updateProfile();
      Get.back();
      showSnackBar(
        title: 'Updated',
        message: 'Basic details saved',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (_) {
      showSnackBar(
        title: 'Error',
        message: 'Failed to update basic details',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      loading.value = false;
    }
  }

  Future<void> saveEducation(Map<String, dynamic> education) async {
    try {
      loading.value = true;
      await profileUseCase.updateEducation(education);
      await updateProfile();
      Get.back();
      showSnackBar(
        title: 'Updated',
        message: 'Education saved',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (_) {
      showSnackBar(
        title: 'Error',
        message: 'Failed to update education',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      loading.value = false;
    }
  }

  Future<void> saveExperience(Map<String, dynamic> experience) async {
    try {
      loading.value = true;
      await profileUseCase.updateExperience(experience);
      await updateProfile();
      Get.back();
      showSnackBar(
        title: 'Updated',
        message: 'Experience saved',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (_) {
      showSnackBar(
        title: 'Error',
        message: 'Failed to update experience',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      loading.value = false;
    }
  }

  Future<void> saveLanguages(Map<String, dynamic> languages) async {
    try {
      loading.value = true;
      await profileUseCase.updateLanguages(languages);
      await updateProfile();
      Get.back();
      showSnackBar(
        title: 'Updated',
        message: 'Languages saved',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (_) {
      showSnackBar(
        title: 'Error',
        message: 'Failed to update languages',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      loading.value = false;
    }
  }

  // Validates that the URL matches the expected domain for the given platform
  bool _isValidPlatformUrl({
    required String platformType,
    required String url,
  }) {
    final trimmed = url.trim();
    final uri = Uri.tryParse(trimmed);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) return false;
    if (!(uri.scheme == 'http' || uri.scheme == 'https')) return false;

    final host = uri.host.toLowerCase();
    final p = platformType.toLowerCase();

    if (p.contains('github')) {
      return host.endsWith('github.com');
    } else if (p.contains('linkedin')) {
      // Accept linkedin.com and shortener lnkd.in
      return host.endsWith('linkedin.com') || host.endsWith('lnkd.in');
    } else if (p.contains('behance') || p.contains('be')) {
      return host.endsWith('behance.net');
    } else if (p.contains('website') ||
        p.contains('web') ||
        p.contains('other')) {
      // Allow any domain for generic website/other
      return true;
    }
    // Default allow
    return true;
  }

  Future<void> saveOnlineProfiles(Map<String, dynamic> onlineProfiles) async {
    final url =
        (onlineProfiles['profile_url'] ?? onlineProfiles['profileUrl'])
            as String?;
    final platform =
        (onlineProfiles['platform_type'] ??
                onlineProfiles['platformType'] ??
                '')
            .toString();
    if (url == null || !_isValidPlatformUrl(platformType: platform, url: url)) {
      final p = platform.toLowerCase();
      String domainHint = 'a valid URL';
      if (p.contains('github')) {
        domainHint = 'a GitHub URL (e.g., https://github.com/username)';
      } else if (p.contains('linkedin'))
        // ignore: curly_braces_in_flow_control_structures
        domainHint =
            'a LinkedIn URL (e.g., https://www.linkedin.com/in/username or https://lnkd.in/...)';
      else if (p.contains('behance') || p.contains('be'))
        // ignore: curly_braces_in_flow_control_structures
        domainHint = 'a Behance URL (e.g., https://www.behance.net/username)';

      showSnackBar(
        title: 'Invalid URL',
        message: 'Please enter $domainHint',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      loading.value = true;
      await profileUseCase.updateOnlineProfiles(onlineProfiles);
      await updateProfile();
      Get.back();
      showSnackBar(
        title: 'Updated',
        message: 'Online profiles saved',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (_) {
      showSnackBar(
        title: 'Error',
        message: 'Failed to update online profiles',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      loading.value = false;
    }
  }

  Future<void> saveSkills(Map<String, dynamic> skills) async {
    try {
      loading.value = true;
      await profileUseCase.updateSkills(skills);
      await updateProfile();
      Get.back();
      showSnackBar(
        title: 'Updated',
        message: 'Skills saved',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (_) {
      showSnackBar(
        title: 'Error',
        message: 'Failed to update skills',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      loading.value = false;
    }
  }

  Future<void> deleteExperience(int id) async {
    try {
      loading.value = true;
      await profileUseCase.deleteExperience(id);
      await updateProfile();
      Get.back();
      showSnackBar(
        title: 'Deleted',
        message: 'Experience deleted',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (_) {
      showSnackBar(
        title: 'Error',
        message: 'Failed to delete experience',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      loading.value = false;
    }
  }

  Future<void> deleteEducation(int id) async {
    try {
      loading.value = true;
      await profileUseCase.deleteEducation(id);
      await updateProfile();
      Get.back();
      showSnackBar(
        title: 'Deleted',
        message: 'Education deleted',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (_) {
      showSnackBar(
        title: 'Error',
        message: 'Failed to delete education',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      loading.value = false;
    }
  }

  Future<void> deleteLanguage(int id) async {
    try {
      loading.value = true;
      await profileUseCase.deleteLanguage(id);
      await updateProfile();
      Get.back();
      showSnackBar(
        title: 'Deleted',
        message: 'Language deleted',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (_) {
      showSnackBar(
        title: 'Error',
        message: 'Failed to delete language',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      loading.value = false;
    }
  }

  Future<void> deleteOnlineProfile(int id) async {
    try {
      loading.value = true;
      await profileUseCase.deleteOnlineProfile(id);
      await updateProfile();
      Get.back();
      showSnackBar(
        title: 'Deleted',
        message: 'Online profile deleted',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (_) {
      showSnackBar(
        title: 'Error',
        message: 'Failed to delete online profile',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      loading.value = false;
    }
  }


}
