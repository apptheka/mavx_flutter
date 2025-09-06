import 'package:flutter/material.dart';
import 'package:mavx_flutter/app/core/constants/assets.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/profile_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/widgets/section_card.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';
import 'package:get/get.dart';

class ProfileBasicDetails extends StatelessWidget {
  final ProfileController controller;
  const ProfileBasicDetails({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Basic Details',
      subtitle: 'Core personal and contact information',
      onEdit: () {
        final basic = controller.basicDetailsList.value;
        final genderOptions = ['Male', 'Female', 'Other'];
        String gender = basic.gender ?? 'Male';
        if (!genderOptions.contains(gender)) {
          gender = 'Male';
        }
        final dobCtrl = TextEditingController(text: basic.dateOfBirth != null ? basic.dateOfBirth!.toIso8601String().substring(0,10) : '');
        final phoneCtrl = TextEditingController(text: basic.phone ?? '');
        final emailCtrl = TextEditingController(text: basic.email ?? '');

        Get.bottomSheet(
          SafeArea(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CommonText('Basic Details', fontSize: 18, fontWeight: FontWeight.w800),
                    const SizedBox(height: 6),
                    const CommonText('Update your core personal information', color: AppColors.textSecondaryColor),
                    const SizedBox(height: 12),
                    const CommonText('Gender *', fontWeight: FontWeight.w700),
                    const SizedBox(height: 6),
                    StatefulBuilder(
                      builder: (context, setState) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(color: const Color(0xFFF5F6FA), borderRadius: BorderRadius.circular(12)),
                        child: DropdownButton<String>(
                          value: gender,
                          isExpanded: true,
                          underline: const SizedBox.shrink(),
                          items: genderOptions
                              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (v) => setState(() => gender = v ?? gender),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const CommonText('Date of Birth *', fontWeight: FontWeight.w700),
                    const SizedBox(height: 6),
                    _textField(dobCtrl, hint: 'YYYY-MM-DD'),
                    const SizedBox(height: 10),
                    const CommonText('Phone', fontWeight: FontWeight.w700),
                    const SizedBox(height: 6),
                    _textField(phoneCtrl, hint: 'Phone number', keyboardType: TextInputType.phone),
                    const SizedBox(height: 10),
                    const CommonText('Email', fontWeight: FontWeight.w700),
                    const SizedBox(height: 6),
                    _textField(emailCtrl, hint: 'Email address', keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 14),
                    Row(children: [
                      TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
                      const Spacer(),
                      SizedBox(
                        width: 140,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () async {
                            final payload = {
                              'gender': gender,
                              'dateOfBirth': dobCtrl.text.trim(),
                              'phone': phoneCtrl.text.trim(),
                              'email': emailCtrl.text.trim(),
                            };
                            await controller.saveBasicDetails(payload);
                            Get.back();
                          },
                          child: const Text('Save Changes'),
                        ),
                      ),
                    ])
                  ],
                ),
              ),
            ),
          ),
          isScrollControlled: true,
        );
      },
      child: Obx(() {
        final basic = controller.basicDetailsList.value;
        final gender = basic.gender?.isNotEmpty == true ? basic.gender! : '-';
        final dob = basic.dateOfBirth != null
            ? basic.dateOfBirth!.toIso8601String().substring(0, 10)
            : '-';
        final phone = basic.phone?.isNotEmpty == true ? basic.phone! : '-';
        final email = basic.email?.isNotEmpty == true ? basic.email! : '-';
        return Column(
          children: [
            const SizedBox(height: 4),
            _IconDetailRow(
              icon: IconAssets.gender,
              label: 'Gender',
              value: gender,
            ),
            const SizedBox(height: 16),
            _IconDetailRow(
              icon: IconAssets.dob,
              label: 'Date of Birth',
              value: dob,
            ),
            const SizedBox(height: 16),
            _IconDetailRow(
              icon: IconAssets.phone,
              label: 'Phone',
              value: phone,
            ),
            const SizedBox(height: 16),
            _IconDetailRow(
              icon: IconAssets.email,
              label: 'Email',
              value: email,
            ),
          ],
        );
      }),
    );
  }
}

Widget _textField(TextEditingController c, {String? hint, TextInputType keyboardType = TextInputType.text}) => TextField(
  controller: c,
  keyboardType: keyboardType,
  decoration: InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: const Color(0xFFF5F6FA),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
  ),
);

class _IconDetailRow extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  const _IconDetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(icon, height: 20, width: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText(
                label,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondaryColor,
              ),
              const SizedBox(height: 2),
              CommonText(
                value,
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimaryColor,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
