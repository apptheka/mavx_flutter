import 'package:flutter/material.dart';
import 'package:mavx_flutter/app/core/constants/image_assets.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/profile_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/widgets/section_card.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:get/get.dart';

class ProfileExperience extends StatelessWidget {
  final ProfileController controller;
  const ProfileExperience({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Experience',
      subtitle: "Where you've worked and what you achieved",
      onEdit: () {
        final first = controller.experienceList.isNotEmpty ? controller.experienceList.first : null;
        final companyCtrl = TextEditingController(text: first?.companyName ?? '');
        final roleCtrl = TextEditingController(text: first?.role ?? '');
        final descCtrl = TextEditingController(text: first?.description ?? '');
        String employmentType = (first?.employmentType ?? 'Full Time');
        bool remote = (first?.isRemote ?? 0) == 1;
        bool current = (first?.isCurrent ?? 0) == 1;
        final startCtrl = TextEditingController(text: first?.startDate != null ?
            '${first!.startDate!.year.toString().padLeft(4, '0')}-${first.startDate!.month.toString().padLeft(2, '0')}-${first.startDate!.day.toString().padLeft(2, '0')}' : '');
        // End date optional; add when you add that field to the UI
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
                    const Text(
                      'Work Experience',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Add your professional experience',
                      style: TextStyle(color: AppColors.textSecondaryColor),
                    ),
                    const SizedBox(height: 12),
                    _label('Company Name *'),
                    _field(companyCtrl, hint: 'Company Name'),
                    const SizedBox(height: 10),
                    _label('Job Title *'),
                    _field(roleCtrl, hint: 'Job Title'),
                    const SizedBox(height: 10),
                    _label('Employment Type *'),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F6FA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButton<String>(
                        value: employmentType,
                        isExpanded: true,
                        underline: const SizedBox.shrink(),
                        items:
                            const [
                                  'Full Time',
                                  'Part Time',
                                  'Contract',
                                  'Internship',
                                ]
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                        onChanged: (v) => employmentType = v ?? employmentType,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        StatefulBuilder(
                          builder: (context, setState) {
                            return Checkbox(
                              value: remote,
                              onChanged: (v) =>
                                  setState(() => remote = v ?? false),
                            );
                          },
                        ),
                        const Text('Remote Work'),
                      ],
                    ),
                    const SizedBox(height: 6),
                    _label('Start Date *'),
                    _field(startCtrl, hint: 'YYYY-MM-DD'),
                    Row(
                      children: [
                        StatefulBuilder(
                          builder: (context, setState) {
                            return Checkbox(
                              value: current,
                              onChanged: (v) =>
                                  setState(() => current = v ?? false),
                            );
                          },
                        ),
                        const Text('Currently working here'),
                      ],
                    ),
                    _label('Job Description *'),
                    _field(descCtrl, hint: 'Describe your work', maxLines: 4),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text('Cancel'),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 140,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (companyCtrl.text.trim().isEmpty ||
                                  roleCtrl.text.trim().isEmpty ||
                                  startCtrl.text.trim().isEmpty ||
                                  descCtrl.text.trim().isEmpty) {
                                Get.snackbar(
                                  'Required',
                                  'Please fill all required fields',
                                );
                                return;
                              }

                              final payload = {
                                'companyName': companyCtrl.text.trim(),
                                'role': roleCtrl.text.trim(),
                                'employmentType': employmentType,
                                'isRemote': remote ? 1 : 0,
                                'startDate': startCtrl.text.trim(),
                                'isCurrent': current ? 1 : 0,
                                'description': descCtrl.text.trim(),
                              };
                              await controller.saveExperience(payload);
                              Get.back();
                            },
                            child: const Text('Save Changes'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          isScrollControlled: true,
        );
      },
      child: Obx(() {
        final exps = controller.experienceList;
        if (exps.isEmpty) {
          return const Text(
            'No experience added yet.',
            style: TextStyle(color: AppColors.textSecondaryColor),
          );
        }
        Color startFor(int i) => [
          const Color(0xFF7C3AED),
          const Color(0xFF0EA5E9),
          const Color(0xFF10B981),
          const Color(0xFFF59E0B),
        ][i % 4];
        Color endFor(int i) => [
          const Color(0xFF4F46E5),
          const Color(0xFF2563EB),
          const Color(0xFF059669),
          const Color(0xFFD97706),
        ][i % 4];
        String fmt(DateTime? d) {
          if (d == null) return '';
          const months = [
            'Jan',
            'Feb',
            'Mar',
            'Apr',
            'May',
            'Jun',
            'Jul',
            'Aug',
            'Sep',
            'Oct',
            'Nov',
            'Dec',
          ];
          return '${months[d.month - 1]} ${d.year}';
        }

        return Column(
          children: [
            for (int i = 0; i < exps.length; i++) ...[
              _ExperienceItem(
                iconAsset: i % 2 == 0 ? ImageAssets.ex2 : ImageAssets.ex1,
                role: exps[i].role ?? '-',
                company: exps[i].companyName ?? '-',
                employmentType: exps[i].employmentType ?? '-',
                period: () {
                  final s = fmt(exps[i].startDate);
                  final e = exps[i].isCurrent == 1
                      ? 'Present'
                      : fmt(exps[i].endDate);
                  if (s.isEmpty && (e.isEmpty || e == 'Present')) return '-';
                  return [s, e].where((x) => x.isNotEmpty).join(' - ');
                }(),
                summary: exps[i].description?.trim().isNotEmpty == true
                    ? exps[i].description!.trim()
                    : '-',
                gradientStart: startFor(i),
                gradientEnd: endFor(i),
              ),
              if (i != exps.length - 1) const SizedBox(height: 12),
            ],
          ],
        );
      }),
    );
  }
}

// Helpers for bottom sheet inputs
Widget _label(String text) => Padding(
  padding: const EdgeInsets.only(bottom: 6),
  child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
);

Widget _field(TextEditingController ctrl, {String? hint, int maxLines = 1}) =>
    TextField(
      controller: ctrl,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF5F6FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );

class _ExperienceItem extends StatelessWidget {
  final String role;
  final String company;
  final String employmentType;
  final String period;
  final String summary;
  final Color gradientStart;
  final Color gradientEnd;
  final String iconAsset;
  const _ExperienceItem({
    required this.iconAsset,
    required this.role,
    required this.company,
    required this.employmentType,
    required this.period,
    required this.summary,
    this.gradientStart = const Color(0xFF7C3AED),
    this.gradientEnd = const Color(0xFF4F46E5),
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
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [gradientStart, gradientEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    iconAsset,
                    // Remove tint so original colors show; rely on gradient for contrast
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      role,
                      style: const TextStyle(
                        color: AppColors.textPrimaryColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      company,
                      style: const TextStyle(
                        color: AppColors.textSecondaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$employmentType • $period',
                      style: const TextStyle(
                        color: AppColors.textSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ],
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$summary',
                  style: const TextStyle(color: AppColors.textSecondaryColor),
                ),
                const TextSpan(
                  text: 'Read More',
                  style: TextStyle(
                    color: AppColors.textButtonColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
