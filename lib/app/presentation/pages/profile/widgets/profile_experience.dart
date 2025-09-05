import 'package:flutter/material.dart';
import 'package:mavx_flutter/app/core/constants/image_assets.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/profile_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/widgets/section_card.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:get/get.dart';

class ProfileExperience extends StatelessWidget {
  final ProfileController controller;
  const ProfileExperience({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Experience',
      subtitle: "Where you've worked and what you achieved",
      onEdit: () {},
      child: Obx(() {
        final exps = controller.experienceList;
        if (exps.isEmpty) {
          return const Text(
            'No experience added yet.',
            style: TextStyle(color: AppColors.textSecondaryColor),
          );
        }
        Color startFor(int i) => [
              const Color(0xFF7C3AED),
              const Color(0xFF0EA5E9),
              const Color(0xFF10B981),
              const Color(0xFFF59E0B),
            ][i % 4];
        Color endFor(int i) => [
              const Color(0xFF4F46E5),
              const Color(0xFF2563EB),
              const Color(0xFF059669),
              const Color(0xFFD97706),
            ][i % 4];
        String fmt(DateTime? d) {
          if (d == null) return '';
          const months = [
            'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'
          ];
          return '${months[d.month - 1]} ${d.year}';
        }
        return Column(
          children: [
            for (int i = 0; i < exps.length; i++) ...[
              _ExperienceItem(
                iconAsset: i % 2 == 0 ? ImageAssets.ex2 : ImageAssets.ex1,
                role: exps[i].role ?? '-',
                company: exps[i].companyName ?? '-',
                employmentType: exps[i].employmentType ?? '-',
                period: () {
                  final s = fmt(exps[i].startDate);
                  final e = exps[i].isCurrent == 1 ? 'Present' : fmt(exps[i].endDate);
                  if (s.isEmpty && (e.isEmpty || e == 'Present')) return '-';
                  return [s, e].where((x) => x.isNotEmpty).join(' - ');
                }(),
                summary: exps[i].description?.trim().isNotEmpty == true
                    ? exps[i].description!.trim()
                    : '-',
                gradientStart: startFor(i),
                gradientEnd: endFor(i),
              ),
              if (i != exps.length - 1) const SizedBox(height: 12),
            ]
          ],
        );
      }),
    );
  }
}

class _ExperienceItem extends StatelessWidget {
  final String role;
  final String company;
  final String employmentType;
  final String period;
  final String summary;
  final Color gradientStart;
  final Color gradientEnd;
  final String iconAsset;
  const _ExperienceItem({
    required this.iconAsset,
    required this.role,
    required this.company,
    required this.employmentType,
    required this.period,
    required this.summary,
    this.gradientStart = const Color(0xFF7C3AED),
    this.gradientEnd = const Color(0xFF4F46E5),
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
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [gradientStart, gradientEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    iconAsset,
                    // Remove tint so original colors show; rely on gradient for contrast
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      role,
                      style: const TextStyle(
                        color: AppColors.textPrimaryColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      company,
                      style: const TextStyle(
                        color: AppColors.textSecondaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$employmentType • $period',
                      style: const TextStyle(
                        color: AppColors.textSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ],
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$summary',
                  style: const TextStyle(color: AppColors.textSecondaryColor),
                ),
                const TextSpan(
                  text: 'Read More',
                  style: TextStyle(
                    color: AppColors.textButtonColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
