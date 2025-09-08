import 'dart:ui';

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
        final List<Map<String, dynamic>> profiles = controller.onlineProfileList
            .map(
              (p) => {
                'id': p.id,
                'platformType': () {
                  final v = (p.platformType ?? '').toLowerCase();
                  if (v.contains('linkedin')) return 'LinkedIn';
                  if (v.contains('github')) return 'GitHub';
                  if (v.contains('behance') || v.contains('be')) {
                    return 'Behance';
                  }
                  if (v.contains('website') || v.contains('web')) {
                    return 'Website';
                  }
                  return (p.platformType ?? 'Other').isEmpty
                      ? 'Other'
                      : p.platformType!;
                }(),
                'profileUrl': p.profileUrl ?? '',
              },
            )
            .toList();

        Get.bottomSheet(
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: StatefulBuilder(
              builder: (context, setSheetState) {
                final formKey = GlobalKey<FormState>();
                bool isValidForPlatform(String platform, String url) {
                  final u = Uri.tryParse(url.trim());
                  if (u == null ||
                      !(u.scheme == 'http' || u.scheme == 'https') ||
                      u.host.isEmpty) {
                    return false;
                  }
                  final host = u.host.toLowerCase();
                  final p = platform.toLowerCase();
                  if (p.contains('github')) {
                    return host.endsWith('github.com');
                  }
                  if (p.contains('linkedin')) {
                    return host.endsWith('linkedin.com') ||
                        host.endsWith('lnkd.in');
                  }
                  if (p.contains('behance') || p.contains('be')) {
                    return host.endsWith('behance.net');
                  }
                  // Website/Other allow any domain
                  return true;
                }

                // Dynamic sheet height state
                double sheetHeight = profiles.isEmpty
                    ? MediaQuery.of(context).size.height *
                          0.28 // Collapsed height
                    : MediaQuery.of(context).size.height *
                          0.55; // Expanded height

                void addProfile() {
                  setSheetState(() {
                    profiles.add({
                      'id': null,
                      'platformType': 'GitHub',
                      'profileUrl': '',
                    });
                    // Expand sheet only when adding the first profile
                    if (profiles.length == 1) {
                      sheetHeight = MediaQuery.of(context).size.height * 0.7;
                    }
                  });
                }

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: sheetHeight,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Scrollable content
                      Container(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 16,
                          bottom: 12,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CommonText(
                              'Online Profiles',
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                            const SizedBox(height: 6),
                            const CommonText(
                              'Add your social media and professional profiles',
                              color: AppColors.textSecondaryColor,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 12),

                                // Profile cards
                                for (int i = 0; i < profiles.length; i++) ...[
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(0xFFE6E9EF),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: CommonText(
                                                profiles[i]['id'] != null
                                                    ? 'Edit Profile ${i + 1}'
                                                    : 'New Profile ${i + 1}',
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () => controller
                                                  .deleteOnlineProfile(
                                                    profiles[i]['id'],
                                                  ),
                                              icon: const Icon(
                                                Icons.delete_outline,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        DropdownButtonFormField<String>(
                                          isExpanded: true,
                                          initialValue:
                                              profiles[i]['platformType'],
                                          decoration: InputDecoration(
                                            labelText: 'Platform Type *',
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                          items:
                                              const [
                                                    'GitHub',
                                                    'LinkedIn',
                                                    'Behance',
                                                  ]
                                                  .map(
                                                    (e) => DropdownMenuItem(
                                                      value: e,
                                                      child: Text(e),
                                                    ),
                                                  )
                                                  .toList(),
                                          onChanged: (v) => setSheetState(() {
                                            profiles[i]['platformType'] = v;
                                            formKey.currentState?.validate();
                                          }),
                                        ),
                                        const SizedBox(height: 18),
                                        TextFormField(
                                          keyboardType: TextInputType.url,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          onChanged: (v) => setSheetState(() {
                                            profiles[i]['profileUrl'] = v;
                                          }),
                                          controller:
                                              TextEditingController(
                                                  text:
                                                      profiles[i]['profileUrl'],
                                                )
                                                ..selection =
                                                    TextSelection.fromPosition(
                                                      TextPosition(
                                                        offset:
                                                            (profiles[i]['profileUrl']
                                                                    as String)
                                                                .length,
                                                      ),
                                                    ),
                                          decoration: InputDecoration(
                                            labelText: 'Profile URL *',
                                            hintText: 'https://...',
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                          validator: (value) {
                                            final url = (value ?? '').trim();
                                            if (url.isEmpty) {
                                              return 'URL is required';
                                            }
                                            final platform =
                                                (profiles[i]['platformType']
                                                    as String?) ??
                                                'Other';
                                            if (!isValidForPlatform(
                                              platform,
                                              url,
                                            )) {
                                              if (platform
                                                  .toLowerCase()
                                                  .contains('github')) {
                                                return 'Enter a Valid GitHub URL';
                                              }
                                              if (platform
                                                  .toLowerCase()
                                                  .contains('linkedin')) {
                                                return 'Enter a Valid LinkedIn URL';
                                              }
                                              if (platform
                                                      .toLowerCase()
                                                      .contains('behance') ||
                                                  platform
                                                      .toLowerCase()
                                                      .contains('be')) {
                                                return 'Enter a Valid Behance URL';
                                              }
                                              return 'Enter a valid URL';
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                ],

                                Align(
                                  alignment: Alignment.centerRight,
                                  child: OutlinedButton(
                                    onPressed: addProfile,
                                    child: const CommonText(
                                      'Add profile',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Fixed footer
                      Container(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              offset: const Offset(0, -1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () async {
                                // Validate form before proceeding
                                if (!(formKey.currentState?.validate() ??
                                    false)) {
                                  return;
                                }
                                // Build a map of existing platform -> id (normalized)
                                final existing = <String, dynamic>{};
                                for (final item
                                    in controller.onlineProfileList) {
                                  final plat = (item.platformType ?? '')
                                      .toLowerCase();
                                  if (plat.isEmpty) continue;
                                  existing[plat] = item.id;
                                }

                                // Ensure only one entry per platform (last one wins)
                                final seen = <String>{};
                                for (final p in profiles) {
                                  final url =
                                      (p['profileUrl'] as String?)?.trim() ??
                                      '';
                                  if (url.isEmpty) continue;
                                  final platNorm =
                                      ((p['platformType'] as String?) ??
                                              'Other')
                                          .toLowerCase();
                                  if (seen.contains(platNorm)) {
                                    continue; // skip duplicates
                                  }
                                  seen.add(platNorm);
                                  await controller.saveOnlineProfiles({
                                    'id':
                                        existing[platNorm], // upsert to existing if present
                                    'platformType': p['platformType'],
                                    'profileUrl': url,
                                  });
                                }
                                // Close once after processing all entries
                                if (Get.isOverlaysOpen) Get.back();
                              },
                              child: const CommonText(
                                'Save',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          isScrollControlled: true,
        );
      },
      child: Obx(() {
        final items = controller.onlineProfileList;
        // Single source of truth: only backend items are displayed
        if (items.isEmpty) {
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
          if (p.contains('behance') || p.contains('be')) {
            return const Color(0xFF1769FF);
          }
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
            for (int i = 0; i < items.length; i++) ...[
              _ProfileItemCard(
                color: colorFor(items[i].platformType),
                label: labelFor(items[i].platformType),
                url: items[i].profileUrl ?? '-',
                icon: iconFor(items[i].platformType),
              ),
              if (i != items.length - 1) const SizedBox(height: 12),
            ],
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
                CommonText(label, fontSize: 15, fontWeight: FontWeight.w800),
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
