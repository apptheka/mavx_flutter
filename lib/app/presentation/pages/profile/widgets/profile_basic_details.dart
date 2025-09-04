import 'package:flutter/material.dart';
import 'package:mavx_flutter/app/core/constants/assets.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/widgets/section_card.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';

class ProfileBasicDetails extends StatelessWidget {
  const ProfileBasicDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Basic Details',
      subtitle: 'Core personal and contact information',
      onEdit: () {},
      child: Column(
        children: const [
          _IconDetailRow(
            icon: IconAssets.gender,
            label: 'Gender',
            value: 'Male',
          ),
          SizedBox(height: 16),
          _IconDetailRow(
            icon: IconAssets.dob,
            label: 'Date of Birth',
            value: '22 Aug 1988',
          ),
          SizedBox(height: 16),
          _IconDetailRow(
            icon: IconAssets.phone,
            label: 'Phone',
            value: '+91-9001234567',
          ),
          SizedBox(height: 16),
          _IconDetailRow(
            icon: IconAssets.email,
            label: 'Email',
            value: 'bruce.wayne@email.com',
          ),
        ],
      ),
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
