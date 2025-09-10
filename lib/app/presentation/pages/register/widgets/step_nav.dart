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

            return Obx(() {
              final bool isFirst = controller.isFirstStep;
              final bool isLast = controller.isLastStep;
              return Row(
                children: [
                  if (!isFirst) ...[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: controller.prevStep,
                        style: prevStyle,
                        child: const CommonText(
                          'Previous',
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
                  ],
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isLast ? controller.submitRegistration : controller.nextStep,
                      style: nextStyle,
                      child: CommonText(
                        isLast ? 'Submit' : 'Next',
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              );
            });
          },
        ),
      ),
    );
  }
}
