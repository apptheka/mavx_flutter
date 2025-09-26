import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/home/home_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/home/widgets/job_card.dart';
import 'package:mavx_flutter/app/presentation/pages/saved/saved_controller.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';
import 'package:mavx_flutter/app/presentation/widgets/no_data_lottie.dart';

class SavedPage extends GetView<SavedController> {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<SavedController>();
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          Container(height: MediaQuery.of(context).padding.top, color: const Color(0xFF0B2944)),
          SafeArea(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF0B2944),
                        Color(0xFF103A5C),
                        Color(0xFF103A5C),
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () {
                              if (Get.isRegistered<HomeController>()) {
                                Get.find<HomeController>().refreshPage();
                              }
                              Get.back(result: true);
                            }, 
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: CommonText(
                              'Saved Projects',
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Obx(() {
                    return RefreshIndicator(
                      onRefresh: () => c.fetchSaved(),
                      child: c.loading.value
                          ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: const [
                                SizedBox(height: 200),
                                Center(child: CircularProgressIndicator()),
                              ],
                            )
                          : c.error.isNotEmpty
                              ? ListView(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  children: [
                                    const SizedBox(height: 200),
                                    Center(
                                      child: CommonText(
                                        c.error.value,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                )
                              : c.saved.isEmpty
                                  ? NoDataLottie(title: 'No Saved Projects Found',buttonText: 'Save Projects', onPressed: () => Get.back(result: true))
                                  : ListView.separated(
                                      padding: const EdgeInsets.all(12),
                                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                                      itemCount: c.saved.length,
                                      itemBuilder: (context, index) {
                                        final p = c.saved[index];
                                        return JobCard(
                                          id: p.id ?? index,
                                          title: p.projectTitle ?? '-',
                                          description: p.description ?? (p.projectTitle ?? '-'),
                                          company: p.projectCordinator ?? '—',
                                          tags: [p.projectType ?? '-'],
                                          skillsJson: p.skillsJson,
                                          showApply: true,
                                          // Always show bookmark icon in saved list
                                          showBookmark: true,
                                          // Force the icon to the saved state
                                          bookmarkedOverride: true,
                                          // Tapping the icon should unsave
                                          onBookmarkPressed: () => c.removeBookmark(p.id ?? 0),
                                          // Do not mark as applied here (already filtered out)
                                          applied: false,
                                        );
                                      },
                                    ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
