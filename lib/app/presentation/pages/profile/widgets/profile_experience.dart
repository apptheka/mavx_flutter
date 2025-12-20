import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mavx_flutter/app/core/constants/image_assets.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/profile_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/widgets/date_box.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/widgets/section_card.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/widgets/app_text_field.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';

class ProfileExperience extends StatelessWidget {
  final ProfileController controller;
  const ProfileExperience({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Experience',
      subtitle: "Where you've worked and what you achieved",
      onEdit: () {
        // Seed rows from existing experiences
        final List<Map<String, dynamic>> rows = controller.experienceList
            .map((e) => {
                  'id': e.id,
                  'companyName': e.companyName ?? '',
                  'role': e.role ?? '',
                  'employmentType': e.employmentType ?? 'Full Time',
                  'isRemote': (e.isRemote ?? 0) == 1,
                  'startDate': e.startDate, // DateTime?
                  'isCurrent': (e.isCurrent ?? 0) == 1,
                  'description': e.description ?? '',
                  'isNew': false,
                })
            .toList();
        // If no experiences exist, start with one blank row so UI isn't empty
        if (rows.isEmpty) {
          rows.add({
            'id': null,
            'companyName': '',
            'role': '',
            'employmentType': 'Full Time',
            'isRemote': false,
            'startDate': null,
            'isCurrent': false,
            'description': '',
            'isNew': true,
          });
        }
        Get.bottomSheet(
          SafeArea(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: SizedBox(
                height: rows.isEmpty
                    ? MediaQuery.of(context).size.height * 0.78
                    : (rows.length > 1
                        ? MediaQuery.of(context).size.height * 0.8
                        : MediaQuery.of(context).size.height * 0.8),
                child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: StatefulBuilder(
                  builder: (context, setSheetState) {
                    void addRow() {
                      setSheetState(() {
                        rows.add({
                          'id': null,
                          'companyName': '',
                          'role': '',
                          'employmentType': 'Full Time',
                          'isRemote': false,
                          'startDate': null,
                          'isCurrent': false,
                          'description': '',
                          'isNew': true,
                        });
                      });
                    }
               
                    String fmt(DateTime? d) => d == null
                        ? 'Select date'
                        : '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
              
                    const types = ['Full Time','Part Time','Contract','Internship'];
              
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonText(
                            'Experience',
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ), 
                          CommonText('Add your professional experience', color: AppColors.textSecondaryColor),
                          const SizedBox(height: 12),
              
                          for (int i = 0; i < rows.length; i++) ...[
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
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
                                          rows[i]['id'] != null
                                              ? 'Edit Experience ${i + 1} (ID: ${rows[i]['id']})'
                                              : 'New Experience ${i + 1}',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      if (rows[i]['id'] != null)
                                        IconButton(
                                          onPressed: () => controller.deleteExperience(rows[i]['id']),
                                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            _label('Company Name *'),
                                            AppTextField(
                                              controller: TextEditingController(text: rows[i]['companyName'])
                                              ..selection = TextSelection.fromPosition(TextPosition(offset: (rows[i]['companyName'] as String).length)),
                                              hintText: 'Company Name',
                                              onChanged: (v) => setSheetState(() => rows[i]['companyName'] = v),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            _label('Job Title *'),
                                            AppTextField(
                                              controller: TextEditingController(text: rows[i]['role'])
                                              ..selection = TextSelection.fromPosition(TextPosition(offset: (rows[i]['role'] as String).length)),
                                              hintText: 'Job Title',
                                              onChanged: (v) => setSheetState(() => rows[i]['role'] = v),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: DropdownButtonFormField<String>(
                                          isExpanded: true,
                                          initialValue: types.contains(rows[i]['employmentType']) ? rows[i]['employmentType'] : 'Full Time',
                                          decoration: InputDecoration(
                                            labelText: 'Employment Type *',
                                            filled: true,
                                            fillColor: const Color(0xFFF5F6FA),
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                          ),
                                          items: types.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                                          onChanged: (v) => setSheetState(() => rows[i]['employmentType'] = v ?? 'Full Time'),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Checkbox(
                                            value: rows[i]['isRemote'] as bool,
                                            onChanged: (v) => setSheetState(() => rows[i]['isRemote'] = v ?? false),
                                          ),
                                          const CommonText('Remote Work', fontSize: 14),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _label('Start Date *'),
                                      DateBox(
                                        label: fmt(rows[i]['startDate'] as DateTime?),
                                        onTap: () async {
                                          final picked = await showDatePicker(
                                            context: context,
                                            initialDate: (rows[i]['startDate'] as DateTime?) ?? DateTime.now(),
                                            firstDate: DateTime(1950),
                                            lastDate: DateTime(2100),
                                          );
                                          if (picked != null) setSheetState(() => rows[i]['startDate'] = picked);
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: rows[i]['isCurrent'] as bool,
                                        onChanged: (v) => setSheetState(() => rows[i]['isCurrent'] = v ?? false),
                                      ),
                                      const CommonText('Currently working here', fontSize: 14),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  _label('Job Description *'),
                                  AppTextField(
                                    controller: TextEditingController(text: rows[i]['description'])
                                    ..selection = TextSelection.fromPosition(TextPosition(offset: (rows[i]['description'] as String).length)),
                                    maxLines: 4,
                                    hintText: 'Job Description',
                                    onChanged: (v) => setSheetState(() => rows[i]['description'] = v),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
              
                          OutlinedButton.icon(
                            onPressed: addRow,
                            icon: const Icon(Icons.add),
                            label: const CommonText('Add experience', fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [ 
                              SizedBox(
                                width: 160,
                                height: 48,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                  ),
                                  onPressed: () async {
                                    for (final r in rows) {
                                      final company = (r['companyName'] as String).trim();
                                      final role = (r['role'] as String).trim();
                                      final s = r['startDate'] as DateTime?;
                                      final desc = (r['description'] as String).trim();
                                      if (company.isEmpty || role.isEmpty || s == null || desc.isEmpty) continue;
                                      String fmtOut(DateTime d) => '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
                                      // Only create when the row is newly added in this session, or update existing by id
                                      if (r['id'] != null || (r['isNew'] == true)) {
                                        await controller.saveExperience({
                                          'id': r['id'],
                                          'company_name': company,
                                          'role': role,
                                          'employment_type': r['employmentType'],
                                          'isRemote': (r['isRemote'] as bool) ? 1 : 0,
                                          'start_date': fmtOut(s),
                                          'isCurrent': (r['isCurrent'] as bool) ? 1 : 0,
                                          'description': desc,
                                        });
                                      }
                                    }
                                    Get.back();
                                  },
                                  child: const CommonText('Save', fontSize: 16, fontWeight: FontWeight.w600),
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
        final exps = controller.experienceList;
        if (exps.isEmpty) {
          return CommonText(
            'No experience added yet.',
            color: AppColors.textSecondaryColor,
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
            'January',
            'February',
            'March',
            'April',
            'May',
            'June',
            'July',
            'August',
            'September',
            'October',
            'November',
            'December',
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
                employmentType: (exps[i].employmentType ?? '-').replaceAll('_', ' '),
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
  child: CommonText(text, fontSize: 14, fontWeight: FontWeight.w700),
);
 

class _ExperienceItem extends StatefulWidget {
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
  State<_ExperienceItem> createState() => _ExperienceItemState();
}

class _ExperienceItemState extends State<_ExperienceItem> {
  static const int _collapsedMaxLines = 3;
  bool _expanded = false;
  bool _isOverflow = false;

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
                    colors: [widget.gradientStart, widget.gradientEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    widget.iconAsset, 
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      widget.role.toUpperCase(),
                      color: AppColors.textPrimaryColor,
                      fontWeight: FontWeight.w800,
                    ),
                    const SizedBox(height: 2),
                    CommonText(
                      '${widget.company.toUpperCase()} • ${widget.employmentType.toUpperCase()}',
                      color: AppColors.textSecondaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(height: 2),
                    CommonText(
                      widget.period,
                      color: AppColors.textSecondaryColor,
                    ), 
                    // Summary aligned with this column
                    LayoutBuilder(
                      builder: (context, constraints) {
                        // Measure if text exceeds the collapsed max lines
                        final span = TextSpan(
                          text: widget.summary,
                          style: const TextStyle(color: AppColors.textSecondaryColor),
                        );
                        final tp = TextPainter(
                          text: span,
                          maxLines: _collapsedMaxLines,
                          textDirection: TextDirection.ltr,
                        )..layout(maxWidth: constraints.maxWidth);
                        final exceeds = tp.didExceedMaxLines;
                        if (exceeds != _isOverflow) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) setState(() => _isOverflow = exceeds);
                          });
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              widget.summary,
                              maxLines: _expanded ? null : _collapsedMaxLines,
                              overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
                              color: AppColors.textSecondaryColor,
                            ),
                            if (_isOverflow)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => setState(() => _expanded = !_expanded),
                                  child: CommonText(
                                    _expanded ? 'Read less' : 'Read more',
                                    color: AppColors.textButtonColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
