import 'package:mavx_flutter/app/data/models/response.dart'; 
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _authRepository;

  RegisterUseCase(this._authRepository);

  Future<CommonResponse> call(Map<String, dynamic> data) async {
    return await _authRepository.register(data);
  }
} 