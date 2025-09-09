import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/otp/otp_controller.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:mavx_flutter/app/presentation/widgets/app_text_field.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';

class OtpPage extends GetView<OtpController> {
  const OtpPage({super.key});

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
                            'Enter OTP',
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                          ),
                          const SizedBox(height: 6),
                          CommonText(
                            controller.email.isEmpty
                                ? 'Enter the 4-digit code'
                                : 'Enter the 4-digit code sent to ${controller.email}',
                            fontSize: 15,
                            color: AppColors.textSecondaryColor,
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(controller.otpLength, (i) {
                          return SizedBox(
                            width: 56,
                            child: Focus(
                              onKeyEvent: (node, value) => controller.onKey(value, i),
                              child: AppTextField(
                                controller: controller.controllers[i],
                                focusNode: controller.focusNodes[i],
                                keyboardType: TextInputType.number,
                                textInputAction: i == controller.otpLength - 1
                                    ? TextInputAction.done
                                    : TextInputAction.next,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(1),
                                ],
                                textAlign: TextAlign.center,
                                borderColor: controller.borderColor.value,
                                onChanged: (val) => controller.onChangedDigit(i, val),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 32),
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
                                  'Verify',
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white,
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Resend section: show countdown or resend button
                    Obx(
                      () => Column(
                        children: [
                          if (controller.isInCooldown)
                            CommonText(
                              'You can resend OTP in ${controller.formattedRemaining}',
                              fontSize: 14,
                              color: AppColors.textSecondaryColor,
                              fontWeight: FontWeight.w400,
                            )
                          else
                            TextButton(
                              onPressed: controller.isResending.value
                                  ? null
                                  : controller.resend,
                              child: const CommonText(
                                'Resend OTP',
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textButtonColor,
                              ),
                            ),
                        ],
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