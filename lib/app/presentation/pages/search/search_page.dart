import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/core/constants/assets.dart'; 
import 'package:mavx_flutter/app/presentation/pages/home/widgets/job_card.dart';
import 'package:mavx_flutter/app/presentation/pages/search/search_controller.dart'
    as search;
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:mavx_flutter/app/presentation/widgets/app_text_field.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<search.SearchController>(
      init: Get.isRegistered<search.SearchController>()
          ? null
          : search.SearchController(),
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
                    _Header(),
                    Expanded(
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
                        return ListView.separated(
                          controller: controller.scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: items.length + extra,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
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
                            return JobCard(
                              title: title,
                              description: cleanDescription,
                              company: company, 
                              tags: tags,
                              showApply: true,
                              compact: false, 
                              id: job.id!,
                            );
                          },
                        );
                      }),
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
    search.SearchController controller,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter Jobs',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Work Type',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Obx(
              () => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: controller.availableWorkTypes.map((type) {
                  final isSelected = controller.selectedWorkTypes.contains(
                    type,
                  );
                  return FilterChip(
                    selected: isSelected,
                    onSelected: (_) => controller.toggleWorkType(type),
                    label: Text(type),
                    selectedColor: AppColors.primaryColor.withValues(
                      alpha: 0.2,
                    ),
                    checkmarkColor: const Color(0xFF0B2944),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    onPressed: () {
                      controller.clearFilters();
                      Get.back();
                    },
                    child: const CommonText(
                      'Clear All',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      backgroundColor: AppColors.primaryColor,
                    ),
                    child: const CommonText(
                      'Apply',
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}

class _Header extends GetView<search.SearchController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0B2944), Color(0xFF103A5C), Color(0xFF103A5C)],
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
            children: const [
              Expanded(
                child: CommonText(
                  'Search Jobs',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SearchInput(),
        ],
      ),
    );
  }
}

class _SearchInput extends GetView<search.SearchController> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: AppTextField( 
        onChanged: controller.setQuery,
        hintText: 'Search by title, company, location or tag',
        prefixIcon: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Image.asset(
            IconAssets.searchBlack,
            color: Colors.black,
            width: 18,
            height: 18,
          ),
        ),
      ),
    );
  }
}
