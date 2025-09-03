import 'package:mavx_flutter/app/data/models/register_model.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _authRepository;

  RegisterUseCase(this._authRepository);

  Future<RegisterModel> call(Map<String, dynamic> data) async {
    return await _authRepository.register(data);
  }
} 