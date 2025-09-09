import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/domain/usecases/projects_usecase.dart';
import 'package:mavx_flutter/app/presentation/pages/project_detail/widgets/detial_header.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:mavx_flutter/app/presentation/pages/project_detail/widgets/header_section.dart';
import 'package:mavx_flutter/app/presentation/pages/project_detail/widgets/about_section.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';
import 'package:mavx_flutter/app/presentation/pages/project_detail/project_detail_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/home/home_controller.dart';

class ProjectDetailPage extends GetView<ProjectDetailController> {
  const ProjectDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure the controller is available for all child widgets via Get.find
    final int projectId = Get.arguments is int ? Get.arguments as int : 0;
    final homeCtrl = Get.find<HomeController>();
    final topInset = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          // Status bar background to match gradient start, like HomePage
          Container(height: topInset, color: const Color(0xFF103A5C)),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DetailHeader(),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const HeaderSection(),
                        const SizedBox(height: 12),
                        const CommonText(
                          'About the project',
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                        const SizedBox(height: 12),
                        const AboutSection(),
                        const SizedBox(height: 12),
                        const CommonText(
                          'Timeline & Milestones',
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                        const SizedBox(height: 12),
                        const TimelineSection(),
                        // const SizedBox(height: 12),
                        // const CommonText(
                        //   'Client Overview',
                        //   fontSize: 20,
                        //   fontWeight: FontWeight.w800,
                        // ),
                        // const SizedBox(height: 12),
                        // const ClientOverviewSection(),
                        const SizedBox(height: 12),
                        const CommonText(
                          'Why You\'re a Great Fit',
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                        const SizedBox(height: 12),
                        const GreatFitSection(),
                        const SizedBox(height: 20),
                        Obx(() {
                          final isBookmarked = homeCtrl.bookmarkedIds.contains(projectId);
                          return ActionsSection(
                            text: isBookmarked ? 'Remove from Bookmarks' : 'Save for Later',
                            onTap: () {
                              homeCtrl.toggleBookmark(projectId);
                            },
                          );
                        }),
                        const SizedBox(height: 16),
                        Divider(
                          height: 3,
                          color: AppColors.textPrimaryColor.withValues(
                            alpha: 0.4,
                          ),
                          thickness: 1,
                        ),
                        const SizedBox(height: 16),
                        const SimilarProjectsSection(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
