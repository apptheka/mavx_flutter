import 'dart:developer';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/domain/usecases/check_auth_status_usecase.dart';
import 'package:mavx_flutter/app/routes/app_routes.dart'; 

class SplashController extends GetxController { 
  final CheckAuthStatusUseCase checkAuthStatusUseCase = Get.find<CheckAuthStatusUseCase>();
  
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
      log('Splash: isLoggedIn = ' + isLoggedIn.toString());
      
      if (isLoggedIn) {
        log('Splash: navigating to ' + AppRoutes.home);
        Get.offAllNamed(AppRoutes.home);
      } else {
        log('Splash: navigating to ' + AppRoutes.getStarted);
        Get.offAllNamed(AppRoutes.getStarted);
      }
    } catch (e) { 
      log('Splash: auth check failed, navigating to get-started. Error: ' + e.toString());
      Get.offAllNamed(AppRoutes.getStarted);
    }
  }
} 