import 'package:mavx_flutter/app/data/models/response.dart';
import 'package:mavx_flutter/app/data/models/user_model.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  Future<UserModel> call(String email, String password) {
    return _authRepository.login(email, password);
  }
}

class OtpRequestUseCase {
  final AuthRepository _authRepository;

  OtpRequestUseCase(this._authRepository);

  Future<CommonResponse> call(String phone) {
    return _authRepository.requestOtp(phone);
  }
}
