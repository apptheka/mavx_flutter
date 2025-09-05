import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/applications/applications_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/home/widgets/job_card.dart';
import 'package:mavx_flutter/app/routes/app_routes.dart';

class ApplicationsList extends StatelessWidget {
  const ApplicationsList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ApplicationsController>();

    return Obx(() {
      if (controller.loading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.error.value.isNotEmpty) {
        return Center(child: Text(controller.error.value));
      }
      if (controller.projects.isEmpty) {
        return const Center(child: Text('No applications yet'));
      }
      return ListView.builder(
        itemCount: controller.projects.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final p = controller.projects[index];
          final applied = p.id != null && controller.appliedIds.contains(p.id!);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: JobCard(
              id: p.id ?? 0,
              title: p.projectTitle ?? '',
              description: p.description ?? '',
              company: p.projectType ?? '',
              tags: [p.projectType ?? ''],
              status: applied ? 'Applied' : null,
              applied: applied,
              onTap: () => Get.toNamed(AppRoutes.projectDetail, arguments: p.id ?? 0),
            ),
          );
        },
      );
    });
  }
}
