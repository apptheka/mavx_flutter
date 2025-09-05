import 'package:flutter/material.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/profile_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/widgets/section_card.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:get/get.dart';

class ProfileAbout extends StatelessWidget {
  final ProfileController controller;
  const ProfileAbout({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'About Me',
      onEdit: () {},
      child: Obx(() {
        if (controller.loading.value) {
          return const Text(
            'Loading... ',
            style: TextStyle(color: AppColors.textSecondaryColor),
          );
        }
        if (controller.error.value.isNotEmpty) {
          return Text(
            controller.error.value,
            style: const TextStyle(color: Colors.redAccent),
          );
        }
        final desc = controller.aboutMeList.value.description?.trim();
        if (desc == null || desc.isEmpty) {
          return const Text(
            'No bio added yet.',
            style: TextStyle(color: AppColors.textSecondaryColor),
          );
        }
        return Text(
          desc,
          style: const TextStyle(color: AppColors.textSecondaryColor, height: 1.4),
        );
      }),
    );
  }
}
