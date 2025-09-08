import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/apply/apply_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/apply/widgets/header.dart';
import 'package:mavx_flutter/app/presentation/pages/apply/widgets/labeledField.dart';
import 'package:mavx_flutter/app/presentation/pages/apply/widgets/upload_cv.dart';

class ApplyPage extends GetView<ApplyController> {
  const ApplyPage({super.key});

  @override
  Widget build(BuildContext context) { 

    final c = Get.isRegistered<ApplyController>()
        ? Get.find<ApplyController>()
        : Get.put(ApplyController());

    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 340;
    final edge = EdgeInsets.symmetric(horizontal: isSmall ? 16 : 20);
    final fieldSpacing = isSmall ? 14.0 : 16.0;
    final titleSize = isSmall ? 20.0 : 24.0;
    final subtitleSize = isSmall ? 12.0 : 13.0;
    final buttonHeight = isSmall ? 44.0 : 50.0;

    final formKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top space for iOS-like notch already handled by SafeArea
                  Padding(
                    padding: edge.copyWith(top: 12),
                    child: Obx(() {
                      final p = c.project.value;
                      return Header(
                        titleSize: titleSize,
                        subtitleSize: subtitleSize,
                        title: p?.projectTitle,
                        company: '',
                        projectType: p?.projectType,
                      );
                    }),
                  ),
                  const SizedBox(height: 12),
                  const Divider(thickness: 1, color: Color(0xFFE6E9EF)),
                  const SizedBox(height: 8),

                  Form(
                    key: formKey,
                    child: Obx(() {
                      final type = (c.project.value?.projectType ?? '').trim().toLowerCase();
                      final isContractLike = type == 'contract' || type == 'contract placement' || type == 'consulting';
                      return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Contract-like fields visible only for Contract / Contract placement / Consulting
                        if (isContractLike) ...[
                          Padding(
                            padding: edge,
                            child: LabeledField(
                              label: 'Per Hour Cost',
                              hint: 'Enter Per Hour Cost',
                              controller: c.perHourCostCtrl,
                              keyboardType: TextInputType.number,
                              validator: (v) {
                                final t = (v ?? '').trim();
                                if (t.isEmpty) return 'Per hour cost is required';
                                final n = int.tryParse(t);
                                if (n == null || n <= 0) return 'Enter a valid positive number';
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: fieldSpacing),
                          Padding(
                            padding: edge,
                            child: LabeledField(
                              label: 'Availability In A Day',
                              hint: 'e.g. 5 hours per day',
                              controller: c.availabilityDayCtrl,
                              keyboardType: TextInputType.text,
                              validator: (v) {
                                if ((v ?? '').trim().isEmpty) return 'Availability per day is required';
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: fieldSpacing),
                          Padding(
                            padding: edge,
                            child: LabeledField(
                              label: 'Availability In A Week',
                              hint: 'e.g. 30 hours/week',
                              controller: c.availabilityWeekCtrl,
                              keyboardType: TextInputType.number,
                              validator: (v) {
                                final t = (v ?? '').trim();
                                if (t.isEmpty) return 'Availability per week is required';
                                final n = int.tryParse(t);
                                if (n == null || n < 0) return 'Enter a valid number';
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                        // Non-contract-like: show Current/Expected CTC with validation
                        if (!isContractLike) ...[
                          Padding(
                            padding: edge,
                            child: LabeledField(
                              label: 'Current CTC',
                              hint: 'Enter current CTC',
                              controller: c.currentCtcCtrl,
                              keyboardType: TextInputType.number,
                              validator: (v) {
                                final t = (v ?? '').trim();
                                if (t.isEmpty) return 'Current CTC is required';
                                if (int.tryParse(t) == null) return 'Enter a valid number';
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: fieldSpacing),
                          Padding(
                            padding: edge,
                            child: LabeledField(
                              label: 'Expected CTC',
                              hint: 'Enter expected CTC',
                              controller: c.expectedCtcCtrl,
                              keyboardType: TextInputType.number,
                              validator: (v) {
                                final t = (v ?? '').trim();
                                if (t.isEmpty) return 'Expected CTC is required';
                                if (int.tryParse(t) == null) return 'Enter a valid number';
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: fieldSpacing),
                          // About You (only for non-contract-like)
                          Padding(
                            padding: edge,
                            child: LabeledField(
                              label: 'About You',
                              hint: 'Write briefly about yourself',
                              controller: c.aboutYouCtrl,
                              keyboardType: TextInputType.multiline,
                              validator: (v) {
                                if ((v ?? '').trim().isEmpty) return 'Please add a short summary';
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: fieldSpacing),
                          // Holding Offer (only for non-contract-like)
                          Padding(
                            padding: edge,
                            child: Row(
                              children: [
                                Obx(() => Checkbox(
                                      value: c.holdingOffer.value,
                                      onChanged: (v) => c.holdingOffer.value = v ?? false,
                                    )),
                                const Expanded(
                                  child: Text(
                                    'Currently holding an offer',
                                    style: TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: fieldSpacing),
                        ], 
                        // Upload area (common)
                        Padding(
                          padding: edge,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SectionTitle('Upload Professional Document'),
                              const SizedBox(height: 8),
                              UploadDropArea(controller: c),
                              const SizedBox(height: 6),
                              Obx(() {
                                final url = c.existingResumeUrl.value;
                                if (url.isEmpty) return const SizedBox.shrink();
                                final name = url.split('/').last;
                                return Text(
                                  'Using resume: $name',
                                  style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
                                );
                              }),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                height: buttonHeight,
                                child: Obx(() {
                                  return ElevatedButton.icon(
                                    onPressed: c.uploading.value ? null : c.pickAndUpload,
                                    icon: const Icon(Icons.upload, color: Colors.white),
                                    label: Text(
                                      c.uploading.value ? 'Uploading...' : 'Upload New CV',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF0B2944),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                              const SizedBox(height: 20),
                              // Bottom action buttons
                              Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: buttonHeight,
                                      child: ElevatedButton(
                                        onPressed: () => Get.back(),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFFD2D2D2),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                        ),
                                        child: const Text(
                                          'Back',
                                          style: TextStyle(fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: isSmall ? 10 : 16),
                                  Expanded(
                                    child: SizedBox(
                                      height: buttonHeight,
                                      child: ElevatedButton(
                                        onPressed: c.applying.value
                                            ? null
                                            : () {
                                                final ok = formKey.currentState?.validate() ?? true;
                                                if (!ok) return;
                                                c.apply();
                                              },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF0B2944),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                        ),
                                        child: Obx(() => Text(
                                              c.applying.value ? 'Applying...' : 'Apply',
                                              style: const TextStyle(fontWeight: FontWeight.w700),
                                            )),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
              )],
              ),
            );
          },
        ),
      ),
    );
  }
}







