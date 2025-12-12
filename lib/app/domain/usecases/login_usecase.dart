import 'package:mavx_flutter/app/data/models/response.dart';
import 'package:mavx_flutter/app/data/models/user_model.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  Future<UserModel> call(String email, String password, {bool isSocial = false}) {
    return _authRepository.login(email, password, isSocial: isSocial);
  }
}

class OtpRequestUseCase {
  final AuthRepository _authRepository;

  OtpRequestUseCase(this._authRepository);

  Future<void> call(String email) {
    return _authRepository.requestOtp(email);
  }

  Future<void> verifyOtp(String email,String otp) {
    return _authRepository.verifyOtp(email,otp);
  }
  
  Future<void> changePassword(String email,String newPassword) {
    return _authRepository.changePassword(email,newPassword);
  }
}
