import 'package:flutter/material.dart';
import 'package:mavx_flutter/app/core/constants/image_assets.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/widgets/section_card.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';

class ProfileExperience extends StatelessWidget {
  const ProfileExperience({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Experience',
      subtitle: "Where you've worked and what you achieved",
      onEdit: () {},
      child: Column(
        children: const [
          _ExperienceItem(
            iconAsset: ImageAssets.ex2,
            role: 'Senior Growth Consultant',
            company: 'Intel India Pvt. Ltd.',
            employmentType: 'Full Time',
            period: 'Jan 2020 - present',
            summary:
                'Advised 15+ startups on paid growth, product loops, and GTM frameworks. Scaled user base...',
            gradientStart: Color(0xFF7C3AED),
            gradientEnd: Color(0xFF4F46E5),
          ),
          SizedBox(height: 12),
          _ExperienceItem(
            iconAsset: ImageAssets.ex1,
            role: 'Growth Lead',
            company: 'Earth Resource Technology Pvt. Ltd.',
            employmentType: 'Full Time',
            period: 'Mar 2018 - Jan 2020',
            summary:
                'Scaled user base from 20K to 300K. Reduced churn by 30%. Advised 15+ startups on paid growth...',
            gradientStart: Color(0xFF0EA5E9),
            gradientEnd: Color(0xFF2563EB),
          ),
        ],
      ),
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
