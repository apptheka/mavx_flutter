import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/domain/repositories/auth_repository.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:mavx_flutter/app/presentation/widgets/snackbar.dart';
import 'package:mavx_flutter/app/routes/app_routes.dart';

class OtpController extends GetxController {
  final AuthRepository _auth = Get.find<AuthRepository>();

  late final String email;

  final int otpLength = 4;
  final RxBool isLoading = false.obs;
  final Rx<Color?> borderColor = Rx<Color?>(null);
  final RxInt remainingSeconds = 0.obs;
  final RxBool isResending = false.obs;

  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;

  @override
  void onInit() {
    super.onInit();
    email = (Get.arguments is Map && Get.arguments['email'] is String)
        ? (Get.arguments['email'] as String)
        : '';
    controllers = List.generate(otpLength, (_) => TextEditingController());
    focusNodes = List.generate(otpLength, (_) => FocusNode());
    // Start a cooldown when entering this page (assume OTP was just sent)
    _startCooldown(60);
  }

  String get otp => controllers.map((c) => c.text).join();

  void onChangedDigit(int index, String value) {
    if (value.isNotEmpty) {
      // Only one char allowed
      controllers[index].text = value.characters.last;
      controllers[index].selection = TextSelection.fromPosition(
        TextPosition(offset: controllers[index].text.length),
      );
      if (index < otpLength - 1) {
        focusNodes[index + 1].requestFocus();
      } else {
        focusNodes[index].unfocus();
      }
      // reset border color when user edits
      borderColor.value = null;
    }
  }

  // Cooldown + Resend OTP
  Timer? _timer;

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
    if (isInCooldown || isResending.value || email.isEmpty) return;
    isResending.value = true;
    try {
      await _auth.requestOtp(email);
      Get.snackbar(
        'Success',
        'OTP re-sent to $email',
        backgroundColor: AppColors.green,
        colorText: AppColors.white,
      );
      _startCooldown(60);
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isResending.value = false;
    }
  }

  KeyEventResult onKey(KeyEvent event, int index) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace) {
      if (controllers[index].text.isEmpty && index > 0) {
        focusNodes[index - 1].requestFocus();
        controllers[index - 1].clear();
      }
    }
    return KeyEventResult.ignored;
  }

  Future<void> submit() async {
    final code = otp;
    if (code.length != otpLength) {
      borderColor.value = AppColors.errorColor;
      SnackBarWidget(
        title: 'Invalid OTP',
        message: 'Please enter the $otpLength-digit code.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    isLoading.value = true;
    try {
      await _auth.verifyOtp(email, code);
      borderColor.value = AppColors.green;
      Get.toNamed(
        AppRoutes.changePassword,
        arguments: {'email': email},
      );
      Get.snackbar(
        'Success',
        'OTP verified',
        backgroundColor: AppColors.green,
        snackPosition: SnackPosition.BOTTOM,
        colorText: AppColors.white,
      );
      // Next screen is Change Password. Do not navigate to Login here.
    } catch (e) {
      borderColor.value = AppColors.errorColor;
      Get.snackbar(
        'Error',
        e.toString(),
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
    for (final c in controllers) {
      c.dispose();
    }
    for (final f in focusNodes) {
      f.dispose();
    }
    super.onClose();
  }
}
