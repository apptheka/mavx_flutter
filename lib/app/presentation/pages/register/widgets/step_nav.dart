import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/register/register_controller.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';

class StepNav extends StatelessWidget {
  const StepNav({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RegisterController>();
    return  SafeArea(
          minimum: const EdgeInsets.only(bottom: 8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 360;
                final prevStyle = ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffBDBDBD),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                  minimumSize: const Size.fromHeight(52),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                );
                final nextStyle = ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                  minimumSize: const Size.fromHeight(52),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                );

                return Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: controller.isFirstStep ? Get.back : controller.prevStep,
                        style: prevStyle,
                        child: CommonText(
                          controller.isFirstStep ? 'Back' : 'Previous',
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (!isNarrow)
                      Container(
                        width: 2,
                        height: 50,
                        color: const Color(0xffD9D9D9),
                      ),
                    if (!isNarrow) const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: controller.nextStep,
                        style: nextStyle,
                        child: CommonText(
                          controller.isLastStep ? 'Submit' : 'Next',
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
  }
}
