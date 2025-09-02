import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:mavx_flutter/app/core/constants/app_constants.dart';
import 'package:mavx_flutter/app/core/services/extensions.dart';
import 'package:mavx_flutter/app/data/models/response.dart';
import 'package:mavx_flutter/app/data/models/user_model.dart';
import 'package:mavx_flutter/app/data/providers/api_provider.dart';
import 'package:mavx_flutter/app/domain/repositories/auth_repository.dart';
import 'package:mavx_flutter/app/core/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiProvider apiProvider = Get.find<ApiProvider>();

  @override
  Future<UserModel> login(String email, String password) async {
    try { 
      
      final payload = {"email": email, "password": password};
      log('login plaintext: ${jsonEncode(payload)}');

      // Encrypt request body
      final encrypted = jsonEncode(payload).encript();
      log('login encrypted payload: $encrypted');

      // Send to API (ApiProvider will wrap String as {request: <encrypted>})
      final respStr = await apiProvider.post(AppConstants.login, request: encrypted);
      log('login API raw response: $respStr');

      // Parse response: supports plaintext JSON or encrypted string
      UserModel parsed;
      try {
        parsed = UserModel.fromJson(jsonDecode(respStr));
        log('login parsed (plaintext): $parsed');
      } catch (_) {
        try {
          final decrypted = respStr.decrypt();
          parsed = UserModel.fromJson(jsonDecode(decrypted));
          log('login parsed (decrypted): ${parsed}');
        } catch (e, st) {
          log('login parse failed: $e', stackTrace: st);
          throw Exception('Login failed: unable to parse server response');
        }
      }

      // Success path
      print("parsed.status ${parsed.status}");
      if (parsed.status == 200) {
        try {
          final prefs = await SharedPreferences.getInstance();
          // Save token
          final token = parsed.token.toString();
          await prefs.setString(AppConstants.tokenKey, token);
          // Save user JSON
          await prefs.setString(AppConstants.userKey, jsonEncode(parsed.data));
          await prefs.setBool(AppConstants.isLoggedInKey, true);
          log('login persisted -> token: ${token != null && token.isNotEmpty}, user saved, flag set');
        } catch (e, st) {
          log('login persistence failed: $e', stackTrace: st);
        }

        return parsed;
      }

      throw Exception(parsed.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

    @override
  Future<CommonResponse> register(Map<String, dynamic> data) async {
    try {
      String request = data.toJsonRequest().encript();
      final res = await apiProvider.post(AppConstants.register, request: request);
      final decriptValue = jsonDecode(res.decrypt());
      log("Decrypted Register ${decriptValue.toString()}");
      return CommonResponse.fromJson(decriptValue);
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  @override
  Future<CommonResponse> requestOtp(String phone) {
    // TODO: implement requestOtp
    throw UnimplementedError();
  }

  @override
  Future<String> verifyOtp(String phoneNumber, String otp) {
    // TODO: implement verifyOtp
    throw UnimplementedError();
  }

  @override
  Future<void> logout() async {
    try { 

      // Clear all SharedPreferences data
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      print('Error during logout: $e');
      throw Exception('Logout failed: ${e.toString()}');
    }
  }


  @override
  Future<bool> isLoggedIn() async {
    final storage = Get.find<StorageService>();
    final prefs = storage.prefs;
    // Primary: token presence
    final token = prefs.getString(AppConstants.tokenKey);
    print("token $token");
    log('isLoggedIn(): token present? ${token != null && token.isNotEmpty}');
    if (token != null && token.isNotEmpty) return true;
    // Secondary: user object presence
    final userJson = prefs.getString(AppConstants.userKey);
    log(
      'isLoggedIn(): user present? ${userJson != null && userJson.isNotEmpty}',
    );
    if (userJson != null && userJson.isNotEmpty) return true;
    // Fallback flag
    final flag = prefs.getBool(AppConstants.isLoggedInKey) ?? false;
    log('isLoggedIn(): fallback flag = $flag');
    return flag;
  }

  @override
  Future<bool> checkAuthStatus() {
    // TODO: implement checkAuthStatus
    throw UnimplementedError();
  }

 @override
  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(AppConstants.userKey);
    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
    }
    return null;
  }
}
