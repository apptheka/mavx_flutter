import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/home/widgets/job_card.dart';
import 'package:mavx_flutter/app/presentation/pages/saved/saved_controller.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';

class SavedPage extends GetView<SavedController> {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<SavedController>();
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Saved Projects'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (c.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (c.error.isNotEmpty) {
          return Center(
            child: Text(
              c.error.value,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        if (c.saved.isEmpty) {
          return RefreshIndicator(
            onRefresh: () => c.fetchSaved(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: const Center(child: CommonText('No saved projects yet')),
              ),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () => c.fetchSaved(),
          child: ListView.separated(
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
                showApply: true,
                onTap: () => c.removeBookmark(p.id ?? 0),
              );
            },
          ),
        );
      }),
    );
  }
}
