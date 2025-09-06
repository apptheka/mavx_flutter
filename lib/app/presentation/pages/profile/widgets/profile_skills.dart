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
      onEdit: () {
        // Prefill from existing skills
        final existing = controller.skillList.map((e) => e.skillName ?? '').where((e) => e.isNotEmpty).toList();
        final namesCtrl = TextEditingController(text: existing.isNotEmpty ? existing.join(', ') : '');
        String category = 'Technical';
        Get.bottomSheet(
          SafeArea(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Skills', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  const Text('Add your professional skills - separate multiple skills with commas', style: TextStyle(color: AppColors.textSecondaryColor)),
                  const SizedBox(height: 12),
                  const Text('Skill Names *', style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: namesCtrl,
                    decoration: InputDecoration(
                      hintText: 'e.g., JavaScript, React, SQL',
                      filled: true,
                      fillColor: const Color(0xFFF5F6FA),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('Skill Category *', style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(color: const Color(0xFFF5F6FA), borderRadius: BorderRadius.circular(12)),
                    child: DropdownButton<String>(
                      value: category,
                      isExpanded: true,
                      underline: const SizedBox.shrink(),
                      items: const ['Technical', 'Soft', 'Other']
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (v) => category = v ?? category,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
                      const Spacer(),
                      SizedBox(
                        width: 140,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () async {
                            final raw = namesCtrl.text.trim();
                            if (raw.isEmpty) {
                              Get.snackbar('Required', 'Please enter at least one skill');
                              return;
                            }
                            final names = raw.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
                            await controller.saveSkills({
                              'skillCategory': category,
                              'skills': names,
                            });
                            Get.back();
                          },
                          child: const Text('Save Changes'),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          isScrollControlled: true,
        );
      },
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
