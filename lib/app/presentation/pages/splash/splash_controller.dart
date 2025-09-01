import 'package:get/get.dart';
import 'package:mavx_flutter/app/routes/app_routes.dart'; 

class SplashController extends GetxController { 
  
  @override
  void onInit() {
    super.onInit();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    // Simulate splash screen delay
    await Future.delayed(const Duration(seconds: 2));
    
    Get.offAllNamed(AppRoutes.getStarted);
  }
} 