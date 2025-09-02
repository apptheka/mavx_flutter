import 'package:get/get.dart';
import 'package:mavx_flutter/app/data/providers/api_provider.dart'
    show ApiProvider;
import 'package:mavx_flutter/app/data/repositories/auth_repository_impl.dart';
import 'package:mavx_flutter/app/domain/repositories/auth_repository.dart';
import 'package:mavx_flutter/app/domain/usecases/check_auth_status_usecase.dart';
import 'package:mavx_flutter/app/domain/usecases/login_usecase.dart';
import 'package:mavx_flutter/app/core/services/storage_service.dart';

class DependenceInjection {
  static Future<void> init() async {
    // Initialize storage once at startup to avoid platform channel timing issues
    final storage = StorageService();
    await storage.init();
    Get.put<StorageService>(storage, permanent: true);

    // Core providers/repositories should be recreatable after disposal
    Get.lazyPut(() => ApiProvider(), fenix: true);

    //repositories
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(), fenix: true);

    //Usecases
    Get.lazyPut(() => LoginUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => CheckAuthStatusUseCase(Get.find()), fenix: true);
  }
}
