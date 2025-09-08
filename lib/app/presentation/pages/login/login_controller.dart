import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/domain/usecases/login_usecase.dart';
import 'package:mavx_flutter/app/routes/app_routes.dart';

class LoginController extends GetxController {
  // Form key to validate inputs
  final formKey = GlobalKey<FormState>();

  //usecase
  final LoginUseCase loginUseCase = Get.find<LoginUseCase>();

  // Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // State
  final isLoading = false.obs;
  final isError = false.obs;
  final isPasswordHidden = true.obs;

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

  void signIn() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final form = formKey.currentState;
    if (form == null) return;

    if (!form.validate()) {
      isError.value = true;
      return; // Block sign-in when invalid
    }

    // Proceed with sign-in
    try {
      isError.value = false;
      isLoading.value = true;
      final res = await loginUseCase.call(
        emailController.text,
        passwordController.text,
      );
      if (res.status == 200) {
        final status = res.data.status.toLowerCase();
        if (status == 'pending') {
          await _showPendingDialog();
          // stay on login; user will be able to access after approval
        } else {
          Get.offAllNamed(AppRoutes.dashboard);
          Get.snackbar(
            'Success',
            'Login successful',
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green,
            snackPosition: SnackPosition.BOTTOM,
            colorText: Colors.white,
          );
        }
        log(res.message);
      } else {
        isError.value = true;
        log(res.message);
        final msg = (res.message.isNotEmpty) ? res.message : 'Login failed';
        Get.snackbar(
          'Error',
          msg,
          colorText: Colors.white,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      isError.value = true;
      final err = e.toString();
      log(err);
      String uiMsg = 'Login failed';
      final lower = err.toLowerCase();
      if (lower.contains('401') || lower.contains('unauthorized')) {
        uiMsg = 'Invalid email or password';
      } else if (lower.contains('timeout')) {
        uiMsg = 'Connection timeout. Please try again.';
      }
      Get.snackbar('Error', uiMsg);
    }
    isLoading.value = false;
  }

  Future<void> _showPendingDialog() async {
    return Get.dialog(
      AlertDialog(
        title: const Text('Profile Under Review'),
        content: const Text(
          'Your profile is under review. You will be notified once approved. You can log in after approval.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('OK')),
        ],
      ),
      barrierDismissible: false,
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();

    super.onClose();
  }
}
