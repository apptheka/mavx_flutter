import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/applications/applications_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/applications/widgets/applications_list.dart';
import 'package:mavx_flutter/app/presentation/pages/applications/widgets/empty_view.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';

class ApplicationsPage extends StatelessWidget {
  const ApplicationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ApplicationsController controller = Get.put(ApplicationsController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const _HeaderApplications(),
            Expanded(
              child: Obx(() {
                if (controller.loading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.error.value.isNotEmpty) {
                  return Center(
                    child: CommonText(
                      controller.error.value,
                      color: AppColors.textSecondaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                }
                if (controller.projects.isEmpty) {
                  return const EmptyView(message: 'You have not applied to any projects yet.');
                }
                return const ApplicationsList();
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderApplications extends StatelessWidget {
  const _HeaderApplications();

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
        children: const [
          Row(
            children: [
              Expanded(
                child: CommonText(
                  'My Applications',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
