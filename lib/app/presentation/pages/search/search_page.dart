import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/core/constants/assets.dart'; 
import 'package:mavx_flutter/app/presentation/pages/home/widgets/job_card.dart';
import 'package:mavx_flutter/app/presentation/pages/search/search_controller.dart' as search;
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
    search.SearchController controller,
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
                        child: Text(
                          'Filters',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
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
                            _LeftMenuItem(
                              title: 'Project Type',
                              selected: controller.leftMenuIndex.value == 0,
                              onTap: () => controller.leftMenuIndex.value = 0,
                            ),
                            _LeftMenuItem(
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
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Category',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: controller.filtersLoading.value
                                    ? const Center(child: CircularProgressIndicator())
                                    : const _RightOptionsList(),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton(
                                  onPressed: () {},
                                  child: const Text('Show More'),
                                ),
                              ),
                            ],
                          ),
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
                          child: const Text('Clear All'),
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
                            child: const Text(
                              'Apply Filter',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
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

class _LeftMenuItem extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _LeftMenuItem({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? const Color(0xFF0B2944) : Colors.transparent;
    final fg = selected ? Colors.white : const Color(0xFF0B2944);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w600, color: fg),
        ),
      ),
    );
  }
}

class _RightOptionsList extends StatelessWidget {
  const _RightOptionsList();

  @override
  Widget build(BuildContext context) {
    return GetX<search.SearchController>(builder: (controller) {
      final isType = controller.leftMenuIndex.value == 0;
      if (isType) {
        final items = controller.projectTypes;
        // touch length to create a reactive dependency on the set
        final _ = controller.stagedProjectTypeIds.length;
        return ListView.separated(
          itemCount: items.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final item = items[index];
            final selected = controller.stagedProjectTypeIds.contains(item.id);
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              title: Text(item.title),
              trailing: selected
                  ? const Icon(Icons.check_circle, color: Color(0xFF0B2944))
                  : const SizedBox.shrink(),
              onTap: () => controller.toggleProjectType(item.id),
            );
          },
        );
      } else {
        final items = controller.industries;
        // touch length to create a reactive dependency on the set
        final _ = controller.stagedIndustryIds.length;
        return ListView.separated(
          itemCount: items.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final item = items[index];
            final selected = controller.stagedIndustryIds.contains(item.id);
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              title: Text(item.title),
              trailing: selected
                  ? const Icon(Icons.check_circle, color: Color(0xFF0B2944))
                  : const SizedBox.shrink(),
              onTap: () => controller.toggleIndustry(item.id),
            );
          },
        );
      }
    });
  }
}
