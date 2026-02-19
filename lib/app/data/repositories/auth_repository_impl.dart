import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/core/constants/app_constants.dart';
import 'package:mavx_flutter/app/core/services/extensions.dart';
import 'package:mavx_flutter/app/core/services/notification_storage_service.dart';
import 'package:mavx_flutter/app/data/models/register_model.dart';
import 'package:mavx_flutter/app/data/models/response.dart';
import 'package:mavx_flutter/app/data/models/user_model.dart';
import 'package:mavx_flutter/app/data/providers/api_provider.dart';
import 'package:mavx_flutter/app/domain/repositories/auth_repository.dart';
import 'package:mavx_flutter/app/core/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiProvider apiProvider = Get.find<ApiProvider>();

  //Login
  @override
  Future<UserModel> login(
    String email,
    String password, {
    bool isSocial = false,
  }) async {
    try {
      final Map<String, dynamic> payload = isSocial
          ? {"email": email, "password": "", "isSocial": true}
          : {"email": email, "password": password, "isSocial": false};
      log('login plaintext: ${jsonEncode(payload)}');

      // Encrypt request body
      final encrypted = jsonEncode(payload).encript();
      log('login encrypted payload: $encrypted');

      // Send to API (ApiProvider will wrap String as {request: <encrypted>})
      final respStr = await apiProvider.post(
        AppConstants.login,
        request: encrypted,
      );
      log('login API raw response: $respStr');

      // Parse response: supports plaintext JSON or encrypted string
      UserModel parsed;
      try {
        parsed = UserModel.fromJson(jsonDecode(respStr));
        log('login parsed (plaintext): $parsed');
      } catch (_) {
        try {
          final decrypted = respStr.decrypt();
          log('login decrypted response: $decrypted');
          parsed = UserModel.fromJson(jsonDecode(decrypted));
          log('login parsed (decrypted): $parsed');
        } catch (e, st) {
          log('login parse failed: $e', stackTrace: st);
          throw Exception('Login failed: unable to parse server response');
        }
      }

      // Success path
      print("parsed.status ${parsed.status}");
      if (parsed.status == 200) {
        try {
          // Check if status is pending - if so, DO NOT store token or login state
          if (parsed.data.status.toLowerCase() != 'pending') {
            final prefs = await SharedPreferences.getInstance();
            // Save token
            final token = parsed.token.toString();
            await prefs.setString(AppConstants.tokenKey, token);
            // Save user JSON
            await prefs.setString(
              AppConstants.userKey,
              jsonEncode(parsed.data),
            );
            await prefs.setBool(AppConstants.isLoggedInKey, true);
            log(
              'login persisted -> token: ${token.isNotEmpty}, user saved, flag set',
            );
            try {
              const topic = 'news';
              await FirebaseMessaging.instance.subscribeToTopic(topic);
              log('✅ Subscribed device to FCM topic: $topic');
            } catch (e, st) {
              log(
                '❌ Local FCM topic subscription failed',
                error: e,
                stackTrace: st,
              );
            }

            // ✅ Step: Get FCM Token
            String? fcmToken;
            try {
              fcmToken = await FirebaseMessaging.instance.getToken();
              log("FCM Token: $fcmToken");
            } catch (e) {
              log("❌ Failed to get FCM token: $e");
            }

            // ✅ Step: Send FCM Token to Backend
            if (fcmToken != null) {
              final fcmPayload = {
                "userId": parsed.data.id,
                "deviceToken": fcmToken,
                "platform": "android",
              };
              log("FCM Payload: $fcmPayload");
              final encryptedPayload = jsonEncode(fcmPayload).encript();

              try {
                final fcmRes = await apiProvider.post(
                  AppConstants.fcmRegister,
                  request: encryptedPayload,
                );
                // The server may return either encrypted or plain JSON/text (especially on errors)
                dynamic parsedBody;
                try {
                  // Try to decrypt as base64
                  final decryptedFcm = fcmRes.decrypt();
                  parsedBody = jsonDecode(decryptedFcm);
                } catch (_) {
                  // Not encrypted or not JSON – attempt direct JSON parse, else keep raw string
                  try {
                    parsedBody = jsonDecode(fcmRes);
                  } catch (__) {
                    parsedBody = fcmRes; // raw text/HTML (e.g., 404 page)
                  }
                }
                log("✅ FCM register response: $parsedBody");
              } catch (e) {
                log("❌ Failed to send FCM token: $e");
              }
            }
          } else {
            log(
              'login success but status is pending -> NOT storing token/user',
            );
          }
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

  //Register
  @override
  Future<RegisterModel> register(Map<String, dynamic> data) async {
    try {
      String request = jsonEncode(data).encript();
      final res = await apiProvider.post(
        AppConstants.register,
        request: request,
      );
      final decriptValue = jsonDecode(res.decrypt());
      log("Decrypted Register ${decriptValue.toString()}");
      RegisterModel registerModel = RegisterModel.fromJson(decriptValue);
      return registerModel;
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  @override
  Future<void> requestOtp(String email) async {
    try {
      final request = {"email": email};
      final enc = jsonEncode(request).encript();
      final res = await apiProvider.post(AppConstants.sendOtp, request: enc);
      // The response might be plain text or encrypted JSON, but we don't need to parse
      // into UserData for OTP request. Attempt decrypt for logging only.
      try {
        final maybeJson = res.decrypt();
        log('requestOtp decrypted: $maybeJson');
      } catch (_) {
        log('requestOtp raw response: $res');
      }
      return;
    } catch (e) {
      throw Exception('Request OTP failed: ${e.toString()}');
    }
  }

  @override
  Future<void> verifyOtp(String email, String otp) async {
    try {
      final request = {"email": email, "otp": otp};
      final enc = jsonEncode(request).encript();
      final res = await apiProvider.post(AppConstants.checkOtp, request: enc);
      // Attempt to decrypt/log for visibility, but do not enforce model shape
      try {
        final dec = res.decrypt();
        log('verifyOtp decrypted: $dec');
      } catch (_) {
        log('verifyOtp raw response: $res');
      }
      return;
    } catch (e) {
      throw Exception('Verify OTP failed: ${e.toString()}');
    }
  }

  @override
  Future<void> changePassword(String email, String newPassword) async {
    try {
      final request = {"email": email, "newPassword": newPassword};
      final enc = jsonEncode(request).encript();
      await apiProvider.post(AppConstants.changePassword, request: enc);
      return;
    } catch (e) {
      throw Exception('Change Password failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      // 1) Capture current user and FCM token BEFORE clearing local storage
      int? uid;
      try {
        final user = await getCurrentUser();
        uid = user?.data.id;
      } catch (_) {}

      String? fcmToken;
      try {
        fcmToken = await FirebaseMessaging.instance.getToken();
        log('logout(): current FCM token = $fcmToken');
      } catch (e) {
        log('logout(): failed to get FCM token: $e');
      }

      // 2) Backend unregister this device token for the user (if available)
      try {
        if (uid != null) {
          final path = AppConstants.fcmUnregister.replaceFirst(
            ':id',
            uid.toString(),
          );
          await apiProvider.delete(
            path,
            queryParameters: fcmToken != null
                ? {'deviceToken': fcmToken}
                : null,
          );
          log('✅ FCM unregistered on backend for user $uid');
        }
      } catch (e, st) {
        log('❌ Backend FCM unregister failed', error: e, stackTrace: st);
      }

      // 3) Unsubscribe from local FCM topics
      // try {
      //   const topic = 'news';
      //   await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
      //   log('✅ Unsubscribed device from FCM topic: $topic');
      // } catch (e, st) {
      //   log('❌ Local FCM topic unsubscribe failed', error: e, stackTrace: st);
      // }

      // 4) Delete local FCM token
      try {
        await FirebaseMessaging.instance.deleteToken();
        log('✅ Deleted local FCM token');
      } catch (e, st) {
        log('❌ Failed to delete FCM token', error: e, stackTrace: st);
      }

      // 5) Clear local app storage (prefs + notification cache)
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.tokenKey);
      await prefs.remove(AppConstants.userKey);
      await prefs.remove(AppConstants.isLoggedInKey);
      await NotificationStorageService.clearAll();

      // 6) Navigate to login
      navigateToLogin();
      log(
        'logout: backend unregistered, FCM unsubscribed/deleted, cleared token/user/flag',
      );
    } catch (e) {
      log('Error during logout: $e');
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
  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(AppConstants.userKey);
    if (userJson == null || userJson.isEmpty) return null;
    try {
      // Try full UserModel first
      final decoded = jsonDecode(userJson);
      if (decoded is Map<String, dynamic> && decoded.containsKey('data')) {
        return UserModel.fromJson(decoded);
      }
      // Otherwise, treat as plain UserData and construct a minimal UserModel
      final data = UserData.fromJson(decoded as Map<String, dynamic>);
      final token = prefs.getString(AppConstants.tokenKey) ?? '';
      return UserModel(status: 200, message: 'OK', token: token, data: data);
    } catch (e) {
      log('getCurrentUser parse error: $e');
      return null;
    }
  }
}
