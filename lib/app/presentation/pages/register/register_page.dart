import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/register/register_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/register/widgets/stepper.dart';
import 'package:mavx_flutter/app/presentation/pages/register/widgets/step1.dart';
import 'package:mavx_flutter/app/presentation/pages/register/widgets/step2.dart';
import 'package:mavx_flutter/app/presentation/pages/register/widgets/step3.dart';
import 'package:mavx_flutter/app/presentation/pages/register/widgets/step4.dart';
import 'package:mavx_flutter/app/presentation/pages/register/widgets/step_nav.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';
import 'package:mavx_flutter/app/routes/app_routes.dart';

class RegisterPage extends GetView<RegisterController> {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Constrain content width for tablets/web and keep comfy horizontal padding on phones
            final maxContentWidth = 640.0;
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxContentWidth),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 16),
                              _buildHeader(),
                              const SizedBox(height: 8),
                              Obx(() {
                                switch (controller.currentStep.value) {
                                  case 1:
                                    return const RegisterStep1();
                                  case 2:
                                    return const RegisterStep2();
                                  case 3:
                                    return const RegisterStep3();
                                  case 4:
                                  default:
                                    return const RegisterStep4();
                                }
                              }),
                            ],
                          ),
                        ),
                      ),
                      const StepNav(),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CommonText(
                            'Already have an account?',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondaryColor,
                          ),
                          const SizedBox(width: 4),
                          InkWell(
                            onTap: () {
                              Get.back(); // Go back to the previous screen
                            },
                            child: CommonText(
                              'Sign In',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textButtonColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CommonText('Register', fontSize: 28, fontWeight: FontWeight.w800),
          CommonText(
            'Please register to continue',
            fontSize: 15,
            color: AppColors.textSecondaryColor,
            fontWeight: FontWeight.w400,
          ),
          const SizedBox(height: 12),
          Obx(
            () => CustomStepper(
              currentStep: controller.currentStep.value,
              totalSteps: controller.totalSteps,
            ),
          ),
        ],
      ),
    );
  }
}
