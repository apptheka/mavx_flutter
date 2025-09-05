import 'package:flutter/material.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/profile_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/widgets/section_card.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:get/get.dart';

class ProfileEducation extends StatelessWidget {
  final ProfileController controller;
  const ProfileEducation({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Education',
      subtitle: 'Your academic and professional learning history',
      onEdit: () {},
      child: Obx(() {
        final items = controller.educationList;
        if (items.isEmpty) {
          return const Text(
            'No education added yet.',
            style: TextStyle(color: AppColors.textSecondaryColor),
          );
        }
        String yearStr(DateTime? s, DateTime? e, int? isCurrent) {
          String toYear(DateTime? d) => d?.year.toString() ?? '';
          final start = toYear(s);
          final end = (isCurrent == 1) ? 'Present' : toYear(e);
          if (start.isEmpty && (end.isEmpty || end == 'Present')) return '-';
          return [start, end].where((x) => x.isNotEmpty).join('–');
        }
        return Column(
          children: [
            for (int i = 0; i < items.length; i++) ...[
              _EducationItem(
                degree: items[i].degree ?? '-',
                school: items[i].institutionName ?? '-',
                year: yearStr(items[i].startDate, items[i].endDate, items[i].isCurrent),
              ),
              if (i != items.length - 1) const SizedBox(height: 12),
            ]
          ],
        );
      }),
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
