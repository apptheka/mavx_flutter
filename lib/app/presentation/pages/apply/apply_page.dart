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
    // Ensure controller is available
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

                  // Per Hour Cost
                  Padding(
                    padding: edge,
                    child: LabeledField(
                      label: 'Per Hour Cost',
                      hint: 'Enter Per Hour Cost',
                      controller: c.perHourCostCtrl,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(height: fieldSpacing),

                  // Availability in a Week
                  Padding(
                    padding: edge,
                    child: LabeledField(
                      label: 'Availability In A Week',
                      hint: 'e.g. 30 hours/week',
                      controller: c.availabilityWeekCtrl,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  SizedBox(height: fieldSpacing),

                  // Availability in a Day
                  Padding(
                    padding: edge,
                    child: LabeledField(
                      label: 'Availability In A Day',
                      hint: 'e.g. 5 hours per day',
                      controller: c.availabilityDayCtrl,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  SizedBox(height: fieldSpacing),

                  // Upload area
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
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Bottom navigation buttons
                  Padding(
                    padding: edge,
                    child: Row(
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
                                'Previous',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: isSmall ? 10 : 16),
                        Container(
                          width: 1,
                          height: buttonHeight * 0.6,
                          color: const Color(0xFFE0E0E0),
                        ),
                        SizedBox(width: isSmall ? 10 : 16),
                        Expanded(
                          child: SizedBox(
                            height: buttonHeight,
                            child: ElevatedButton(
                              onPressed: c.applying.value ? null : c.apply,
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
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}







