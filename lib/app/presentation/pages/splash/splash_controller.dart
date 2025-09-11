import 'package:get/get.dart';
import 'package:mavx_flutter/app/domain/usecases/check_auth_status_usecase.dart';
import 'package:mavx_flutter/app/core/services/storage_service.dart';
import 'package:mavx_flutter/app/routes/app_routes.dart'; 

class SplashController extends GetxController { 
  final CheckAuthStatusUseCase checkAuthStatusUseCase = Get.find<CheckAuthStatusUseCase>();
  final StorageService storage = Get.find<StorageService>();
  
  @override
  void onReady() {
    super.onReady();
    _navigateToNextScreen();
  }

 void _navigateToNextScreen() async {
    // Simulate splash screen delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Check if user is logged in
    try {
      final bool isLoggedIn = await checkAuthStatusUseCase.call(); 
      
      if (isLoggedIn) { 
        Get.offAllNamed(AppRoutes.dashboard);
      } else { 
        // Show onboarding only once
        final seen = storage.prefs.getBool('onboarding_seen') ?? false;
        if (seen) {
          Get.offAllNamed(AppRoutes.login);
        } else {
          Get.offAllNamed(AppRoutes.getStarted);
        }
      }
    } catch (e) {  
      final seen = storage.prefs.getBool('onboarding_seen') ?? false;
      if (seen) {
        Get.offAllNamed(AppRoutes.login);
      } else {
        Get.offAllNamed(AppRoutes.getStarted);
      }
    }
  }
} 