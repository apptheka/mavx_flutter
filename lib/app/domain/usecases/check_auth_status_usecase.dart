import '../repositories/auth_repository.dart';

class CheckAuthStatusUseCase {
  final AuthRepository _authRepository;

  CheckAuthStatusUseCase(this._authRepository);

  Future<bool> call() {
    return _authRepository.isLoggedIn();
  }
} 