// profile_repository_impl.dart
import 'dart:convert';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/core/constants/app_constants.dart';
import 'package:mavx_flutter/app/core/services/extensions.dart';
import 'package:mavx_flutter/app/data/models/complete_profile_model.dart';
import 'package:mavx_flutter/app/data/models/user_registered_model.dart';
import 'package:mavx_flutter/app/data/providers/api_provider.dart';
import 'package:mavx_flutter/app/domain/repositories/auth_repository.dart';
import 'package:mavx_flutter/app/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final apiProvider = Get.find<ApiProvider>();
  final authRepository = Get.find<AuthRepository>();

  Future<String?> _currentUserId() async =>
      (await authRepository.getCurrentUser())?.data.id.toString(); 

  Future<Map<String, dynamic>> _decode(String encrypted) async =>
      jsonDecode(encrypted.decrypt());

  Future<UserProfile> _postProfile(String path, Map<String, dynamic> data) async {
    final encrypted = jsonEncode(data..removeWhere((k, v) => v == null || (v is String && v.isEmpty))).encript();
    return UserProfile.fromJson(await _decode(await apiProvider.post(path, request: encrypted)));
  }

  @override
  Future<UserProfile> getProfile() async {
    final id = await _currentUserId();
    return UserProfile.fromJson(await _decode(await apiProvider.get("${AppConstants.profile}/$id")));
  }

  @override
  Future<UserRegisteredModel> getRegisteredProfile() async {
    final decoded = await _decode(await apiProvider.get(AppConstants.user));
    final payload = (decoded is Map)
        ? (decoded['data']?['data'] ?? decoded['data'] ?? decoded)
        : decoded;
    return UserRegisteredModel.fromJson(Map<String, dynamic>.from(payload as Map));
  }

  @override
  Future<UserProfile> updateAboutMe(String description) async =>
      _postProfile(AppConstants.aboutMe, {
        'user_id': await _currentUserId(),
        'description': description,
      });

  @override
  Future<UserProfile> updateBasicDetails(Map<String, dynamic> details) async {
    final user = await authRepository.getCurrentUser();
    final email = user?.data.email;
    String? normGender(dynamic v) {
      if (v == null) return null;
      final s = v.toString().toLowerCase().trim();
      if (['male', 'female', 'other'].contains(s)) return s;
      return s;
    }

    String? ymd(dynamic v) {
      if (v == null) return null;
      final s = v.toString().trim();
      // If already looks like YYYY-MM-DD, pass through
      final rx = RegExp(r'^\d{4}-\d{2}-\d{2}$');
      if (rx.hasMatch(s)) return s;
      // Try DateTime.parse fallback
      try {
        final d = DateTime.parse(s);
        String two(int n) => n.toString().padLeft(2, '0');
        return '${d.year}-${two(d.month)}-${two(d.day)}';
      } catch (_) {
        return s; // leave as-is
      }
    }

    final data = {
      'user_id': user?.data.id,
      'id': details['id'],
      'gender': normGender(details['gender']),
      'date_of_birth': ymd(details['date_of_birth'] ?? details['dateOfBirth'] ?? details['dob']),
      'dob': ymd(details['dob'] ?? details['date_of_birth'] ?? details['dateOfBirth']),
      'phone': (details['phone'] ?? '').toString().trim(),
      // Always send email; backend validation requires it. Use provided or fallback to registered.
      'email': (details['email'] ?? email)?.toString().trim(),
    };
    return _postProfile(AppConstants.basicDetails, data);
  }

  @override
  Future<UserProfile> updateEducation(Map<String, dynamic> education) async =>
      _postProfile(AppConstants.education, {
        'user_id': await _currentUserId(),
        'id': education['id'],
        'institution_name': education['institution_name'] ?? education['institutionName'],
        'degree': education['degree'],
        'start_date': education['start_date'] ?? education['startDate'],
        'end_date': education['end_date'] ?? education['endDate'],
        'is_current': (education['is_current'] ?? education['isCurrent']) == true || (education['is_current'] ?? education['isCurrent']) == 1,
      });

  @override
  Future<UserProfile> updateExperience(Map<String, dynamic> exp) async {
    // Helpers
    String? normEmployment(dynamic v) {
      final s = (v ?? '').toString().toLowerCase().trim();
      if (s.contains('full')) return 'full_time';
      if (s.contains('part')) return 'part_time';
      if (s.contains('contract')) return 'contract';
      if (s.contains('intern')) return 'internship';
      return s.isEmpty ? null : s; // fallback
    }

    int to01(dynamic v) {
      if (v is bool) return v ? 1 : 0;
      if (v is num) return v != 0 ? 1 : 0;
      if (v is String) {
        final t = v.toLowerCase().trim();
        return (t == 'true' || t == '1') ? 1 : 0;
      }
      return 0;
    }

    String? trimStr(dynamic v) {
      final s = v?.toString().trim();
      return (s == null || s.isEmpty) ? null : s;
    }

    final uid = await _currentUserId();
    final payload = <String, dynamic>{
      'user_id': uid,
      'id': exp['id'],
      'company_name': trimStr(exp['company_name'] ?? exp['companyName']),
      'role': trimStr(exp['role'] ?? exp['job_title'] ?? exp['jobTitle']),
      'job_title': trimStr(exp['job_title'] ?? exp['role'] ?? exp['jobTitle']),
      'employment_type': normEmployment(exp['employment_type'] ?? exp['employmentType']),
      // mirror misspelled key too (some backends expect it)
      'employement_type': normEmployment(exp['employement_type'] ?? exp['employment_type'] ?? exp['employmentType']),
      'is_remote': to01(exp['is_remote'] ?? exp['isRemote']),
      'start_date': trimStr(exp['start_date'] ?? exp['startDate']),
      'end_date': trimStr(exp['end_date'] ?? exp['endDate']),
      'is_current': to01(exp['is_current'] ?? exp['isCurrent']),
      'description': trimStr(exp['description']),
    }..removeWhere((k, v) => v == null || (v is String && v.isEmpty));

    return _postProfile(AppConstants.experience, payload);
  }

  @override
  Future<UserProfile> updateLanguages(Map<String, dynamic> lang) async =>
      _postProfile(AppConstants.languages, {
        'user_id': await _currentUserId(),
        'id': lang['id'],
        'language_name': lang['language_name'] ?? lang['languageName'],
        'proficiency_level': (lang['proficiency_level'] ?? lang['proficiencyLevel'])?.toString().toLowerCase(),
        'can_read': lang['can_read'] ?? lang['canRead'],
        'can_write': lang['can_write'] ?? lang['canWrite'],
        'can_speak': lang['can_speak'] ?? lang['canSpeak'],
      });

  @override
  Future<UserProfile> updateOnlineProfiles(Map<String, dynamic> online) async =>
      _postProfile(AppConstants.onlineProfiles, {
        'user_id': await _currentUserId(),
        'id': online['id'],
        'platform_type': online['platform_type'] ?? online['platformType'],
        'profile_url': online['profile_url'] ?? online['profileUrl'],
      });

  @override
  Future<UserProfile> updatePreferences(Map<String, dynamic> pref) async =>
      _postProfile(AppConstants.preferences, {
        'user_id': await _currentUserId(),
        ...pref,
      });

  @override
  Future<UserProfile> updateSkills(Map<String, dynamic> skills) async =>
      _postProfile(AppConstants.skills, {
        'user_id': await _currentUserId(),
        'id': skills['id'],
        'skill_category': skills['skill_category'] ?? skills['skillCategory'],
        'skill_name': skills['skill_name'] ?? skills['skillName'],
        'skills': skills['skills'],
      });

   
  @override
  Future<UserProfile> deleteExperience(int id) async {
    try{
      final res = await apiProvider.delete("${AppConstants.experience}/$id");
      return UserProfile.fromJson(await _decode(res.data));
    }catch(e){
      return UserProfile();
    }
  }

  @override
  Future<UserProfile> deleteEducation(int id) async { 
    try{
      final res = await apiProvider.delete("${AppConstants.education}/$id");
      return UserProfile.fromJson(await _decode(res.data));
    }catch(e){
      return UserProfile();
    }
  }

  @override
  Future<UserProfile> deleteLanguage(int id) async { 
    try{
      final res = await apiProvider.delete("${AppConstants.languages}/$id");
      return UserProfile.fromJson(await _decode(res.data));
    }catch(e){
      return UserProfile();
    }
  }

  @override
  Future<UserProfile> deleteOnlineProfile(int id) async { 
    try{
      final res = await apiProvider.delete("${AppConstants.onlineProfiles}/$id");
      return UserProfile.fromJson(await _decode(res.data));
    }catch(e){
      return UserProfile();
    }
  } 
}
