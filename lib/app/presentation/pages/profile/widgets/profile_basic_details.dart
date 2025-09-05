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
      onEdit: () {},
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
