import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/home/widgets/job_card.dart';
import 'package:mavx_flutter/app/presentation/pages/my_projects/my_projects_controller.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';
import 'package:mavx_flutter/app/presentation/widgets/no_data_lottie.dart';
import 'package:mavx_flutter/app/routes/app_routes.dart';

class MyProjectsPage extends StatelessWidget {
  const MyProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final MyProjectsController controller = Get.put(MyProjectsController());
    final topInset = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          Container(height: topInset, color: const Color(0xFF0B2944)),
          SafeArea(
            child: Column(
              children: [
                const _HeaderMyProjects(),
                Expanded(
                  child: Obx(() {
                    return RefreshIndicator(
                      onRefresh: controller.fetchData,
                      child: controller.loading.value
                          ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: const [
                                SizedBox(height: 200),
                                Center(child: CircularProgressIndicator()),
                              ],
                            )
                          : controller.error.value.isNotEmpty
                          ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                const SizedBox(height: 200),
                                Center(
                                  child: CommonText(
                                    controller.error.value,
                                    color: AppColors.textSecondaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                          : controller.projects.isEmpty
                          ? NoDataLottie(
                              title: "No Confirmed Projects Yet",
                              buttonText: "Check Later",
                              onPressed: () {
                                Get.back();
                              },
                            )
                          : ListView.builder(
                              itemCount: controller.projects.length,
                              padding: const EdgeInsets.all(16),
                              itemBuilder: (context, index) {
                                final p = controller.projects.reversed
                                    .toList()[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: JobCard(
                                    id: p.projectId ?? p.id ?? 0,
                                    title: p.projectTitle ?? '',
                                    description: p.description ?? '',
                                    company: p.projectType ?? '',
                                    tags: [p.projectType ?? ''],
                                    status: 'Confirmed',
                                    applied: false,
                                    showBookmark: false,
                                    onTap: () => Get.toNamed(
                                      AppRoutes.projectDetail,
                                      arguments: p.projectId ?? p.id ?? 0,
                                    ),
                                  ),
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

class _HeaderMyProjects extends StatelessWidget {
  const _HeaderMyProjects();

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
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: CommonText(
              'My Projects',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
