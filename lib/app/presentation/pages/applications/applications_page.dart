import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/applications/applications_controller.dart';
// import 'package:mavx_flutter/app/presentation/pages/applications/widgets/applications_list.dart';
import 'package:mavx_flutter/app/presentation/pages/home/widgets/job_card.dart';
import 'package:mavx_flutter/app/routes/app_routes.dart';
import 'package:mavx_flutter/app/presentation/pages/applications/widgets/empty_view.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';

class ApplicationsPage extends StatelessWidget {
  const ApplicationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ApplicationsController controller = Get.put(ApplicationsController());
    final topInset = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          Container(height: topInset, color: const Color(0xFF0B2944)),
          SafeArea(
            child: Column(
              children: [
                const _HeaderApplications(),
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
                                  ? ListView(
                                      physics: const AlwaysScrollableScrollPhysics(),
                                      children: const [
                                        SizedBox(height: 100),
                                        EmptyView(message: 'You have not applied to any projects yet.'),
                                      ],
                                    )
                                  : controller.error.isNotEmpty ?  ListView(
                                      physics: const AlwaysScrollableScrollPhysics(),
                                      children: const [
                                        SizedBox(height: 100),
                                        EmptyView(message: 'Something went wrong'),
                                      ],
                                    ): ListView.builder(
                                      itemCount: controller.projects.length,
                                      padding: const EdgeInsets.all(16),
                                      itemBuilder: (context, index) {
                                        final p = controller.projects.reversed.toList()[index];
                                        final applied = p.id != null && controller.appliedIds.contains(p.id!);
                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 12),
                                          child: JobCard(
                                            id: p.id ?? 0,
                                            title: p.projectTitle ?? '',
                                            description: p.description ?? '',
                                            company: p.projectType ?? '',
                                            skillsJson: p.skillsJson,
                                            tags: [p.projectType ?? ''],
                                            status: applied ? 'Applied' : null,
                                            applied: applied,
                                            showBookmark: false,
                                            onTap: () => Get.toNamed(AppRoutes.projectDetail, arguments: p.id ?? 0),
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

class _HeaderApplications extends StatelessWidget {
  const _HeaderApplications();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ApplicationsController>();
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
            children: [
              const Expanded(
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
