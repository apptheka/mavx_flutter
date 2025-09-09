import 'package:mavx_flutter/app/data/models/register_model.dart';
import 'package:mavx_flutter/app/data/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> login(String email, String password);
  Future<void> logout();
  Future<void> requestOtp(String email);
  Future<void> changePassword(String email,String newPassword);
  Future<void> verifyOtp(String email,String otp);
  Future<bool> isLoggedIn();
  Future<UserModel?> getCurrentUser();
  Future<RegisterModel> register(Map<String, dynamic> data); 
}
