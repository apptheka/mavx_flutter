import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/core/constants/assets.dart';
import 'package:mavx_flutter/app/presentation/pages/register/register_controller.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';
import 'package:mavx_flutter/app/presentation/widgets/app_text_field.dart';
import 'package:mavx_flutter/app/presentation/widgets/custom_dropdown.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';

class RegisterStep4 extends StatelessWidget {
  const RegisterStep4({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RegisterController>();
    return Form(
      key: controller.formKeyStep4,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              const CommonText(
                'Secondary Factor',
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 8),
              AppDropdown<String>(
                items: controller.industryItems,
                value: controller.industryCtrl.value.isEmpty
                    ? null
                    : controller.industryCtrl.value,
                hintText: 'Select',
                onChanged: (v) => controller.industryCtrl.value = v ?? '',
                validator: (v) => (v == null || v.isEmpty)
                    ? 'Secondary factor required'
                    : null,
              ),
              const SizedBox(height: 16),

              const CommonText(
                'Govt. Issued ID Card',
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 8),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isNarrow = constraints.maxWidth < 360;
                  final button = Obx(
                    () => ElevatedButton.icon(
                      onPressed: controller.uploadingId.value
                          ? null
                          : () async {
                              if (controller.idTypeCtrl.value.isEmpty) {
                                Get.snackbar(
                                  'Error',
                                  'Please select ID type',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.red,
                                  barBlur: 20,
                                  animationDuration: const Duration(seconds: 2),
                                  colorText: Colors.white,
                                );
                              } else {
                                final result = await FilePicker.platform
                                    .pickFiles(
                                      type: FileType.custom,
                                      allowedExtensions: const [
                                        'pdf',
                                        'jpg',
                                        'jpeg',
                                        'png',
                                      ],
                                      allowMultiple: false,
                                    );
                                final path = result?.files.single.path;
                                if (path != null) {
                                  await controller.uploadIdDocument(path);
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.textBlueColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        // Keep height consistent; width adapts via parent
                        minimumSize: const Size(0, 52),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      icon: Image.asset(
                        IconAssets.upload,
                        color: Colors.white,
                        height: 15,
                        width: 15,
                      ),
                      label: Text(
                        controller.uploadingId.value
                            ? 'Uploading...'
                            : (controller.idUrl.isNotEmpty
                                  ? 'Uploaded'
                                  : 'Upload'),
                      ),
                    ),
                  );

                  if (isNarrow) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppDropdown<String>(
                          items: controller.idTypeItems,
                          value: controller.idTypeCtrl.value.isEmpty
                              ? null
                              : controller.idTypeCtrl.value,
                          hintText: 'Select',
                          onChanged: (v) =>
                              controller.idTypeCtrl.value = v ?? '',
                          validator: (v) => (v == null || v.isEmpty)
                              ? 'ID type required'
                              : null,
                        ),
                        const SizedBox(height: 10),
                        button,
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: AppDropdown<String>(
                          items: controller.idTypeItems,
                          value: controller.idTypeCtrl.value.isEmpty
                              ? null
                              : controller.idTypeCtrl.value,
                          hintText: 'Select',
                          onChanged: (v) =>
                              controller.idTypeCtrl.value = v ?? '',
                          validator: (v) => (v == null || v.isEmpty)
                              ? 'ID type required'
                              : null,
                        ),
                      ),
                      const SizedBox(width: 10),
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 112,
                          maxWidth: 160,
                        ),
                        child: button,
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 16),
              const CommonText(
                'Resume CV',
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 8),
              Obx(
                () => OutlinedButton.icon(
                  onPressed: controller.uploadingResume.value
                      ? null
                      : () async {
                          final result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: const ['pdf', 'doc', 'docx'],
                            allowMultiple: false,
                          );
                          final path = result?.files.single.path;
                          if (path != null) {
                            await controller.uploadResume(path);
                          }
                        },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: AppColors.textBlueColor,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    foregroundColor: AppColors.textBlueColor,
                    textStyle: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  icon: Image.asset(IconAssets.upload, height: 15, width: 15),
                  label: Text(
                    controller.uploadingResume.value
                        ? 'Uploading...'
                        : (controller.resumeUrl.isNotEmpty
                              ? 'Uploaded'
                              : 'Upload Resume'),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              const CommonText(
                'Profile Photo',
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 8),
              Obx(
                () => OutlinedButton.icon(
                  onPressed: controller.uploadingProfile.value
                      ? null
                      : () async {
                          final result = await FilePicker.platform.pickFiles(
                            type: FileType.image,
                            allowMultiple: false,
                          );
                          final path = result?.files.single.path;
                          if (path != null) {
                            await controller.uploadProfileImage(path);
                          }
                        },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: AppColors.textBlueColor,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    foregroundColor: AppColors.textBlueColor,
                    textStyle: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  icon: Image.asset(IconAssets.upload, height: 15, width: 15),
                  label: Text(
                    controller.uploadingProfile.value
                        ? 'Uploading...'
                        : (controller.profileUrl.isNotEmpty
                              ? 'Uploaded'
                              : 'Upload Image'),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              const CommonText(
                'Quantified Achievements',
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 8),
              AppTextField(
                hintText: 'Write here...',
                controller: controller.achievementsCtrl,
                keyboardType: TextInputType.multiline,
                maxLines: 6,
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
