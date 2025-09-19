import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/domain/usecases/login_usecase.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:mavx_flutter/app/presentation/widgets/snackbar.dart';
import 'package:mavx_flutter/app/routes/app_routes.dart';

class ChangePassController extends GetxController {
  // UseCase
  late final OtpRequestUseCase _useCase = Get.find<OtpRequestUseCase>();

  // Arguments
  late final String email;

  // Form controllers and state
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;
  final isNewHidden = true.obs;
  final isConfirmHidden = true.obs;

  final newPasswordError = ''.obs;
  final confirmPasswordError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    email = (Get.arguments is Map && Get.arguments['email'] is String)
        ? (Get.arguments['email'] as String)
        : '';
  }

  String? validateNew(String? value) {
    final v = (value ?? '').trim();
    if (v.length < 6) {
      newPasswordError.value = 'Password must be at least 6 characters';
      return newPasswordError.value;
    }
    newPasswordError.value = '';
    return null;
  }

  String? validateConfirm(String? value) {
    final v = (value ?? '').trim();
    final np = newPasswordController.text.trim();
    if (v != np) {
      confirmPasswordError.value = 'Passwords do not match';
      return confirmPasswordError.value;
    }
    confirmPasswordError.value = '';
    return null;
  }

  Future<void> submit() async {
    // Unfocus immediately to detach any active input connections
    Get.focusScope?.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      await SystemChannels.textInput.invokeMethod('TextInput.hide');
    } catch (_) {}
    await Future.delayed(const Duration(milliseconds: 50));
 
    final np = newPasswordController.text.trim();
    final cp = confirmPasswordController.text.trim();

    // Validate quickly before calling API
    final nErr = validateNew(np);
    final cErr = validateConfirm(cp);

    if (nErr != null || cErr != null) return;

    isLoading.value = true;
    try {
      await _useCase.changePassword(email, np);

      showSnackBar(
        title: 'Success',
        message: 'Password changed successfully',
        backgroundColor: AppColors.green,
        colorText: AppColors.white,
      );
      // Ensure all inputs are unfocused and allow frame to settle before navigating
      Get.focusScope?.unfocus();
      FocusManager.instance.primaryFocus?.unfocus();
      await Future.delayed(const Duration(milliseconds: 300));
      // Set loading false before navigation to avoid state updates post-dispose
      if (!isClosed) {
        isLoading.value = false;
      }
      // Close any open snackbars before route change
      if (Get.isSnackbarOpen == true) {
        Get.closeAllSnackbars();
      }
      // Navigate to login on next frame to avoid gesture/IME races
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Get.currentRoute != AppRoutes.login) {
          Get.offNamed(AppRoutes.login);
        }
      });
    } catch (e) {
      showSnackBar(
        title: 'Error',
        message: e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      if (!isClosed) {
        isLoading.value = false;
      }
    }
  }

  @override
  void onClose() {
    // Release focus/IME before disposing controllers to avoid callbacks during route pop
    Get.focusScope?.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}