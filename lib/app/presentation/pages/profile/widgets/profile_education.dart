import 'package:flutter/material.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/profile_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/widgets/section_card.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:get/get.dart';

class ProfileEducation extends StatelessWidget {
  final ProfileController controller;
  const ProfileEducation({super.key, required this.controller});


  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Education',
      subtitle: 'Your academic and professional learning history',
      onEdit: () {
        final schoolCtrl = TextEditingController();
        final degreeCtrl = TextEditingController();
        final startCtrl = TextEditingController();
        final endCtrl = TextEditingController();
        bool current = false;

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
                    const Text('Education', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 6),
                    const Text('Add your educational background', style: TextStyle(color: AppColors.textSecondaryColor)),
                    const SizedBox(height: 12),
                    const Text('Institution Name *', style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    _field(schoolCtrl, hint: 'Institution Name'),
                    const SizedBox(height: 10),
                    const Text('Degree *', style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    _field(degreeCtrl, hint: 'Degree'),
                    const SizedBox(height: 10),
                    Row(children: [
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('Start Date *', style: TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        _field(startCtrl, hint: 'YYYY-MM-DD'),
                      ])),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('End Date', style: TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        _field(endCtrl, hint: 'YYYY-MM-DD'),
                      ])),
                    ]),
                    const SizedBox(height: 6),
                    StatefulBuilder(builder: (context, setState) {
                      return Row(children: [
                        Checkbox(value: current, onChanged: (v) => setState(() => current = v ?? false)),
                        const Text('Currently studying here'),
                      ]);
                    }),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Get.back(),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (schoolCtrl.text.trim().isEmpty || degreeCtrl.text.trim().isEmpty || startCtrl.text.trim().isEmpty) {
                                Get.snackbar('Required', 'Institution, Degree and Start Date are required');
                                return;
                              }
                              await controller.saveEducation({
                                'institutionName': schoolCtrl.text.trim(),
                                'degree': degreeCtrl.text.trim(),
                                'startDate': startCtrl.text.trim(),
                                'endDate': endCtrl.text.trim(),
                                'isCurrent': current ? 1 : 0,
                              });
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
        final items = controller.educationList;
        if (items.isEmpty) {
          return const Text(
            'No education added yet.',
            style: TextStyle(color: AppColors.textSecondaryColor),
          );
        }
        String yearStr(DateTime? s, DateTime? e, int? isCurrent) {
          String toYear(DateTime? d) => d?.year.toString() ?? '';
          final start = toYear(s);
          final end = (isCurrent == 1) ? 'Present' : toYear(e);
          if (start.isEmpty && (end.isEmpty || end == 'Present')) return '-';
          return [start, end].where((x) => x.isNotEmpty).join('–');
        }
        return Column(
          children: [
            for (int i = 0; i < items.length; i++) ...[
              _EducationItem(
                degree: items[i].degree ?? '-',
                school: items[i].institutionName ?? '-',
                year: yearStr(items[i].startDate, items[i].endDate, items[i].isCurrent),
              ),
              if (i != items.length - 1) const SizedBox(height: 12),
            ]
          ],
        );
      }),
    );
  }


    Widget _field(TextEditingController controller, {String? hint}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF5F6FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }

}

class _EducationItem extends StatelessWidget {
  final String degree;
  final String school;
  final String year;
  const _EducationItem({
    required this.degree,
    required this.school,
    required this.year,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            degree,
            style: const TextStyle(
              color: AppColors.textPrimaryColor,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            school,
            style: const TextStyle(
              color: AppColors.textSecondaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            year,
            style: const TextStyle(
              color: AppColors.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
