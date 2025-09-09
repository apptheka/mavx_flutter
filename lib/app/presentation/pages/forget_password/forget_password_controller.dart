import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/domain/repositories/auth_repository.dart';
import 'package:mavx_flutter/app/presentation/widgets/snackbar.dart';
import 'package:mavx_flutter/app/routes/app_routes.dart';

class ForgetPasswordController extends GetxController {
  final AuthRepository _auth = Get.find<AuthRepository>();

  final TextEditingController emailController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxString emailError = ''.obs;
  final RxInt remainingSeconds = 0.obs; // cooldown timer
  final RxBool hasRequestedOtp = false.obs; // used to reveal resend after first send
  Timer? _timer;

  static final RegExp _emailRegex = RegExp(
    r"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$",
  );

  String? validateEmail(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty || !_emailRegex.hasMatch(v)) {
      emailError.value = 'email not found';
      return 'email not found';
    }
    emailError.value = '';
    return null;
  }

  Future<void> submit() async {
    final email = emailController.text.trim();
    if (!_emailRegex.hasMatch(email)) {
      emailError.value = 'email not found';
      return;
    }
    isLoading.value = true;
    try {
      await _auth.requestOtp(email);
      Get.toNamed(
        AppRoutes.otp,
        arguments: {'email': email},
      );
      showSnackBar(
        title: 'Success',
        message: 'OTP sent to $email',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      _startCooldown(60);
      hasRequestedOtp.value = true;
    } catch (e) {
      showSnackBar(
        title: 'Error',
        message: e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _startCooldown(int seconds) {
    _timer?.cancel();
    remainingSeconds.value = seconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (remainingSeconds.value <= 1) {
        remainingSeconds.value = 0;
        t.cancel();
      } else {
        remainingSeconds.value = remainingSeconds.value - 1;
      }
    });
  }

  String get formattedRemaining {
    final s = remainingSeconds.value;
    final mm = (s ~/ 60).toString().padLeft(2, '0');
    final ss = (s % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  bool get isInCooldown => remainingSeconds.value > 0;

  Future<void> resend() async {
    if (isInCooldown || isLoading.value) return;
    final email = emailController.text.trim();
    if (!_emailRegex.hasMatch(email)) {
      emailError.value = 'email not found';
      return;
    }
    isLoading.value = true;
    try {
      await _auth.requestOtp(email);
      showSnackBar(
        title: 'Success',
        message: 'OTP re-sent to $email',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      _startCooldown(60);
      hasRequestedOtp.value = true;
    } catch (e) {
      showSnackBar(
        title: 'Error',
        message: e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    emailController.dispose();
    super.onClose();
  }
}