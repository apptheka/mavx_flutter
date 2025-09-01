import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/routes/app_routes.dart';

class LoginController extends GetxController {
  // Form key to validate inputs
  final formKey = GlobalKey<FormState>();

  // Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // State
  final isLoading = false.obs;
  final isError = false.obs;

  // Validators
  String? validateEmailOrPhone(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Please enter email or phone';

    // Basic email regex
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    // Basic phone: 7-15 digits with optional + and spaces/dashes
    final phoneRegex = RegExp(r'^\+?[0-9\s\-]{7,15}$');

    if (!emailRegex.hasMatch(v) && !phoneRegex.hasMatch(v)) {
      return 'Enter a valid email or phone number';
    }
    return null;
  }

  String? validatePassword(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Please enter password';
    if (v.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  void signIn() {
    FocusManager.instance.primaryFocus?.unfocus();
    final form = formKey.currentState;
    if (form == null) return;

    if (!form.validate()) {
      isError.value = true;
      return; // Block sign-in when invalid
    }

    // Proceed with sign-in
    isError.value = false;
    isLoading.value = true;
    // TODO: integrate API/auth here
    // Simulate request end
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      Get.offAllNamed(AppRoutes.home);
    });
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
