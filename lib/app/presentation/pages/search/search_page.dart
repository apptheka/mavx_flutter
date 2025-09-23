import 'package:flutter/material.dart';
import 'package:get/get.dart'; 
import 'package:mavx_flutter/app/presentation/pages/home/widgets/job_card.dart';
import 'package:mavx_flutter/app/presentation/pages/search/search_controller.dart' as search;
import 'package:mavx_flutter/app/presentation/pages/search/widgets/left_menu.dart';
import 'package:mavx_flutter/app/presentation/pages/search/widgets/right_menu.dart';
import 'package:mavx_flutter/app/presentation/pages/search/widgets/search_header.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart'; 
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<search.SearchPageController>(
      init: Get.isRegistered<search.SearchPageController>()
          ? null
          : search.SearchPageController(),
      builder: (controller) {
        final topInset = MediaQuery.of(context).padding.top;
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          body: Stack(
            children: [
              Container(height: topInset, color: const Color(0xFF0B2944)),
              SafeArea(
                child: Column(
                  children: [
                    SearchHeader(),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          await controller.refresh();
                        },
                        child: Obx(() {
                          final items = controller.filteredJobs;
                          if (controller.isLoading.value) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (items.isEmpty) {
                            return const Center(
                              child: Text('No jobs match your search'),
                            );
                          }
                          final extra = controller.isLoadingMore.value ? 1 : 0;
                          return NotificationListener<ScrollNotification>(
                            onNotification: controller.handleScrollNotification,
                            child: ListView.separated(
                              padding: const EdgeInsets.all(16),
                              itemCount: items.length + extra,
                              separatorBuilder: (_, __) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                if (index >= items.length) {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    child: Center(child: CircularProgressIndicator()),
                                  );
                                }
                                final job = items[index];
                                final title = job.projectTitle ?? '';
                                final company = job.projectCoordinator ?? '';
                                // Clean description by removing HTML tags and extra whitespace
                                String cleanDescription = job.description ?? '';
                                cleanDescription = cleanDescription
                                    .replaceAll(RegExp(r'<[^>]*>'), '') // Remove HTML tags
                                    .replaceAll(RegExp(r'&nbsp;'), ' ') // Replace &nbsp; with space
                                    .replaceAll(RegExp(r'\s+'), ' ') // Replace multiple spaces with single space
                                    .trim(); // Remove leading/trailing whitespace
                                // Derive lightweight tags from projectType string if present
                                final tags = (job.projectType != null && job.projectType!.isNotEmpty)
                                    ? [job.projectType!]
                                    : const <String>[];
                                final applied = controller.appliedIds.contains(job.id ?? -1);
                                return JobCard(
                                  title: title,
                                  description: cleanDescription,
                                  company: company,
                                  tags: tags,
                                  showApply: true,
                                  compact: false,
                                  id: job.id!,
                                  applied: applied,
                                );
                              },
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showFilterBottomSheet(context, controller),
            backgroundColor: AppColors.primaryColor,
            child: const Icon(Icons.tune, color: Colors.white),
          ),
        );
      },
    );
  }

  void _showFilterBottomSheet(
    BuildContext context,
    search.SearchPageController controller,
  ) {
    // Prepare staged selections so the sheet reflects current applied filters
    controller.startStaging();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final bottom = MediaQuery.of(context).padding.bottom;
        return Obx(
          () => Container(
            height: MediaQuery.of(context).size.height * 0.72,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 8, 12),
                  child: Row(
                    children: [
                      const Expanded(
                        child: CommonText(
                          'Filters',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Get.back(),
                      )
                    ],
                  ),
                ),
                const Divider(height: 1),
                // Body: left menu + right list
                Expanded(
                  child: Row(
                    children: [
                      // Left vertical menu
                      Container(
                        width: 140,
                        color: const Color(0xFFF1F3F6),
                        child: ListView(
                          children: [
                            LeftMenuItem(
                              title: 'Project Type',
                              selected: controller.leftMenuIndex.value == 0,
                              onTap: () => controller.leftMenuIndex.value = 0,
                            ),
                            LeftMenuItem(
                              title: 'Industry',
                              selected: controller.leftMenuIndex.value == 1,
                              onTap: () => controller.leftMenuIndex.value = 1,
                            ),
                          ],
                        ),
                      ),
                      // Right content
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: Obx(() {
                            if (controller.filtersLoading.value) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            // Decide which list to show and handle empty state
                            final isType = controller.leftMenuIndex.value == 0;
                            final hasData = isType
                                ? controller.projectTypes.isNotEmpty
                                : controller.industries.isNotEmpty;
                            if (!hasData) {
                              return const Center(
                                child: CommonText(
                                  'No options available',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            }
                            return const RightOptionsList();
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                // Bottom apply button similar to screenshot
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8 + bottom),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: const StadiumBorder(),
                          ),
                          onPressed: () {
                            controller.clearFilters();
                            Get.back();
                          },
                          child: CommonText(
                            'Clear All',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0B2944),
                              shape: const StadiumBorder(),
                            ),
                            onPressed: () {
                              controller.applyStagedFilters();
                              Get.back();
                            },
                            child: CommonText(
                              'Apply Filter',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}



