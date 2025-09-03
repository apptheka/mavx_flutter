import 'package:mavx_flutter/app/data/models/register_model.dart';
import 'package:mavx_flutter/app/data/models/response.dart';
import 'package:mavx_flutter/app/data/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> login(String email, String password);
  Future<void> logout();
  Future<CommonResponse> requestOtp(String phone);
  Future<bool> isLoggedIn();
  Future<UserModel?> getCurrentUser();
  Future<RegisterModel> register(Map<String, dynamic> data);
  Future<String> verifyOtp(String phoneNumber, String otp);
  Future<bool> checkAuthStatus();
}
