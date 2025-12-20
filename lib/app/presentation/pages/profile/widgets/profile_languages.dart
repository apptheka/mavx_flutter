import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/profile_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/widgets/section_card.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';

class ProfileLanguages extends StatelessWidget {
  final ProfileController controller;
  const ProfileLanguages({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Languages',
      subtitle: "Languages you're fluent in for communication",
      onEdit: () {
        // Manage multiple languages with add/edit functionality
        final List<Map<String, dynamic>> languages = controller.languageList
            .map((lang) => {
                  'id': lang.id,
                  'languageName': lang.languageName ?? '',
                  'proficiencyLevel': () {
                    final v = (lang.proficiencyLevel ?? 'Beginner').toString();
                    final cap = v.isEmpty ? 'Beginner' : v[0].toUpperCase() + v.substring(1).toLowerCase();
                    const allowed = ['Beginner','Intermediate','Advanced','Native'];
                    return allowed.contains(cap) ? cap : 'Beginner';
                  }(),
                  'canRead': (lang.canRead ?? 1) == 1,
                  'canWrite': (lang.canWrite ?? 0) == 1,
                  'canSpeak': (lang.canSpeak ?? 1) == 1,
                })
            .toList();
        Get.bottomSheet(
          SafeArea(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  // Allow content to size naturally but cap at 70% of screen height
                  maxHeight: MediaQuery.of(context).size.height * 0.7,
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: StatefulBuilder(
                    builder: (context, setSheetState) {
                      void addNewLanguage() {
                        setSheetState(() {
                          languages.add({
                            'id': null,
                            'languageName': '',
                            'proficiencyLevel': 'Beginner',
                            'canRead': true,
                            'canWrite': false,
                            'canSpeak': true,
                          });
                        });
                      }
                 
                    
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CommonText('Languages', fontWeight: FontWeight.w800, fontSize: 20),
                            const SizedBox(height: 6),
                            const CommonText('Add languages', color: AppColors.textSecondaryColor, fontSize: 15),
                            const SizedBox(height: 12),
                            
                            // Show existing languages for editing
                            if (languages.isNotEmpty) ...[ 
                              for (int i = 0; i < languages.length; i++) ...[
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
                                              languages[i]['id'] != null 
                                                  ? 'Edit Language ${i + 1}' 
                                                  : 'New Language ${i + 1}',
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () =>  controller.deleteLanguage(languages[i]['id']),
                                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      TextField(
                                        onChanged: (v) => setSheetState(() => languages[i]['languageName'] = v),
                                        controller: TextEditingController(text: languages[i]['languageName'])
                                          ..selection = TextSelection.fromPosition(
                                              TextPosition(offset: languages[i]['languageName'].length)),
                                        decoration: InputDecoration(
                                          hintText: 'e.g., English',
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        decoration: BoxDecoration(
                                            color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                        child: DropdownButton<String>(
                                          value: languages[i]['proficiencyLevel'],
                                          isExpanded: true,
                                          underline: const SizedBox.shrink(),
                                          items: const ['Beginner', 'Intermediate', 'Advanced', 'Native']
                                              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                              .toList(),
                                          onChanged: (v) => setSheetState(() => languages[i]['proficiencyLevel'] = v ?? 'Beginner'),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Wrap(
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Checkbox(
                                                value: languages[i]['canRead'],
                                                onChanged: (v) => setSheetState(() => languages[i]['canRead'] = v ?? false),
                                              ),
                                              const CommonText('Can Read', fontSize: 14),
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Checkbox(
                                                value: languages[i]['canWrite'],
                                                onChanged: (v) => setSheetState(() => languages[i]['canWrite'] = v ?? false),
                                              ),
                                              const CommonText('Can Write', fontSize: 14),
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Checkbox(
                                                value: languages[i]['canSpeak'],
                                                onChanged: (v) => setSheetState(() => languages[i]['canSpeak'] = v ?? false),
                                              ),
                                              const CommonText('Can Speak', fontSize: 14),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                              ],
                            ],
                            
                            // Add new language button
                            Align(
                              alignment: Alignment.centerRight,
                              child: OutlinedButton.icon(
                                onPressed: addNewLanguage,
                                icon: const Icon(Icons.add),
                                label: const CommonText('Add Language', fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                            ),
                            
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [ 
                                const SizedBox(width: 16),
                                SizedBox(
                                  width: 140,
                                  height: 48,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryColor,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                    ),
                                    onPressed: () async {
                                      // Save all languages
                                      for (final lang in languages) {
                                        final name = (lang['languageName'] as String).trim();
                                        if (name.isEmpty) continue;
                                        
                                        await controller.saveLanguages({
                                          'id': lang['id'],
                                          'language_name': name,
                                          'proficiency_level': lang['proficiencyLevel'],
                                          'can_read': lang['canRead'] ? 1 : 0,
                                          'can_write': lang['canWrite'] ? 1 : 0,
                                          'can_speak': lang['canSpeak'] ? 1 : 0,
                                        });
                                      }
                                      Get.back();
                                    },
                                    child: const CommonText('Save' , fontWeight: FontWeight.w700, color: AppColors.white, fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          isScrollControlled: true,
        );
      },
      child: Obx(() {
        final langs = controller.languageList;
        if (langs.isEmpty) {
          return const CommonText(
            'No languages added yet.',
            fontSize: 14,
            color: AppColors.textSecondaryColor,
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
          CommonText(
            title,
            color: AppColors.textPrimaryColor,
            fontWeight: FontWeight.w800,
          ),
          const SizedBox(height: 4),
          CommonText(
            details,
            color: AppColors.textSecondaryColor,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
