import 'package:flutter/material.dart';
import 'package:get/get.dart'; 
import 'package:mavx_flutter/app/presentation/pages/forget_password/forget_password_controller.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:mavx_flutter/app/presentation/widgets/app_text_field.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';

class ForgetPasswordPage extends GetView<ForgetPasswordController> {
  const ForgetPasswordPage({super.key});

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
                    // Header
                    Center(
                      child: Column(
                        children: [ 
                          CommonText(
                            'Forgot Password',
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                          ),
                          SizedBox(height: 6),
                          CommonText(
                            'Enter your email to receive an OTP',
                            fontSize: 15,
                            color: AppColors.textSecondaryColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Form
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CommonText(
                          'Email',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        const SizedBox(height: 8),
                        Obx(
                          () => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppTextField(
                                controller: controller.emailController,
                                hintText: 'Enter email',
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.done,
                                validator: controller.validateEmail,
                                onChanged: (_) => controller.emailError.value = '',
                              ),
                              if (controller.emailError.value.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(
                                    controller.emailError.value,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Simple Submit button (no cooldown/resend here)
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
                          onPressed: controller.isLoading.value ? null : controller.submit,
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const CommonText(
                                  'Send OTP',
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