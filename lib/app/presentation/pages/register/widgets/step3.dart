import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/register/register_controller.dart';
import 'package:mavx_flutter/app/presentation/widgets/app_text_field.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';
import 'package:mavx_flutter/app/presentation/widgets/custom_dropdown.dart';

class RegisterStep3 extends StatelessWidget {
  const RegisterStep3({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RegisterController>();
    return Form(
      key: controller.formKeyStep3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              const CommonText(
                'LinkedIn Profile URL',
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 8),
              AppTextField(
                hintText: 'Enter URL',
                keyboardType: TextInputType.url,
                focusNode: controller.fnLinkedIn,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(controller.fnOtherPrimaryFunction),
                controller: controller.linkedInCtrl,
                validator: controller.validateLinkedIn,
              ),
              const SizedBox(height: 16),
              const CommonText(
                'Role Type',
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 8),
              AppDropdown<String>(
                items: controller.roleTypeItems,
                value: controller.roleTypeCtrl.value.isEmpty
                    ? null
                    : controller.roleTypeCtrl.value,
                hintText: 'Select role type',
                onChanged: (v) => controller.roleTypeCtrl.value = v ?? '',
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Role type required' : null,
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CommonText(
                          'Primary Function/Specification',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        const SizedBox(height: 8),
                        Obx(
                          () => AppDropdown<String>(
                            items: controller.primaryFunctionItems,
                            value: controller.primaryFunctionCtrl.value.isEmpty
                                ? null
                                : controller.primaryFunctionCtrl.value,
                            hintText: 'Select',
                            onChanged: (v) =>
                                controller.primaryFunctionCtrl.value = v ?? '',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppTextField(
                      hintText: 'Other',
                      controller: controller.otherPrimaryFunctionCtrl,
                      focusNode: controller.fnOtherPrimaryFunction,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(controller.fnOtherIndustry),
                      validator: (v) {
                        final value = v?.trim() ?? '';
                        if (value.isNotEmpty) return 'Other required';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CommonText(
                          'Primary Function/Industry',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        const SizedBox(height: 8),
                          Obx(
                          () => AppDropdown<String>(
                            items: controller.industryItems,
                            value: controller.industryCtrl.value.isEmpty
                                ? null
                                : controller.industryCtrl.value,
                            hintText: 'Select',
                            onChanged: (v) =>
                                controller.industryCtrl.value = v ?? '',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppTextField(
                      keyboardType: TextInputType.text,
                      hintText: 'Other',
                      controller: controller.otherPrimaryIndustryCtrl,
                      focusNode: controller.fnOtherIndustry,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(controller.fnCurrentEmployer),
                      validator: (v) {
                        final value = v?.trim() ?? '';
                        if (value.isNotEmpty) return 'Other required';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const CommonText(
                'Current/Last Regular Employer Name',
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 8),
              AppTextField(
                hintText: 'Enter',
                keyboardType: TextInputType.text,
                controller: controller.currentEmployerCtrl,
                focusNode: controller.fnCurrentEmployer,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  final ctrl = Get.find<RegisterController>();
                  if (ctrl.validateCurrentStep()) {
                    ctrl.nextStep();
                  } else {
                    FocusScope.of(context).unfocus();
                  }
                },
                validator: (v) {
                  final value = v?.trim() ?? '';
                  if (value.isEmpty) return 'Current employer required';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const CommonText(
                'Secondary Function',
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 8),
              AppDropdown<String>(
                items: controller.primaryFunctionItems,
                value: controller.secondaryFactorCtrl.value.isEmpty
                    ? null
                    : controller.secondaryFactorCtrl.value,
                hintText: 'Select',
                onChanged: (v) =>
                    controller.secondaryFactorCtrl.value = v ?? '',
                validator: (v) => (v == null || v.isEmpty)
                    ? 'Secondary function required'
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
