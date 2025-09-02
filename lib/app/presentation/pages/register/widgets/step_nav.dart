import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/register/controller/register_controller.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';

class StepNav extends StatelessWidget {
  const StepNav({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RegisterController>();
    return Obx(() => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: controller.isFirstStep ? null : controller.prevStep,
                  style: ElevatedButton.styleFrom(  
                    backgroundColor: const Color(0xffBDBDBD),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: CommonText('Previous', fontSize: 17, fontWeight: FontWeight.w600,color: Colors.white,),
                ),
              ),
              const SizedBox(width: 12),
               Container(
                width: 2,
                height: 56,
                color: const Color(0xffD9D9D9),
               ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: controller.nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                  ),
                  child: CommonText(controller.isLastStep ? 'Submit' : 'Next', fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ));
  }
}
