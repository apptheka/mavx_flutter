import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/profile_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/widgets/section_card.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';

class ProfileBankDetails extends StatelessWidget {
  final ProfileController controller;
  const ProfileBankDetails({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Bank Details',
      subtitle: 'Where you want to receive payouts',
      onEdit: () {
        final b = controller.bankDetails.value;
        final holderCtrl = TextEditingController(text: b.accountHolderName ?? '');
        final bankNameCtrl = TextEditingController(text: b.bankName ?? '');
        final accountNoCtrl = TextEditingController(text: b.accountNumber ?? '');
        final ifscCtrl = TextEditingController(text: b.ifsc ?? '');
        final branchCtrl = TextEditingController(text: b.branch ?? '');
        final addressCtrl = TextEditingController(text: b.bankAddress ?? '');
        final countryCtrl = TextEditingController(text: b.country ?? 'IN');
        String currency = (b.currency?.isNotEmpty ?? false) ? b.currency! : 'INR';
        final swiftCtrl = TextEditingController(text: b.swift ?? '');
        final ibanCtrl = TextEditingController(text: b.iban ?? '');
        final routingCtrl = TextEditingController(text: b.routingNumber ?? '');
        final intermediaryCtrl = TextEditingController(text: b.intermediaryBank ?? '');
        final notesCtrl = TextEditingController(text: b.notes ?? '');

        final currencyItems = const ['INR', 'USD', 'EUR', 'AUD'];

        Get.bottomSheet(
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
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
                      const CommonText('Bank Details', fontSize: 18, fontWeight: FontWeight.w800),
                      const SizedBox(height: 6),
                      const CommonText('Add or update your bank details', color: AppColors.textSecondaryColor),
                      const SizedBox(height: 12),

                      _LabeledField(label: 'Account Holder Name *', controller: holderCtrl),
                      const SizedBox(height: 10),
                      _LabeledField(label: 'Bank Name *', controller: bankNameCtrl),
                      const SizedBox(height: 10),
                      _LabeledField(label: 'Account Number *', controller: accountNoCtrl, keyboardType: TextInputType.number),
                      const SizedBox(height: 10),
                      _LabeledField(label: 'IFSC *', controller: ifscCtrl),
                      const SizedBox(height: 10),
                      _LabeledField(label: 'Branch', controller: branchCtrl),
                      const SizedBox(height: 10),
                      _LabeledField(label: 'Bank Address', controller: addressCtrl),
                      const SizedBox(height: 10),

                      Row(children: [
                        Expanded(child: _LabeledField(label: 'Country', controller: countryCtrl)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: StatefulBuilder(
                            builder: (context, setState) => _LabeledDropdown(
                              label: 'Currency *',
                              value: currency,
                              items: currencyItems,
                              onChanged: (v) => setState(() => currency = v ?? currency),
                            ),
                          ),
                        ),
                      ]),
                      const SizedBox(height: 15),
                      const CommonText("International Bank Details", fontSize: 22, fontWeight: FontWeight.w600),
                      const SizedBox(height: 10),
                      _LabeledField(label: 'SWIFT', controller: swiftCtrl),
                      const SizedBox(height: 10),
                      _LabeledField(label: 'IBAN', controller: ibanCtrl),
                      const SizedBox(height: 10),
                      _LabeledField(label: 'Routing Number', controller: routingCtrl),
                      const SizedBox(height: 10),
                      _LabeledField(label: 'Intermediary Bank', controller: intermediaryCtrl),
                      const SizedBox(height: 10),
                      _LabeledField(label: 'Notes *', controller: notesCtrl, keyboardType: TextInputType.multiline),

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
                                final holder = holderCtrl.text.trim();
                                final bname = bankNameCtrl.text.trim();
                                final acc = accountNoCtrl.text.trim();
                                final ifsc = ifscCtrl.text.trim();
                                final notes = notesCtrl.text.trim();
                                
                                if (holder.isEmpty || bname.isEmpty || acc.isEmpty || ifsc.isEmpty) {
                                  Get.snackbar('Required', 'Please fill required fields', colorText: AppColors.white,backgroundColor: AppColors.errorColor,snackPosition: SnackPosition.BOTTOM);
                                  return;
                                }
                                
                                if (notes.isEmpty) {
                                  Get.snackbar('Required', 'Notes is required', colorText: AppColors.white,backgroundColor: AppColors.errorColor,snackPosition: SnackPosition.BOTTOM);
                                  return;
                                }

                                Get.back();
                                final payload = <String, dynamic>{ 
                                  'account_holder_name': holder,
                                  'bank_name': bname,
                                  'account_number': acc,
                                  'ifsc': ifsc,
                                  'branch': branchCtrl.text.trim(),
                                  'bank_address': addressCtrl.text.trim(),
                                  'country': countryCtrl.text.trim(),
                                  'currency': currency,
                                  'swift': swiftCtrl.text.trim(),
                                  'iban': ibanCtrl.text.trim().isEmpty ? null : ibanCtrl.text.trim(),
                                  'routing_number': routingCtrl.text.trim().isEmpty ? null : routingCtrl.text.trim(),
                                  'intermediary_bank': intermediaryCtrl.text.trim().isEmpty ? null : intermediaryCtrl.text.trim(),
                                  'notes': notes,
                                };
                                if (b.id != null) payload['id'] = b.id;
                                await controller.saveBankDetails(payload);
                              },
                              child: const CommonText('Save', fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          isScrollControlled: true,
        );
      },
      child: Obx(() {
        final b = controller.bankDetails.value;
        String maskAcc(String? acc) {
          if (acc == null || acc.length < 4) return acc ?? '-';
          final last4 = acc.substring(acc.length - 4);
          return '•••• $last4';
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BDRow(label: 'Account Holder', value: b.accountHolderName ?? '-'),
            const SizedBox(height: 14),
            _BDRow(label: 'Bank Name', value: b.bankName ?? '-'),
            const SizedBox(height: 14),
            _BDRow(label: 'Account Number', value: maskAcc(b.accountNumber)),
            const SizedBox(height: 14),
            _BDRow(label: 'IFSC', value: b.ifsc ?? '-'),
            const SizedBox(height: 14),
            _BDRow(label: 'Currency', value: b.currency ?? '-'),
            const SizedBox(height: 14),
            _BDRow(label: 'Country', value: b.country ?? '-'),
          ],
        );
      }),
    );
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
        CommonText(label, fontSize: 14, fontWeight: FontWeight.w700),
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
        CommonText(label, fontSize: 14, fontWeight: FontWeight.w700),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF5F6FA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _BDRow extends StatelessWidget {
  final String label;
  final String value;
  const _BDRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: CommonText(label, color: AppColors.textSecondaryColor, fontSize: 12)),
        const SizedBox(width: 10),
        Expanded(child: CommonText(value, color: AppColors.textPrimaryColor, fontWeight: FontWeight.w700)),
      ],
    );
  }
}
