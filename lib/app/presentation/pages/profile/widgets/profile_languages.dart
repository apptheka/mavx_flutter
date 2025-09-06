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
      onEdit: () {
        // Prefill from first language if available
        final first = controller.languageList.isNotEmpty ? controller.languageList.first : null;
        final nameCtrl = TextEditingController(text: first?.languageName ?? '');
        String level = () {
          final v = (first?.proficiencyLevel ?? 'Beginner').toString();
          // Normalize values like 'beginner' to 'Beginner'
          final cap = v.isEmpty ? 'Beginner' : v[0].toUpperCase() + v.substring(1).toLowerCase();
          const allowed = ['Beginner','Intermediate','Advanced','Native'];
          return allowed.contains(cap) ? cap : 'Beginner';
        }();
        bool canRead = (first?.canRead ?? 1) == 1;
        bool canWrite = (first?.canWrite ?? 0) == 1;
        bool canSpeak = (first?.canSpeak ?? 1) == 1;
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
                    const Text('Languages', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 6),
                    const Text('Add languages you speak', style: TextStyle(color: AppColors.textSecondaryColor)),
                    const SizedBox(height: 12),
                    const Text('Language *', style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: nameCtrl,
                      decoration: InputDecoration(
                        hintText: 'e.g., English',
                        filled: true,
                        fillColor: const Color(0xFFF5F6FA),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text('Proficiency Level *', style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(color: const Color(0xFFF5F6FA), borderRadius: BorderRadius.circular(12)),
                      child: DropdownButton<String>(
                        value: level,
                        isExpanded: true,
                        underline: const SizedBox.shrink(),
                        items: const ['Beginner', 'Intermediate', 'Advanced', 'Native']
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (v) => level = v ?? level,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(children: [
                      StatefulBuilder(builder: (context, setState) {
                        return Checkbox(value: canRead, onChanged: (v) => setState(() => canRead = v ?? false));
                      }),
                      const Text('Can Read'),
                      const SizedBox(width: 12),
                      StatefulBuilder(builder: (context, setState) {
                        return Checkbox(value: canWrite, onChanged: (v) => setState(() => canWrite = v ?? false));
                      }),
                      const Text('Can Write'),
                      const SizedBox(width: 12),
                      StatefulBuilder(builder: (context, setState) {
                        return Checkbox(value: canSpeak, onChanged: (v) => setState(() => canSpeak = v ?? false));
                      }),
                      const Text('Can Speak'),
                    ]),
                    const SizedBox(height: 14),
                    Row(children: [
                      TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
                      const Spacer(),
                      SizedBox(
                        width: 140,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () async {
                            final name = nameCtrl.text.trim();
                            if (name.isEmpty) {
                              Get.snackbar('Required', 'Language name is required');
                              return;
                            }
                            await controller.saveLanguages({
                              'languageName': name,
                              'proficiencyLevel': level,
                              'canRead': canRead ? 1 : 0,
                              'canWrite': canWrite ? 1 : 0,
                              'canSpeak': canSpeak ? 1 : 0,
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
