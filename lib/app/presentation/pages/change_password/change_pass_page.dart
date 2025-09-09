import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/change_password/change_pass_controller.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:mavx_flutter/app/presentation/widgets/app_text_field.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';

class ChangePassPage extends GetView<ChangePassController> {
  const ChangePassPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 32),
                    Center(
                      child: Column(
                        children: [
                          const CommonText(
                            'Change Password',
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                          ),
                          const SizedBox(height: 6),
                          CommonText(
                            controller.email.isEmpty
                                ? 'Set your new password'
                                : 'Set a new password for ${controller.email}',
                            fontSize: 15,
                            color: AppColors.textSecondaryColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // New Password
                    CommonText(
                      'New Password',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppTextField(
                            controller: controller.newPasswordController,
                            hintText: 'Enter new password',
                            obscureText: controller.isNewHidden.value,
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.isNewHidden.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColors.textSecondaryColor,
                              ),
                              onPressed: () =>
                                  controller.isNewHidden.toggle(),
                            ),
                            textInputAction: TextInputAction.next,
                            validator: controller.validateNew,
                            onChanged: (_) => controller.validateNew(
                                controller.newPasswordController.text),
                          ),
                          if (controller.newPasswordError.value.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                controller.newPasswordError.value,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Confirm Password
                    CommonText(
                      'Confirm Password',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppTextField(
                            controller: controller.confirmPasswordController,
                            hintText: 'Re-enter new password',
                            obscureText: controller.isConfirmHidden.value,
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.isConfirmHidden.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColors.textSecondaryColor,
                              ),
                              onPressed: () =>
                                  controller.isConfirmHidden.toggle(),
                            ),
                            textInputAction: TextInputAction.done,
                            validator: controller.validateConfirm,
                            onChanged: (_) => controller.validateConfirm(
                                controller.confirmPasswordController.text),
                          ),
                          if (controller.confirmPasswordError.value.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                controller.confirmPasswordError.value,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Change Password button
                    Obx(
                      () => SizedBox(
                        height: 56,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                            elevation: 0,
                          ),
                          onPressed:
                              controller.isLoading.value ? null : controller.submit,
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const CommonText(
                                  'Change Password',
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white,
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}