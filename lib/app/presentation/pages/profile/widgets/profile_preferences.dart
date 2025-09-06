import 'package:flutter/material.dart';
import 'package:mavx_flutter/app/core/constants/assets.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/profile_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/widgets/section_card.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:get/get.dart';

class ProfilePreferences extends StatelessWidget {
  final ProfileController controller;
  const ProfilePreferences({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Project Preferences',
      subtitle: "What kind of work you're looking for",
      onEdit: () {
        final p = controller.preferences.value;
        final lookingForCtrl = TextEditingController(text: p.lookingFor ?? '');
        final budgetCtrl = TextEditingController(text: p.preferredBudget ?? '');

        String normalizeToItem(String? raw, List<String> items) {
          if (raw == null) return items.first;
          final key = raw.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
          String toKey(String s) => s.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
          for (final item in items) {
            if (toKey(item) == key) return item;
          }
          // special aliases
          final aliases = <String, String>{
            'perproject': 'Per Project',
            'project': 'Per Project',
            'perhour': 'Per Hour',
            'hour': 'Per Hour',
            'perday': 'Per Day',
            'day': 'Per Day',
            'immediate': 'Immediate',
            '12weeks': '1-2 Weeks',
            '1month': '1 Month+',
            '1monthplus': '1 Month+',
            'shortterm': 'Short Term',
            'mediumterm': 'Medium Term',
            'longterm': 'Long Term',
            'recruitment': 'Recruitment',
            'contract': 'Contract',
            'contractplacement': 'Contract Placement',
            'consulting': 'Consulting',
            'fulltime': 'Full Time',
            'usd': 'USD',
            'inr': 'INR',
            'aud': 'AUD',
            'eur': 'EUR',
          };
          if (aliases.containsKey(key)) {
            final mapped = aliases[key]!;
            if (items.contains(mapped)) return mapped;
          }
          return items.first;
        }

        // Dropdown items
        final currencyItems = ['USD', 'INR', 'AUD', 'EUR'];
        final periodItems = ['hour', 'day', 'week', 'month', 'project'];
        final availabilityItems = ['Immediate', '1-2 Weeks', '1 Month+'];
        final durationTypeItems = ['Short Term', 'Medium Term', 'Long Term'];
        final workTypeItems = ['Recruitment', 'Contract', 'Contract Placement', 'Consulting', 'Full Time'];

        String currency = normalizeToItem(p.budgetCurrency, currencyItems);
        String period = normalizeToItem(p.budgetPeriod, periodItems);
        final hoursCtrl = TextEditingController(text: (p.availabilityHoursPerWeek ?? 0).toString());
        String availabilityType = normalizeToItem(p.availabilityType, availabilityItems);
        final minCtrl = TextEditingController(text: (p.preferredDurationMin ?? '').toString());
        final maxCtrl = TextEditingController(text: (p.preferredDurationMax ?? '').toString());
        String durationType = normalizeToItem(p.preferredDurationType, durationTypeItems);
        String workType = normalizeToItem(p.workType, workTypeItems);

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
                    const Text('Project Preferences', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 6),
                    const Text('Set your project and work preferences', style: TextStyle(color: AppColors.textSecondaryColor)),
                    const SizedBox(height: 12),
          
          
                    _LabeledField(label: 'Looking For *', controller: lookingForCtrl),
                    const SizedBox(height: 10),
          
                    Row(children: [
                      Expanded(child: _LabeledField(label: 'Preferred Budget *', controller: budgetCtrl, keyboardType: TextInputType.number)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatefulBuilder(builder: (context, setState) => _LabeledDropdown(
                          label: 'Currency *',
                          value: currency,
                          items: currencyItems,
                          onChanged: (v) => setState(() => currency = v ?? currency),
                        )),
                      ),
                    ]),
                    const SizedBox(height: 10),
          
                    Row(children: [
                      Expanded(
                        child: StatefulBuilder(builder: (context, setState) => _LabeledDropdown(
                          label: 'Period *',
                          value: period,
                          items: periodItems,
                          onChanged: (v) => setState(() => period = v ?? period),
                        )),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: _LabeledField(label: 'Availability (Hours per Week)', controller: hoursCtrl, keyboardType: TextInputType.number)),
                    ]),
                    const SizedBox(height: 10),
          
                    Row(children: [
                      Expanded(
                        child: StatefulBuilder(builder: (context, setState) => _LabeledDropdown(
                          label: 'Availability Type *',
                          value: availabilityType,
                          items: availabilityItems,
                          onChanged: (v) => setState(() => availabilityType = v ?? availabilityType),
                        )),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: _LabeledField(label: 'Minimum Duration (Months)', controller: minCtrl, keyboardType: TextInputType.number)),
                    ]),
                    const SizedBox(height: 10),
          
                    Row(children: [
                      Expanded(child: _LabeledField(label: 'Maximum Duration (Months)', controller: maxCtrl, keyboardType: TextInputType.number)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatefulBuilder(builder: (context, setState) => _LabeledDropdown(
                          label: 'Duration Type *',
                          value: durationType,
                          items: durationTypeItems,
                          onChanged: (v) => setState(() => durationType = v ?? durationType),
                        )),
                      ),
                    ]),
                    const SizedBox(height: 10),
          
                    StatefulBuilder(builder: (context, setState) => _LabeledDropdown(
                      label: 'Work Type *',
                      value: workType,
                      items: workTypeItems,
                      onChanged: (v) => setState(() => workType = v ?? workType),
                    )),
          
                    const SizedBox(height: 14),
                    Row(children: [
                      TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
                      const Spacer(),
                      SizedBox(
                        width: 140,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () async {
                            final looking = lookingForCtrl.text.trim();
                            final budget = budgetCtrl.text.trim();
                            if (looking.isEmpty || budget.isEmpty) {
                              Get.snackbar('Required', 'Looking For and Budget are required');
                              return;
                            }
                            await controller.savePreferences(
                              lookingFor: looking,
                              preferredBudget: budget,
                              budgetCurrency: currency,
                              budgetPeriod: period,
                              availabilityHoursPerWeek: int.tryParse(hoursCtrl.text.trim()) ?? 0,
                              availabilityType: availabilityType,
                              preferredDurationMin: int.tryParse(minCtrl.text.trim()) ?? 0,
                              preferredDurationMax: int.tryParse(maxCtrl.text.trim()) ?? 0,
                              preferredDurationType: durationType.replaceAll(' ', '_'),
                              workType: workType,
                            );
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
        final p = controller.preferences.value;
        final lookingFor = p.lookingFor?.trim().isNotEmpty == true ? p.lookingFor!.trim() : '-';
        final budget = () {
          final b = p.preferredBudget;
          final cur = p.budgetCurrency;
          final per = p.budgetPeriod;
          if (b == null || b.isEmpty) return '-';
          final parts = [if (cur != null && cur.isNotEmpty) cur, b, if (per != null && per.isNotEmpty) '/$per'];
          return parts.join(' ');
        }();
        final availability = () {
          final hrs = p.availabilityHoursPerWeek;
          final type = p.availabilityType;
          if (hrs == null && (type == null || type.isEmpty)) return '-';
          final parts = [if (hrs != null) '$hrs hrs', if (type != null && type.isNotEmpty) type];
          return parts.join('/');
        }();
        final duration = () {
          final min = p.preferredDurationMin;
          final max = p.preferredDurationMax;
          final type = p.preferredDurationType?.replaceAll("_", " ");
          if (min == null && max == null) return '-';
          final range = [if (min != null) '$min', if (max != null) '$max'].join('–');
          return type != null && type.isNotEmpty ? '$range $type' : range;
        }();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PrefRow(
              iconAsset: IconAssets.searchBlack,
              label: 'Looking for',
              value: lookingFor,
            ),
            const SizedBox(height: 14),
            _PrefRow(
              iconAsset: IconAssets.presentation,
              label: 'Preferred Budget',
              value: budget,
              boldValue: true,
            ),
            const SizedBox(height: 14),
            _PrefRow(
              iconAsset: IconAssets.calendar,
              label: 'Availability',
              value: availability,
            ),
            const SizedBox(height: 14),
            _PrefRow(
              iconAsset: IconAssets.duration,
              label: 'Preferred Duration',
              value: duration,
            ),
          ],
        );
      }),
    );

    // helper widgets
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  const _LabeledField({
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF5F6FA),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }
}

class _LabeledDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  const _LabeledDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F6FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox.shrink(),
            items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class _PrefRow extends StatelessWidget {
  final String iconAsset;
  final String label;
  final String value;
  final bool boldValue;

  const _PrefRow({
    required this.iconAsset,
    required this.label,
    required this.value,
    this.boldValue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(iconAsset, width: 20, height: 20, color: AppColors.textSecondaryColor),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondaryColor,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: AppColors.textPrimaryColor,
                  fontWeight: boldValue ? FontWeight.w800 : FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
