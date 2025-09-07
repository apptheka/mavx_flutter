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
        // Build editable list from existing items
        final List<Map<String, dynamic>> profiles = controller.onlineProfileList
            .map((p) => {
                  'id': p.id,
                  'platformType': () {
                    final v = (p.platformType ?? '').toLowerCase();
                    if (v.contains('linkedin')) return 'LinkedIn';
                    if (v.contains('github')) return 'GitHub';
                    if (v.contains('behance') || v.contains('be')) return 'Behance';
                    if (v.contains('website') || v.contains('web')) return 'Website';
                    return (p.platformType ?? 'Other').isEmpty ? 'Other' : p.platformType!;
                  }(),
                  'profileUrl': p.profileUrl ?? '',
                })
            .toList(); 

        const allowedPlatforms = ['GitHub', 'LinkedIn', 'Behance', 'Website', 'Other'];
        Get.bottomSheet(
          SafeArea(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: StatefulBuilder(
                  builder: (context, setSheetState) {
                    void addProfile() {
                      setSheetState(() {
                        profiles.add({'id': null, 'platformType': 'GitHub', 'profileUrl': ''});
                      });
                    }
               
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CommonText('Online Profiles', fontSize: 18, fontWeight: FontWeight.w800),
                          const SizedBox(height: 6),
                          const CommonText('Add your social media and professional profiles', color: AppColors.textSecondaryColor),
                          const SizedBox(height: 12),
              
                          for (int i = 0; i < profiles.length; i++) ...[
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F6FA),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFE6E9EF)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CommonText(
                                          profiles[i]['id'] != null ? 'Edit Profile ${i + 1}' : 'New Profile ${i + 1}',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () =>  controller.deleteOnlineProfile(profiles[i]['id']),
                                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    value: allowedPlatforms.contains(profiles[i]['platformType'])
                                        ? profiles[i]['platformType']
                                        : 'Other',
                                    decoration: InputDecoration(
                                      labelText: 'Platform Type *',
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    items: allowedPlatforms
                                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                        .toList(),
                                    onChanged: (v) => setSheetState(() => profiles[i]['platformType'] = v ?? 'Other'),
                                  ),
                                  const SizedBox(height: 8),
                                  TextField(
                                    keyboardType: TextInputType.url,
                                    onChanged: (v) => setSheetState(() => profiles[i]['profileUrl'] = v),
                                    controller: TextEditingController(text: profiles[i]['profileUrl'])
                                      ..selection = TextSelection.fromPosition(
                                        TextPosition(offset: (profiles[i]['profileUrl'] as String).length),
                                      ),
                                    decoration: InputDecoration(
                                      labelText: 'Profile URL *',
                                      hintText: 'https://...',
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
              
                          OutlinedButton(
                            onPressed: addProfile,
                            child: const CommonText('Add profile', fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [ 
                              SizedBox(
                                width: 160,
                                height: 48,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  onPressed: () async {
                                    // Build a map of existing platform -> id (normalized)
                                    final existing = <String, dynamic>{};
                                    for (final item in controller.onlineProfileList) {
                                      final plat = (item.platformType ?? '').toLowerCase();
                                      if (plat.isEmpty) continue;
                                      existing[plat] = item.id;
                                    }
              
                                    // Ensure only one entry per platform (last one wins)
                                    final seen = <String>{};
                                    for (final p in profiles) {
                                      final url = (p['profileUrl'] as String).trim();
                                      if (url.isEmpty) continue;
                                      final platNorm = (p['platformType'] as String).toLowerCase();
                                      if (seen.contains(platNorm)) continue; // skip duplicates
                                      seen.add(platNorm);
                                      await controller.saveOnlineProfiles({
                                        'id': existing[platNorm], // upsert to existing if present
                                        'platformType': p['platformType'],
                                        'profileUrl': url,
                                      });
                                    }
                                    Get.back();
                                  },
                                  child: const CommonText('Save Changes', fontSize: 16, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
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
        // Build display list from backend items, optionally include registered LinkedIn only if backend has none
        final allProfiles = <Map<String, dynamic>>[];
        final hasBackendLinkedIn = items.any((e) => (e.platformType ?? '').toLowerCase().contains('linkedin'));
        // Add backend items first (source of truth)
        for (final item in items) {
          allProfiles.add({
            'platformType': item.platformType,
            'profileUrl': item.profileUrl,
          });
        }
        // Add registered LinkedIn only if backend does not already have it
        if (!hasBackendLinkedIn && linkedIn != null && linkedIn.trim().isNotEmpty) {
          allProfiles.add({
            'platformType': 'linkedin',
            'profileUrl': linkedIn,
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
