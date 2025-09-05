import 'package:flutter/material.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/profile_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/widgets/section_card.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:get/get.dart';

class ProfileLanguages extends StatelessWidget {
  final ProfileController controller;
  const ProfileLanguages({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Languages',
      subtitle: "Languages you're fluent in for communication",
      onEdit: () {},
      child: Obx(() {
        final langs = controller.languageList;
        if (langs.isEmpty) {
          return const Text(
            'No languages added yet.',
            style: TextStyle(color: AppColors.textSecondaryColor),
          );
        }
        String detailsFor(int? r, int? w, int? s) {
          final parts = <String>[];
          if (r == 1) parts.add('Read');
          if (w == 1) parts.add('Write');
          if (s == 1) parts.add('Speak');
          return parts.isEmpty ? '-' : parts.join(' • ');
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < langs.length; i++) ...[
              _LangCard(
                title: langs[i].languageName ?? '-',
                details: detailsFor(langs[i].canRead, langs[i].canWrite, langs[i].canSpeak),
              ),
              if (i != langs.length - 1) const SizedBox(height: 12),
            ]
          ],
        );
      }),
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
