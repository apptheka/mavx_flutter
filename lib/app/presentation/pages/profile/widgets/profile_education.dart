import 'package:flutter/material.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/widgets/section_card.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';

class ProfileEducation extends StatelessWidget {
  const ProfileEducation({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Education',
      subtitle: 'Your academic and professional learning history',
      onEdit: () {},
      child: Column(
        children: const [
          _EducationItem(
            degree: 'Master of Business Administration',
            school: 'MDI New York University',
            year: '2012–2014',
          ),
          SizedBox(height: 12),
          _EducationItem(
            degree: 'Bachelor of Commerce',
            school: 'Cambridge University',
            year: '2009–2012',
          ),
        ],
      ),
    );
  }
}

class _EducationItem extends StatelessWidget {
  final String degree;
  final String school;
  final String year;
  const _EducationItem({
    required this.degree,
    required this.school,
    required this.year,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.black.withValues(alpha: 0.08),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            degree,
            style: const TextStyle(
              color: AppColors.textPrimaryColor,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            school,
            style: const TextStyle(
              color: AppColors.textSecondaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            year,
            style: const TextStyle(
              color: AppColors.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
