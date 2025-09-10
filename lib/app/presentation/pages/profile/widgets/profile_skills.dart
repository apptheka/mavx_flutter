import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/profile_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/widgets/section_card.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';

class ProfileSkills extends StatelessWidget {
  final ProfileController controller;
  const ProfileSkills({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Key Skills',
      subtitle: 'Highlight your strongest areas of expertise',
      onEdit: () {
        // persist across sheet rebuilds
        String category = 'Technical';
        final TextEditingController inputCtrl = TextEditingController();

        // Flatten existing comma-separated skills into individual tokens
        final List<String> skills = [];
        for (final skill in controller.skillList) {
          final raw = (skill.skillName ?? '').trim();
          if (raw.isNotEmpty) {
            final parts = raw.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty);
            skills.addAll(parts);
          }
        }

        // util: add tokens -> chips
        void addTokens(String raw, void Function(VoidCallback) setSheetState) {
          final parts = raw
              .split(RegExp(r'[,\n]+'))
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();
          if (parts.isEmpty) return;

          setSheetState(() {
            for (final p in parts) {
              // de-dup (case-insensitive)
              final exists = skills.any(
                (s) => s.toLowerCase() == p.toLowerCase(),
              );
              if (!exists) skills.add(p);
            }
          });
        }

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
                child: StatefulBuilder(
                  builder: (context, setSheetState) {
                    void flushInput() {
                      final raw = inputCtrl.text;
                      inputCtrl.clear();
                      addTokens(raw, setSheetState);
                    }
              
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonText('Skills', fontSize: 20, fontWeight: FontWeight.w800),
                                  SizedBox(height: 4),
                                  CommonText('Add your professional skills - separate multiple skills with commas',
                                      color: AppColors.textSecondaryColor),
                                ],
                              ),
                            ),
                            IconButton(onPressed: Get.back, icon: const Icon(Icons.close))
                          ],
                        ),
                        const SizedBox(height: 12),
              
                        // Input + Add button
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F6FA),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE6E9EF)),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonText(
                                'Skill Names *',
                                fontWeight: FontWeight.w700,
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: inputCtrl,
                                      textInputAction: TextInputAction.done,
                                      // ENTER -> add remaining buffer
                                      onSubmitted: (_) => flushInput(),
                                      // COMMA -> turn tokens before the last comma into chips
                                      onChanged: (val) {
                                        if (val.contains(',')) {
                                          final chunks = val.split(',');
                                          final tail = chunks.removeLast();
                                          addTokens(
                                            chunks.join(','),
                                            setSheetState,
                                          );
                                          // keep the last fragment in the field
                                          inputCtrl
                                            ..text = tail.trimLeft()
                                            ..selection =
                                                TextSelection.fromPosition(
                                                  TextPosition(
                                                    offset: inputCtrl.text.length,
                                                  ),
                                                );
                                        }
                                      },
                                      inputFormatters: [
                                        // prevent actual newlines in the field; we handle Enter via onSubmitted
                                        FilteringTextInputFormatter.deny(
                                          RegExp(r'\n'),
                                        ),
                                      ],
                                      decoration: InputDecoration(
                                        hintText: 'e.g., JavaScript, React',
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  OutlinedButton(
                                    onPressed: flushInput,
                                    child: const Text('Add Skill'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
              
                              // Chips with delete
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  for (int i = 0; i < skills.length; i++)
                                    Chip(
                                      label: Text(skills[i]),
                                      onDeleted: () => setSheetState(() {
                                        skills.removeAt(i);
                                      }),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              CommonText(
                                'Tip: Type a skill and press comma or Enter to add it. You can also paste a list separated by commas.',
                                color: AppColors.textSecondaryColor,
                                fontSize: 12,
                              ),
                            ],
                          ),
                        ),
              
                        const SizedBox(height: 12),
                        CommonText(
                          'Skill Category *',
                          fontWeight: FontWeight.w700,
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F6FA),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButton<String>(
                            value: category,
                            isExpanded: true,
                            underline: const SizedBox.shrink(),
                            items: const ['Technical', 'Soft', 'Other']
                                .map(
                                  (e) =>
                                      DropdownMenuItem(value: e, child: Text(e)),
                                )
                                .toList(),
                            onChanged: (v) => setSheetState(() {
                              category = v ?? category;
                            }),
                          ),
                        ),
                        const SizedBox(height: 14),
              
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 140,
                              height: 44,
                              child: OutlinedButton(
                                onPressed: () => Get.back(),
                                child: CommonText('Cancel', fontWeight: FontWeight.w700),
                              ),
                            ),
                            SizedBox(
                              width: 160,
                              height: 44,
                              child: ElevatedButton(
                                onPressed: () async {
                                  flushInput(); // capture anything left in the field
                                  if (skills.isEmpty) {
                                    Get.snackbar(
                                      'Required',
                                      'Please enter at least one skill',
                                    );
                                    return;
                                  }
                                  // Merge into an existing record if present
                                  final existingId = controller.skillList.isNotEmpty
                                      ? controller.skillList.first.id
                                      : null;
                                  await controller.saveSkills({
                                    'id': existingId,
                                    'skill_category': category,
                                    // Send as a single comma-separated string to update same row
                                    'skill_name': skills.join(', '),
                                    // Do NOT send the bulk list to prevent new rows
                                  });
                                  Get.back();
                                },
                                child: CommonText('Save Changes', fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ],
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
        final skills = controller.skillList;
        if (skills.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: CommonText(
              'No skills added yet.',
              color: AppColors.textSecondaryColor,
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
        // Flatten skills: if any skill_name contains commas, split into individual tags
        final List<String> flat = [];
        for (final s in skills) {
          final raw = (s.skillName ?? '').trim();
          if (raw.isEmpty) continue;
          final parts = raw
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();
          flat.addAll(parts);
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (int i = 0; i < flat.length; i++)
                    _Chip(
                      text: flat[i],
                      bgColor: chipColors[i % chipColors.length],
                    ),
                ],
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
  const _Chip({required this.text, this.bgColor = const Color(0xFFEFF4F8)});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: CommonText(
        text,
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
    );
  }
}
