import 'package:flutter/material.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/profile_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/widgets/section_card.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:get/get.dart';

class ProfileSkills extends StatelessWidget {
  final ProfileController controller;
  const ProfileSkills({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Key Skills',
      subtitle: 'Highlight your strongest areas of expertise',
      onEdit: () {},
      child: Obx(() {
        final skills = controller.skillList;
        if (skills.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'No skills added yet.',
              style: TextStyle(color: AppColors.textSecondaryColor),
            ),
          );
        }
        final chipColors = const [
          Color(0xFFF6EAD5),
          Color(0xFFEFE7DE),
          Color(0xFFE8E2F7),
          Color(0xFFDFF2EA),
          Color(0xFFE3F1FF),
          Color(0xFFE7EFF8),
        ];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (int i = 0; i < skills.length; i++)
                _Chip(
                  text: skills[i].skillName ?? '-',
                  bgColor: chipColors[i % chipColors.length],
                ),
            ],
          ),
        );
      }),
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  final Color bgColor; 
  const _Chip({
    required this.text,
    this.bgColor = const Color(0xFFEFF4F8), 
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.textPrimaryColor,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
