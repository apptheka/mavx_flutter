import 'package:flutter/material.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/widgets/section_card.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';

class ProfileLanguages extends StatelessWidget {
  const ProfileLanguages({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Languages',
      subtitle: "Languages you're fluent in for communication",
      onEdit: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _LangCard(title: 'English', details: 'Read • Write • Speak'),
          SizedBox(height: 12),
          _LangCard(title: 'French', details: 'Read • Write • Speak'),
        ],
      ),
    );
  }
} 

class _LangCard extends StatelessWidget {
  final String title;
  final String details;
  const _LangCard({required this.title, required this.details});

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
            title,
            style: const TextStyle(
              color: AppColors.textPrimaryColor,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            details,
            style: const TextStyle(
              color: AppColors.textSecondaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
