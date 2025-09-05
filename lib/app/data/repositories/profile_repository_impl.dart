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

}
