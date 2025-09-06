import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:mavx_flutter/app/core/constants/app_constants.dart';
import 'package:mavx_flutter/app/core/services/extensions.dart';
import 'package:mavx_flutter/app/data/models/complete_profile_model.dart';
import 'package:mavx_flutter/app/data/models/user_registered_model.dart';
import 'package:mavx_flutter/app/data/providers/api_provider.dart';
import 'package:mavx_flutter/app/domain/repositories/auth_repository.dart';
import 'package:mavx_flutter/app/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ApiProvider apiProvider = Get.find<ApiProvider>();
  final AuthRepository authRepository = Get.find<AuthRepository>();

  @override
  Future<UserProfile> getProfile() async {
    try {
      final currentUser = await authRepository.getCurrentUser();
      final id = currentUser?.data.id;
      final response = await apiProvider.get("${AppConstants.profile}/$id");
      final decriptValue = jsonDecode(response.decrypt());
      UserProfile userProfile = UserProfile.fromJson(decriptValue);
      return userProfile;
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  @override
  Future<UserRegisteredModel> getRegisteredProfile() async {
    try {
      // Use the user-profile endpoint which returns the logged-in user's basic details
      final response = await apiProvider.get(AppConstants.user);
      final decriptValue = jsonDecode(response.decrypt());
      log('Decrypted Register ${decriptValue.toString()}');
      // Unwrap inner payload if the server returns an envelope
      final payload = (decriptValue is Map)
          ? (decriptValue['data']?['data'] ?? decriptValue['data'] ?? decriptValue)
          : decriptValue;
      UserRegisteredModel userRegisteredModel = UserRegisteredModel.fromJson(
        Map<String, dynamic>.from(payload as Map),
      );
      return userRegisteredModel;
    } catch (e) { 
      throw Exception('Registration failed: ${e.toString()}');
    }
  }
  
  @override
  Future<UserProfile> updateAboutMe(String description) async { 
    try{
      final request = {
        "description" : description,
      };
      final encriptValue = jsonEncode(request).encript();
      final response = await apiProvider.post(AppConstants.aboutMe, request: encriptValue); 
       final decriptValue = jsonDecode(response.decrypt());
      UserProfile userProfile = UserProfile.fromJson(decriptValue);
      return userProfile;
    }catch(e){
      throw Exception('Update About Me failed: ${e.toString()}');
    }
  }
  
  @override
  Future<UserProfile> updateBasicDetails(Map<String, dynamic> basicDetails) async {
    try{
      final currentUser = await authRepository.getCurrentUser();
      final id = currentUser?.data.id;
      // Map camelCase -> snake_case as required by API
      final request = {
        'user_id': id,
        'gender': basicDetails['gender'],
        // Support both keys per contracts: dob and date_of_birth
        'date_of_birth': basicDetails['date_of_birth'] ?? basicDetails['dateOfBirth'] ?? basicDetails['dob'],
        'dob': basicDetails['dob'] ?? basicDetails['date_of_birth'] ?? basicDetails['dateOfBirth'],
        'phone': basicDetails['phone'],
        'email': basicDetails['email'],
      }..removeWhere((k, v) => v == null || (v is String && v.isEmpty));

      // Some backends enforce a unique (user_id, email) on profile_basic_details
      // and treat this endpoint as create-only. If email equals the registered
      // user email, omit it to avoid a duplicate constraint violation.
      final registeredEmail = currentUser?.data.email;
      if (request['email'] != null && registeredEmail != null) {
        if (request['email'] == registeredEmail) {
          request.remove('email');
        }
      }
      
      final encriptValue = jsonEncode(request).encript();
      final response = await apiProvider.post(AppConstants.basicDetails, request: encriptValue); 
      final decriptValue = jsonDecode(response.decrypt());
      UserProfile userProfile = UserProfile.fromJson(decriptValue);
      return userProfile;
    }catch(e){
      throw Exception('Update Basic Details failed: ${e.toString()}');
    }
  }
  
  @override
  Future<UserProfile> updateEducation(Map<String, dynamic> education) async {
    try{
      final currentUser = await authRepository.getCurrentUser();
      final id = currentUser?.data.id;
      final request = {
        'user_id': id,
        'institution_name': education['institution_name'] ?? education['institutionName'],
        'degree': education['degree'],
        'start_date': education['start_date'] ?? education['startDate'],
        'end_date': education['end_date'] ?? education['endDate'],
        // Send boolean for is_current
        'is_current': (education['is_current'] ?? education['isCurrent']) == 1 || (education['is_current'] ?? education['isCurrent']) == true,
      }..removeWhere((k, v) => v == null || (v is String && v.isEmpty));
      final encriptValue = jsonEncode(request).encript();
      final response = await apiProvider.post(AppConstants.education, request: encriptValue); 
      final decriptValue = jsonDecode(response.decrypt());
      UserProfile userProfile = UserProfile.fromJson(decriptValue);
      return userProfile;
    }catch(e){
      throw Exception('Update Education failed: ${e.toString()}');
    }
  }
  
  @override
  Future<UserProfile> updateExperience(Map<String, dynamic> experience) async {
    try{
      final currentUser = await authRepository.getCurrentUser();
      final id = currentUser?.data.id;
      bool toBool(dynamic v) {
        if (v is bool) return v;
        if (v is num) return v != 0;
        if (v is String) return (v.toLowerCase() == 'true' || v == '1');
        return false;
      }
      final request = {
        'user_id': id,
        'company_name': experience['company_name'] ?? experience['companyName'],
        // Support both role and job_title keys
        'role': experience['role'] ?? experience['job_title'] ?? experience['jobTitle'],
        'job_title': experience['job_title'] ?? experience['role'] ?? experience['jobTitle'],
        // Note the API interface typo employement_type; send both keys
        'employment_type': experience['employment_type'] ?? experience['employmentType'],
        'employement_type': experience['employement_type'] ?? experience['employment_type'] ?? experience['employmentType'],
        'is_remote': toBool(experience['is_remote'] ?? experience['isRemote']),
        'start_date': experience['start_date'] ?? experience['startDate'],
        'end_date': experience['end_date'] ?? experience['endDate'],
        'is_current': toBool(experience['is_current'] ?? experience['isCurrent']),
        'description': experience['description'],
      }..removeWhere((k, v) => v == null || (v is String && v.isEmpty));
      final encriptValue = jsonEncode(request).encript();
      final response = await apiProvider.post(AppConstants.experience, request: encriptValue); 
      final decriptValue = jsonDecode(response.decrypt());
      UserProfile userProfile = UserProfile.fromJson(decriptValue);
      return userProfile;
    }catch(e){
      throw Exception('Update Experience failed: ${e.toString()}');
    }
  }
  
  @override
  Future<UserProfile> updateLanguages(Map<String, dynamic> languages) async {
    try{
      // Ensure payload matches backend contract: snake_case + user_id + 0/1 flags
      final currentUser = await authRepository.getCurrentUser();
      final id = currentUser?.data.id;
      bool toBool(dynamic v) {
        if (v is bool) return v;
        if (v is num) return v != 0;
        if (v is String) return (v.toLowerCase() == 'true' || v == '1');
        return false;
      }

      String prof(dynamic v) {
        final s = (v ?? '').toString();
        if (s.isEmpty) return '';
        return s.toLowerCase();
      }
      final request = {
        'user_id': id,
        'language_name': languages['language_name'] ?? languages['languageName'],
        'proficiency_level': prof(languages['proficiency_level'] ?? languages['proficiencyLevel']),
        'can_read': toBool(languages['can_read'] ?? languages['canRead']),
        'can_write': toBool(languages['can_write'] ?? languages['canWrite']),
        'can_speak': toBool(languages['can_speak'] ?? languages['canSpeak']),
      };

      final encriptValue = jsonEncode(request).encript();
      final response = await apiProvider.post(AppConstants.languages, request: encriptValue);
      final decriptValue = jsonDecode(response.decrypt());
      UserProfile userProfile = UserProfile.fromJson(decriptValue);
      return userProfile;
    }catch(e){
      throw Exception('Update Languages failed: ${e.toString()}');
    }
  }
  
  @override
  Future<UserProfile> updateOnlineProfiles(Map<String, dynamic> onlineProfiles) async {
    try{
      final currentUser = await authRepository.getCurrentUser();
      final id = currentUser?.data.id;
      final request = {
        'user_id': id,
        'platform_type': onlineProfiles['platform_type'] ?? onlineProfiles['platformType'],
        'profile_url': onlineProfiles['profile_url'] ?? onlineProfiles['profileUrl'],
      }..removeWhere((k, v) => v == null || (v is String && v.isEmpty));
      final encriptValue = jsonEncode(request).encript();
      final response = await apiProvider.post(AppConstants.onlineProfiles, request: encriptValue); 
      final decriptValue = jsonDecode(response.decrypt());
      UserProfile userProfile = UserProfile.fromJson(decriptValue);
      return userProfile;
    }catch(e){
      throw Exception('Update Online Profiles failed: ${e.toString()}');
    }
  }
  
  @override
  Future<UserProfile> updatePreferences(Map<String, dynamic> preferences) async {
    try{
      final currentUser = await authRepository.getCurrentUser();
      final id = currentUser?.data.id;
      num? toNum(dynamic v) {
        if (v == null) return null;
        if (v is num) return v;
        if (v is String) {
          return num.tryParse(v);
        }
        return null;
      }
      int? toInt(dynamic v) {
        final n = toNum(v);
        return n?.toInt();
      }
      String? normalizeBudgetPeriod(dynamic v) {
        final s = (v ?? '').toString().toLowerCase().trim();
        if (s.contains('hour')) return 'hour';
        if (s.contains('day')) return 'day';
        if (s.contains('week')) return 'week';
        if (s.contains('month')) return 'month';
        if (s.contains('project')) return 'project';
        return s.isEmpty ? null : s;
      }
      String? normalizeAvailabilityType(dynamic v) {
        final s = (v ?? '').toString().toLowerCase().trim();
        if (s.contains('immediate')) return 'immediate';
        if (s.contains('week')) return 'week';
        if (s.contains('month')) return 'month';
        if (s.contains('flex')) return 'flexible';
        return s.isEmpty ? null : s;
      }
      String? normalizeDurationType(dynamic v) {
        final s = (v ?? '').toString().toLowerCase().trim();
        if (s.contains('short')) return 'short_term';
        if (s.contains('medium')) return 'medium_term';
        if (s.contains('long')) return 'long_term';
        if (s.contains('ongoing')) return 'ongoing';
        return s.isEmpty ? null : s;
      }
      String? normalizeWorkType(dynamic v) {
        final s = (v ?? '').toString().toLowerCase().trim();
        if (s.contains('remote')) return 'remote';
        if (s.contains('on') && s.contains('site')) return 'onsite';
        if (s.contains('hybrid')) return 'hybrid';
        if (s.contains('full') && s.contains('time')) return 'full time';
        if (s.contains('contract')) return 'contract';
        if (s.contains('recruit')) return 'recruitment';
        return s.isEmpty ? null : s;
      }
      final request = {
        'user_id': id,
        'looking_for': preferences['looking_for'] ?? preferences['lookingFor'],
        'preferred_budget': toNum(preferences['preferred_budget'] ?? preferences['preferredBudget']),
        'budget_currency': preferences['budget_currency'] ?? preferences['budgetCurrency'],
        'budget_period': normalizeBudgetPeriod(preferences['budget_period'] ?? preferences['budgetPeriod']),
        'availability_hours_per_week': toInt(preferences['availability_hours_per_week'] ?? preferences['availabilityHoursPerWeek']),
        'availability_type': normalizeAvailabilityType(preferences['availability_type'] ?? preferences['availabilityType']),
        'preferred_duration_min': toInt(preferences['preferred_duration_min'] ?? preferences['preferredDurationMin']),
        'preferred_duration_max': toInt(preferences['preferred_duration_max'] ?? preferences['preferredDurationMax']),
        'preferred_duration_type': normalizeDurationType(preferences['preferred_duration_type'] ?? preferences['preferredDurationType']),
        'work_type': normalizeWorkType(preferences['work_type'] ?? preferences['workType']),
      }..removeWhere((k, v) => v == null || (v is String && v.isEmpty));
      final encriptValue = jsonEncode(request).encript();
      final response = await apiProvider.post(AppConstants.preferences, request: encriptValue); 
      final decriptValue = jsonDecode(response.decrypt());
      UserProfile userProfile = UserProfile.fromJson(decriptValue);
      return userProfile;
    }catch(e){
      throw Exception('Update Preferences failed: ${e.toString()}');
    }
  }
  
  @override
  Future<UserProfile> updateSkills(Map<String, dynamic> skills) async {
    try{
      final currentUser = await authRepository.getCurrentUser();
      final id = currentUser?.data.id;
      final request = {
        'user_id': id,
        'skill_category': skills['skill_category'] ?? skills['skillCategory'],
        // Support both single and bulk skill payloads
        'skill_name': skills['skill_name'] ?? skills['skillName'],
        'skills': skills['skills'],
      }..removeWhere((k, v) => v == null || (v is String && v.isEmpty));
      final encriptValue = jsonEncode(request).encript();
      final response = await apiProvider.post(AppConstants.skills, request: encriptValue); 
      final decriptValue = jsonDecode(response.decrypt());
      UserProfile userProfile = UserProfile.fromJson(decriptValue);
      return userProfile;
    }catch(e){
      throw Exception('Update Skills failed: ${e.toString()}');
    }
  }

}
