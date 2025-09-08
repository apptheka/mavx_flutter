import 'dart:ui';

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
      onEdit: () {
        final textCtrl = TextEditingController(text: controller.aboutMeList.value.description ?? '');
        Get.bottomSheet(
          SafeArea(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with close
                      Row(
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('About Me', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                                SizedBox(height: 4),
                                Text('Tell us about yourself and your career goals', style: TextStyle(color: AppColors.textSecondaryColor)),
                              ],
                            ),
                          ),
                          IconButton(onPressed: Get.back, icon: const Icon(Icons.close))
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: textCtrl,
                        maxLines: 6,
                        decoration: InputDecoration(
                          hintText: 'Write something about yourself...',
                          filled: true,
                          fillColor: const Color(0xFFF5F6FA),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 140,
                            height: 44,
                            child: OutlinedButton(
                              onPressed: () => Get.back(),
                              child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w700)),
                            ),
                          ),
                          SizedBox(
                            width: 160,
                            height: 44,
                            child: ElevatedButton(
                              onPressed: () async {
                                final desc = textCtrl.text.trim();
                                if (desc.isEmpty) {
                                  Get.snackbar('Required', 'About Me is required');
                                  return;
                                }
                                await controller.saveAboutMe(desc);
                                Get.back();
                              },
                              child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.w700)),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          isScrollControlled: true,
        );
      },
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
