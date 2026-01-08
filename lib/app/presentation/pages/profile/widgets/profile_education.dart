import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/profile_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/widgets/date_box.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/widgets/section_card.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';

class ProfileEducation extends StatelessWidget {
  final ProfileController controller;
  const ProfileEducation({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Education',
      subtitle: 'Your academic and professional learning history',
      onEdit: () {
        // Seed editable rows from existing list
        final List<Map<String, dynamic>> rows = controller.educationList
            .map(
              (e) => {
                'id': e.id,
                'institutionName': e.institutionName ?? '',
                'degree': e.degree ?? '',
                'startDate': e.startDate, // DateTime?
                'endDate': e.endDate, // DateTime?
                'isCurrent': (e.isCurrent ?? 0) == 1,
                'isNew': false,
              },
            )
            .toList();

        Get.bottomSheet(
          SafeArea(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  // Let content size naturally but cap at 70% of the screen height
                  maxHeight: MediaQuery.of(context).size.height * 0.7,
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: StatefulBuilder(
                    builder: (context, setSheetState) {
                      void addRow() {
                        setSheetState(() {
                          rows.add({
                            'id': null,
                            'institutionName': '',
                            'degree': '',
                            'startDate': null,
                            'endDate': null,
                            'isCurrent': false,
                            'isNew': true,
                          });
                        });
                      }
            
                      String fmt(DateTime? d) => d == null
                          ? 'Select date'
                          : '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
            
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              'Education',
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                            const SizedBox(height: 6),
                            CommonText(
                              'Add your educational background',
                              color: AppColors.textSecondaryColor,
                            ),
                            const SizedBox(height: 12),
            
                            for (int i = 0; i < rows.length; i++) ...[
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFFE6E9EF),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: CommonText(
                                            rows[i]['id'] != null
                                                ? 'Edit Education ${i + 1} (ID: ${rows[i]['id']})'
                                                : 'New Education ${i + 1}',
                                            fontWeight: FontWeight.w700,
                                            ),
                                          ), 
                                        IconButton(
                                          onPressed: () {
                                            controller.deleteEducation(
                                              rows[i]['id'],
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.delete_outline,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    TextField(
                                      onChanged: (v) => setSheetState(
                                        () => rows[i]['institutionName'] = v,
                                      ),
                                      controller:
                                          TextEditingController(
                                              text: rows[i]['institutionName'],
                                            )
                                            ..selection =
                                                TextSelection.fromPosition(
                                                  TextPosition(
                                                    offset:
                                                        (rows[i]['institutionName']
                                                                as String)
                                                            .length,
                                                  ),
                                                ),
                                      decoration: InputDecoration(
                                        labelText: 'Institution Name *',
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextField(
                                      onChanged: (v) => setSheetState(
                                        () => rows[i]['degree'] = v,
                                      ),
                                      controller:
                                          TextEditingController(
                                              text: rows[i]['degree'],
                                            )
                                            ..selection =
                                                TextSelection.fromPosition(
                                                  TextPosition(
                                                    offset:
                                                        (rows[i]['degree']
                                                                as String)
                                                            .length,
                                                  ),
                                                ),
                                      decoration: InputDecoration(
                                        labelText: 'Degree *',
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CommonText(
                                                'Start Date *',
                                                fontWeight: FontWeight.w700,
                                              ),
                                              const SizedBox(height: 6),
                                              DateBox(
                                                label: fmt(
                                                  rows[i]['startDate']
                                                      as DateTime?,
                                                ),
                                                onTap: () async {
                                                  final picked =
                                                      await showDatePicker(
                                                        context: context,
                                                        initialDate:
                                                            (rows[i]['startDate']
                                                                as DateTime?) ??
                                                            DateTime.now(),
                                                        firstDate: DateTime(
                                                          1950,
                                                        ),
                                                        lastDate: DateTime(
                                                          2100,
                                                        ),
                                                      );
                                                  if (picked != null) {
                                                    setSheetState(
                                                      () =>rows[i]['startDate'] = picked,
                                                    );
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CommonText(
                                                'End Date',
                                                fontWeight: FontWeight.w700,
                                              ),
                                              const SizedBox(height: 6),
                                              DateBox(
                                                label: fmt(
                                                  rows[i]['endDate']
                                                      as DateTime?,
                                                ),
                                                onTap: () async {
                                                  final picked = await showDatePicker(
                                                    context: context,
                                                    initialDate:
                                                        (rows[i]['endDate']
                                                            as DateTime?) ??
                                                        ((rows[i]['startDate']
                                                                as DateTime?) ??
                                                            DateTime.now()),
                                                    firstDate: DateTime(1950),
                                                    lastDate: DateTime(2100),
                                                  );
                                                  if (picked != null) {
                                                    setSheetState(
                                                      () => rows[i]['endDate'] =
                                                          picked,
                                                    );
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: rows[i]['isCurrent'] as bool,
                                          onChanged: (v) => setSheetState(
                                            () => rows[i]['isCurrent'] =
                                                v ?? false,
                                          ),
                                        ),
                                        const CommonText('Currently studying here', fontSize: 14),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
            
                            Align(
                              alignment: Alignment.centerRight,
                              child: OutlinedButton.icon(
                                onPressed: addRow,
                                icon: const Icon(Icons.add),
                                label: const CommonText('Add Education', fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                            ),
            
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end, 
                              children: [
                                SizedBox(
                                  width: 160,
                                  height: 48,
                                  child: Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            40,
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        for (final r in rows) {
                                          final inst =
                                              (r['institutionName'] as String)
                                                  .trim();
                                          final degree = (r['degree'] as String)
                                              .trim();
                                          final s = r['startDate'] as DateTime?;
                                          if (inst.isEmpty ||
                                              degree.isEmpty ||
                                              s == null) {
                                            continue;
                                          }
                                          String fmtOut(DateTime d) =>
                                              '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
                                          // Only create new when explicitly added in this session
                                          if (r['id'] != null ||
                                              (r['isNew'] == true)) {
                                            await controller.saveEducation({
                                              'id': r['id'],
                                              'institution_name': inst,
                                              'degree': degree,
                                              'start_date': fmtOut(s),
                                              'end_date': r['endDate'] != null
                                                  ? fmtOut(
                                                      r['endDate'] as DateTime,
                                                    )
                                                  : '',
                                              'endDate': r['endDate'] != null
                                                  ? fmtOut(
                                                      r['endDate'] as DateTime,
                                                    )
                                                  : '',
                                              'isCurrent':
                                                  (r['isCurrent'] as bool)
                                                  ? 1
                                                  : 0,
                                            });
                                          }
                                        }
                                        Get.back();
                                      },
                                      child: const CommonText('Save', fontSize: 16, fontWeight: FontWeight.w600),
                                    ),
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
        final items = controller.educationList;
        if (items.isEmpty) {
          return CommonText(
            'No education added yet.',
            color: AppColors.textSecondaryColor,
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
                year: yearStr(
                  items[i].startDate,
                  items[i].endDate,
                  items[i].isCurrent,
                ),
              ),
              if (i != items.length - 1) const SizedBox(height: 12),
            ],
          ],
        );
      }),
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
          CommonText(
            degree,
            color: AppColors.textPrimaryColor,
            fontWeight: FontWeight.w800,
          ),
          const SizedBox(height: 4),
          CommonText(
            school,
            color: AppColors.textSecondaryColor,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 6),
          CommonText(year, color: AppColors.textSecondaryColor),
        ],
      ),
    );
  }
}
