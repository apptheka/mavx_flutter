import 'package:flutter/material.dart';
import 'package:mavx_flutter/app/core/constants/assets.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/profile_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/widgets/section_card.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';
import 'package:get/get.dart';

class ProfileOnlineProfiles extends StatelessWidget {
  final ProfileController controller;
  const ProfileOnlineProfiles({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Online Profiles',
      subtitle: 'Showcase your presence across professional platforms',
      onEdit: () {
        // Prefill from first available profile (LinkedIn from registered or existing list)
        String? prePlatform;
        String? preUrl;
        final linkedIn = controller.registeredProfile.value.linkedin;
        if (linkedIn != null && linkedIn.trim().isNotEmpty) {
          prePlatform = 'LinkedIn';
          preUrl = linkedIn;
        } else if (controller.onlineProfileList.isNotEmpty) {
          final first = controller.onlineProfileList.first;
          prePlatform = () {
            final p = (first.platformType ?? '').toLowerCase();
            if (p.contains('linkedin')) return 'LinkedIn';
            if (p.contains('github')) return 'GitHub';
            if (p.contains('behance') || p.contains('be')) return 'Behance';
            if (p.contains('website') || p.contains('web')) return 'Website';
            return 'Other';
          }();
          preUrl = first.profileUrl;
        }

        String platform = prePlatform ?? 'GitHub';
        final urlCtrl = TextEditingController(text: preUrl ?? '');
        Get.bottomSheet(
          SafeArea(
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
                    const CommonText('Online Profiles', fontSize: 18, fontWeight: FontWeight.w800),
                    const SizedBox(height: 6),
                    const CommonText('Add your social media and professional profiles', color: AppColors.textSecondaryColor),
                    const SizedBox(height: 12),
                    const CommonText('Platform Type *', fontWeight: FontWeight.w700),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(color: const Color(0xFFF5F6FA), borderRadius: BorderRadius.circular(12)),
                      child: DropdownButton<String>(
                        value: platform,
                        isExpanded: true,
                        underline: const SizedBox.shrink(),
                        items: const ['GitHub','LinkedIn','Behance','Website','Other']
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (v) => platform = v ?? platform,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const CommonText('Profile URL *', fontWeight: FontWeight.w700),
                    const SizedBox(height: 6),
                    TextField(
                      controller: urlCtrl,
                      keyboardType: TextInputType.url,
                      decoration: InputDecoration(
                        hintText: 'https://...',
                        filled: true,
                        fillColor: const Color(0xFFF5F6FA),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(children: [
                      TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
                      const Spacer(),
                      SizedBox(
                        width: 140,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () async {
                            final url = urlCtrl.text.trim();
                            if (url.isEmpty) {
                              Get.snackbar('Required', 'Profile URL is required');
                              return;
                            }
                            await controller.saveOnlineProfiles({
                              'platformType': platform,
                              'profileUrl': url,
                            });
                            Get.back();
                          },
                          child: const Text('Save Changes'),
                        ),
                      ),
                    ])
                  ],
                ),
              ),
            ),
          ),
          isScrollControlled: true,
        );
      },
      child: Obx(() {
        final items = controller.onlineProfileList;
        final linkedIn = controller.registeredProfile.value.linkedin;
        
        // Create combined list with LinkedIn from registeredProfile if available
        final allProfiles = <Map<String, dynamic>>[];
        
        // Add LinkedIn from registeredProfile if available
        if (linkedIn != null && linkedIn.trim().isNotEmpty) {
          allProfiles.add({
            'platformType': 'linkedin',
            'profileUrl': linkedIn,
          });
        }
        
        // Add other profiles from onlineProfileList
        for (final item in items) {
          allProfiles.add({
            'platformType': item.platformType,
            'profileUrl': item.profileUrl,
          });
        }
        
        if (allProfiles.isEmpty) {
          return const Text(
            'No online profiles added yet.',
            style: TextStyle(color: AppColors.textSecondaryColor),
          );
        }
        
        String iconFor(String? platform) {
          final p = (platform ?? '').toLowerCase();
          if (p.contains('linkedin')) return IconAssets.linkedin;
          if (p.contains('github')) return IconAssets.github;
          if (p.contains('behance') || p.contains('be')) return IconAssets.be;
          if (p.contains('website') || p.contains('web')) return IconAssets.web;
          return IconAssets.web;
        }
        Color colorFor(String? platform) {
          final p = (platform ?? '').toLowerCase();
          if (p.contains('linkedin')) return const Color(0xFF0A66C2);
          if (p.contains('github')) return const Color(0xFF181717);
          if (p.contains('behance') || p.contains('be')) return const Color(0xFF1769FF);
          return AppColors.textPrimaryColor;
        }
        String labelFor(String? platform) {
          final p = (platform ?? '').toLowerCase();
          if (p.contains('linkedin')) return 'LinkedIn';
          if (p.contains('github')) return 'Github';
          if (p.contains('behance') || p.contains('be')) return 'Behance';
          if (p.contains('website') || p.contains('web')) return 'Website';
          return platform ?? 'Profile';
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < allProfiles.length; i++) ...[
              _ProfileItemCard(
                color: colorFor(allProfiles[i]['platformType']),
                label: labelFor(allProfiles[i]['platformType']),
                url: allProfiles[i]['profileUrl'] ?? '-',
                icon: iconFor(allProfiles[i]['platformType']),
              ),
              if (i != allProfiles.length - 1) const SizedBox(height: 12),
            ]
          ],
        );
      }),
    );
  }
}

class _ProfileItemCard extends StatelessWidget {
  final String label;
  final String url;
  final Color color;
  final String icon;
  const _ProfileItemCard({
    required this.label,
    required this.url,
    required this.color,
    required this.icon,
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(icon, height: 24, width: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  label,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
                const SizedBox(height: 2),
                CommonText(
                  url,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textButtonColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
