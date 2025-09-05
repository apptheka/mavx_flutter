import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/routes/app_routes.dart';
import 'package:mavx_flutter/app/core/constants/image_assets.dart'; 
import 'package:mavx_flutter/app/presentation/pages/project_detail/project_detail_controller.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:mavx_flutter/app/core/constants/assets.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';
import 'package:mavx_flutter/app/presentation/pages/home/widgets/job_card.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProjectDetailController>();
    return Obx(() {
      if (controller.loading.value && controller.project.isEmpty) {
        return const _Card(child: Center(child: CircularProgressIndicator()));
      }

      if (controller.error.isNotEmpty) {
        return _Card(
          child: Text(
            controller.error.value,
            style: const TextStyle(color: AppColors.textSecondaryColor),
          ),
        );
      }

      String cleanDescription = controller.project.isNotEmpty
          ? controller.project.first.description ?? ''
          : '';
      cleanDescription = cleanDescription
          .replaceAll(RegExp(r'<[^>]*>'), '') // Remove HTML tags
          .replaceAll(RegExp(r'&nbsp;'), ' ') // Replace &nbsp; with space
          .replaceAll(
            RegExp(r'\s+'),
            ' ',
          ) // Replace multiple spaces with single space
          .trim();

      final desc = (cleanDescription.isNotEmpty)
          ? cleanDescription
          : 'No description provided.';

      return _Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              desc,
              style: const TextStyle(
                color: AppColors.textSecondaryColor,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            const _SubTitle('Responsibilities'),
            const _Bullet(text: 'Develop strategy with stakeholders'),
            const _Bullet(text: 'Lead CRM tooling rollout'),
            const _Bullet(text: 'Optimize onboarding & marketing'),
            const _Bullet(text: 'Collaborate with engineering and marketing'),
            const SizedBox(height: 12),
            const _SubTitle('Preferred Skills'),
            const Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _Skill('P&L Analysis'),
                _Skill('Process Design'),
                _Skill('Sales Enablement'),
                _Skill('Change Management'),
                _Skill('Strategic Communication'),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class TimelineSection extends StatelessWidget {
  const TimelineSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        children: const [
          _TimelineItem(
            iconPath: IconAssets.calendar,
            title: 'Start Date',
            value: 'Aug 1, 2025',
          ),
          SizedBox(height: 24),
          _TimelineItem(
            iconPath: IconAssets.globe,
            value: 'Phase 1: Aug 1 - Aug 15, 2025',
            title: 'Discovery',
          ),
          SizedBox(height: 24),
          _TimelineItem(
            iconPath: IconAssets.mvp,
            value: 'Sep 1, 2025',
            title: 'MVP Launch',
          ),
          SizedBox(height: 24),
          _TimelineItem(
            iconPath: IconAssets.presentation,
            value: 'Oct 10, 2025',
            title: 'Final Review Presentation',
          ),
        ],
      ),
    );
  }
}

class ClientOverviewSection extends StatelessWidget {
  const ClientOverviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: AppColors.greyColor,
                  shape: BoxShape.circle,
                ),
                child: Center(child: Image.asset(ImageAssets.jobLogo)),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vatrix Global',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 2),
                    CommonText(
                      "10 Projects Posted",
                      fontSize: 13,
                      color: AppColors.textSecondaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Image.asset(IconAssets.verified, width: 18, height: 18),
                  const SizedBox(width: 4),
                  Text(
                    'Verified',
                    style: TextStyle(
                      color: AppColors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          const _IconRow(icon: IconAssets.web, text: 'www.vatrixglobal.com'),
          const SizedBox(height: 8),
          const _IconRow(icon: IconAssets.location, text: 'New York, USA'),
          const SizedBox(height: 8),
          const Divider(height: 2, color: AppColors.greyColor),
          const SizedBox(height: 8),
          const _LinkRow(
            left: 'Read All Reviews',
            right: 'View Complete Profile',
          ),
        ],
      ),
    );
  }
}

class GreatFitSection extends StatelessWidget {
  const GreatFitSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Bullet(text: 'You have 7+ years product leadership'),
          _Bullet(text: 'Worked on revenue-side GTM initiatives'),
          _Bullet(text: 'Your availability matches the project start timeline'),
        ],
      ),
    );
  }
}

class ActionsSection extends StatelessWidget {
  const ActionsSection({super.key, required this.onTap, required this.text});

  final Function() onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProjectDetailController>();
    final int projectId = Get.arguments is int ? Get.arguments as int : 0;
    return Obx(() {
      final bool isApplied = controller.appliedIds.contains(projectId);
      return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: isApplied ? null : () { Get.toNamed(AppRoutes.apply, arguments: projectId); },
            child: Text(
              isApplied ? 'Applied' : 'Apply',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: Center(
            child: InkWell(
              onTap: onTap,
              child: CommonText(
                text,
                color: AppColors.textButtonColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
    });
  }
}

class SimilarProjectsSection extends StatelessWidget {
  const SimilarProjectsSection({super.key});
 
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProjectDetailController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => _SectionHeaderRow(
            title: 'Similar Projects (${controller.similarProjects.length })',
            action: 'View All',
          ),
        ),
        const SizedBox(height: 8),
        Obx(() {
          if (controller.loading.value) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (controller.error.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                controller.error.value,
                style: const TextStyle(color: AppColors.textSecondaryColor),
              ),
            );
          }
          final items = controller.similarProjects;
          if (items.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'No similar projects found.',
                style: TextStyle(color: AppColors.textSecondaryColor),
              ),
            );
          }

          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.27,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final it = controller.similarProjects[index];
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.92,
                  child: JobCard(
                    title: it.projectTitle ?? '',
                    description: it.description ?? '',
                    company: it.projectType ?? '',
                    tags: [it.projectType ?? ''],
                    status: it.projectType ?? '',
                    compact: true,
                    id: it.id ?? 0,  
                    applied: it.id != null && controller.appliedIds.contains(it.id!),
                    onTap: () {
                      // Replace current detail page with the selected similar project's detail
                      Get.offNamed(AppRoutes.projectDetail, arguments: it.id);
                    },
                  ),
                );
              },
            ),
          );
        }),
      ],
    );
  }
}

// UI building blocks
class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [child],
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  final String text;
  const _SubTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: CommonText(text, fontSize: 15, fontWeight: FontWeight.w800),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.black,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: CommonText(text, fontSize: 13)),
        ],
      ),
    );
  }
}

class _Skill extends StatelessWidget {
  final String text;
  const _Skill(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: AppColors.green, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: CommonText(text, fontSize: 13, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String iconPath;
  final String title;
  final String value;
  const _TimelineItem({
    required this.iconPath,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(iconPath, width: 18, height: 18),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonText(
              title,
              fontSize: 13,
              color: AppColors.textSecondaryColor,
            ),
            CommonText(
              value,
              fontSize: 13,
              color: AppColors.textPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ],
    );
  }
}

class _IconRow extends StatelessWidget {
  final String icon;
  final String text;
  const _IconRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(icon, width: 16, height: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: AppColors.textSecondaryColor),
          ),
        ),
      ],
    );
  }
}

class _LinkRow extends StatelessWidget {
  final String left;
  final String right;
  const _LinkRow({required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          left,
          style: const TextStyle(
            color: AppColors.textButtonColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 8),
        Container(width: 2, height: 16, color: AppColors.greyColor),
        const SizedBox(width: 8),
        Text(
          right,
          style: const TextStyle(
            color: AppColors.textButtonColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _SectionHeaderRow extends StatelessWidget {
  final String title;
  final String action;
  const _SectionHeaderRow({required this.title, required this.action});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
          ),
          Text(
            action,
            style: const TextStyle(
              color: AppColors.textButtonColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// Removed old _SimilarCard and _MiniBadge; we now reuse JobCard for parity across the app.
