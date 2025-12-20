import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/core/constants/assets.dart';
import 'package:mavx_flutter/app/core/constants/image_assets.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';
import 'package:mavx_flutter/app/presentation/pages/home/home_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/search/search_controller.dart'
    as search;
import 'package:mavx_flutter/app/presentation/pages/saved/saved_controller.dart'
    as saved;
import 'package:mavx_flutter/app/routes/app_routes.dart';
import 'package:mavx_flutter/app/presentation/pages/applications/applications_controller.dart';

class JobCard extends StatelessWidget {
  final String title;
  final String description;
  final String company;
  final List<String> tags;
  final String? status;
  final bool showApply;
  final bool compact;
  final int id;
  final VoidCallback? onTap;
  final bool applied;
  final bool showBookmark;
  final bool? bookmarkedOverride;
  final VoidCallback? onBookmarkPressed;
  final String? skillsJson;
  final int? duration;
  final String? durationType;
  final double? budget;
  final double? projectCost;
  final DateTime? creationDate;
  final VoidCallback? onSchedulePressed;
  final VoidCallback? onExpensePressed;
  final bool showInvoiceButton;
  final VoidCallback? onInvoicePressed;

  const JobCard({
    super.key,
    required this.title,
    required this.description,
    required this.company,
    this.tags = const [],
    this.status,
    this.showApply = true,
    this.compact = false,
    required this.id,
    this.onTap,
    this.applied = false,
    this.showBookmark = true,
    this.bookmarkedOverride,
    this.onBookmarkPressed,
    this.skillsJson,
    this.duration,
    this.durationType,
    this.budget,
    this.projectCost,
    this.creationDate,
    this.onSchedulePressed,
    this.onExpensePressed,
    this.showInvoiceButton = false,
    this.onInvoicePressed,
  });

  Color _getProjectTypeColor(String projectType) {
    switch (projectType.toLowerCase()) {
      case 'consulting':
        return Colors.blue;
      case 'recruitment':
        return Colors.green;
      case 'full time':
        return Colors.purple;
      case 'contract placement':
        return Colors.orange;
      case 'contract':
        return Colors.teal;
      case 'internal':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final controller = Get.find<HomeController>();

    // Responsive sizing
    final cardPadding = isSmallScreen ? 8.0 : 12.0;
    final logoSize = isSmallScreen ? 32.0 : 36.0;
    final titleFontSize = isSmallScreen ? 14.0 : 15.0;
    final spacingSmall = isSmallScreen ? 6.0 : 8.0;
    final spacingMedium = isSmallScreen ? 8.0 : 12.0;
    final buttonHeight = compact
        ? (isSmallScreen ? 36.0 : 40.0)
        : (isSmallScreen ? 40.0 : 44.0);

    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!();
        } else {
          Get.toNamed(AppRoutes.projectDetail, arguments: id);
        }
      },
      child: Container(
        padding: EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
                  child: SizedBox(
                    width: logoSize,
                    height: logoSize,
                    child: Image.asset(
                      ImageAssets.jobLogo,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(Icons.person,color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(width: isSmallScreen ? 8 : 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CommonText(
                              title,
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0B2944),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ), 
                    ],
                  ),
                ),
                if (showBookmark &&
                    !applied &&
                    !(status != null && status!.toLowerCase() == 'confirmed'))
                  if (bookmarkedOverride != null)
                    IconButton(
                      onPressed:
                          onBookmarkPressed ??
                          () {
                            controller.toggleBookmark(id);
                          },
                      padding: EdgeInsets.all(isSmallScreen ? 4 : 8),
                      constraints: BoxConstraints(
                        minWidth: isSmallScreen ? 32 : 40,
                        minHeight: isSmallScreen ? 32 : 40,
                      ),
                      icon: (bookmarkedOverride == true)
                          ? Image.asset(
                              IconAssets.saved,
                              width: isSmallScreen ? 16 : 20,
                              height: isSmallScreen ? 16 : 20,
                            )
                          : Image.asset(
                              IconAssets.clipboard,
                              width: isSmallScreen ? 16 : 20,
                              height: isSmallScreen ? 16 : 20,
                            ),
                    )
                  else
                    Obx(() {
                      final isBookmarked = controller.bookmarkedIds.contains(
                        id,
                      );
                      return IconButton(
                        onPressed:
                            onBookmarkPressed ??
                            () {
                              controller.toggleBookmark(id);
                            },
                        padding: EdgeInsets.all(isSmallScreen ? 4 : 8),
                        constraints: BoxConstraints(
                          minWidth: isSmallScreen ? 32 : 40,
                          minHeight: isSmallScreen ? 32 : 40,
                        ),
                        icon: isBookmarked
                            ? Image.asset(
                                IconAssets.saved,
                                width: isSmallScreen ? 16 : 20,
                                height: isSmallScreen ? 16 : 20,
                              )
                            : Image.asset(
                                IconAssets.clipboard,
                                width: isSmallScreen ? 16 : 20,
                                height: isSmallScreen ? 16 : 20,
                              ),
                      );
                    }),
              ],
            ),
            SizedBox(height: compact ? 6 : spacingSmall),

            // Skills Section
            if (skillsJson != null && skillsJson!.isNotEmpty) ...[
              _buildSkillsSection(isSmallScreen),
              SizedBox(height: compact ? 6 : 8),
            ],

            const Divider(height: 12, color: Color(0xFFE6E9EF)),
            SizedBox(height: compact ? 2 : 6),

            // Project Type
            if (tags.isNotEmpty)
              CommonText(
                tags.first,
                color: _getProjectTypeColor(tags.first),
                fontWeight: FontWeight.w700,
                fontSize: isSmallScreen ? 12 : 14,
              ),
            SizedBox(height: compact ? 4 : 6),

            // Duration and Budget
            if (compact) ...[
              // More compact layout for similar projects
              CommonText(
                _getDurationText(),
                color: Colors.black87,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ] else ...[
              // Regular layout for home page
              Row(
                children: [
                  Expanded(
                    child: CommonText(
                      _getDurationText(),
                      color: Colors.black87,
                      fontSize: isSmallScreen ? 12 : 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
            SizedBox(height: compact ? 0 : 4),
            // if (!compact)
            //   CommonText(
            //     _getPostedText(),
            //     color: Colors.black54,
            //     fontSize: isSmallScreen ? 10 : 12,
            //   ),
            if (showApply) ...[
              SizedBox(height: compact ? spacingSmall : spacingMedium),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isTight = constraints.maxWidth < 220;
                  if (isTight || isSmallScreen) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [ 
                        if (!(status != null &&
                            status!.toLowerCase() == 'confirmed'))
                          SizedBox(height: compact ? 6 : spacingSmall),
                        (status != null && status!.toLowerCase() == 'confirmed')
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [ 
                                    SizedBox(height: spacingSmall),
                                    SizedBox(
                                      height: buttonHeight,
                                      child: OutlinedButton(
                                        onPressed: onInvoicePressed,
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                            color: Color(0xFF0B2944),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          'Invoice',
                                          style: TextStyle(
                                            fontSize: isSmallScreen ? 12 : 14,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF0B2944),
                                          ),
                                        ),
                                      ),
                                    ),
                                    _confirmedBadge(isSmallScreen), 
                                ],
                              )
                            : SizedBox.shrink(),
                      ],
                    );
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      (status != null && status!.toLowerCase() == 'confirmed')
                          ? Flexible(
                              child: Wrap(
                                alignment: WrapAlignment.end,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 8,
                                runSpacing: 6,
                                children: [
                                  if (status == 'Confirmed') ...[
                                    GestureDetector(
                                      onTap: onSchedulePressed,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: Colors.black87,
                                            width: 1,
                                          ),
                                        ),
                                        child: CommonText (
                                          'Timesheet',
                                          fontSize:
                                                isSmallScreen ? 11 : 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ), 
                                    GestureDetector(
                                      onTap: onExpensePressed,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: Colors.black87,
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          'Expense sheet',
                                          style: TextStyle(
                                            fontSize:
                                                isSmallScreen ? 11 : 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  SizedBox(
                                    height: isSmallScreen ? 32 : 35,
                                    child: OutlinedButton(
                                      onPressed: onInvoicePressed,
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                          color: AppColors.secondaryColor,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: CommonText(
                                        'Invoice',
                                        fontSize:
                                              isSmallScreen ? 11 : 13,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  _confirmedBadge(isSmallScreen),
                                ],
                              ),
                            )
                          : SizedBox(
                              width: isSmallScreen ? 80 : 100,
                              height: compact
                                  ? (isSmallScreen ? 32 : 35)
                                  : buttonHeight,
                              child: ElevatedButton(
                                onPressed: applied
                                    ? null
                                    : () async {
                                        final res = await Get.toNamed(
                                          AppRoutes.apply,
                                          arguments: id,
                                        );
                                        if (res == true) {
                                          if (Get.isRegistered<
                                            HomeController
                                          >()) {
                                            final hc =
                                                Get.find<HomeController>();
                                            hc.appliedIds.add(id);
                                            hc.appliedIds.refresh();
                                            hc.refreshAppliedIds();
                                          }
                                          if (Get.isRegistered<
                                            search.SearchPageController
                                          >()) {
                                            final sc =
                                                Get.find<
                                                  search.SearchPageController
                                                >();
                                            sc.appliedIds.add(id);
                                            sc.appliedIds.refresh();
                                            sc.filteredJobs.refresh();
                                            sc.refreshAppliedIds();
                                          }
                                          if (Get.isRegistered<
                                            saved.SavedController
                                          >()) {
                                            Get.find<saved.SavedController>()
                                                .fetchSaved();
                                          }
                                          if (Get.isRegistered<
                                            ApplicationsController
                                          >()) {
                                            Get.find<ApplicationsController>()
                                                .fetchData();
                                          }
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(
                                    isSmallScreen ? 80 : 100,
                                    isSmallScreen ? 32 : 35,
                                  ),
                                  backgroundColor: const Color(0xFF0B2944),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isSmallScreen ? 12 : 16,
                                  ),
                                ),
                                child: CommonText(
                                  applied ? 'Applied' : 'Apply',
                                  fontSize: isSmallScreen ? 12 : 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                    ],
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _matchBadge(String text, bool isSmall) {
    const color = Color(0xFF33C481);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 8 : 10,
        vertical: isSmall ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(24),
      ),
      child: CommonText(
        text,
        color: color,
        fontSize: isSmall ? 10 : 12,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _confirmedBadge(bool isSmall) {
    const color = Color(0xFF33C481);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 12 : 14,
        vertical: isSmall ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, size: isSmall ? 14 : 16, color: color),
          const SizedBox(width: 6),
          CommonText(
            'Confirmed',
            color: color,
            fontSize: isSmall ? 12 : 14,
            fontWeight: FontWeight.w700,
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSection(bool isSmallScreen) {
    if (skillsJson == null || skillsJson!.isEmpty)
      return const SizedBox.shrink();

    try {
      final List<dynamic> skills = jsonDecode(skillsJson!);
      // Show fewer skills in compact mode to prevent overflow
      final limitedSkills = skills.take(compact ? 2 : 3).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(
            'Key Skills',
            fontSize: compact ? 11 : (isSmallScreen ? 12 : 13),
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
          SizedBox(height: compact ? 4 : 6),
          Wrap(
            spacing: compact ? 4 : 6,
            runSpacing: compact ? 2 : 4,
            children: limitedSkills
                .map((skill) => _skillChip(skill.toString(), isSmallScreen))
                .toList(),
          ),
        ],
      );
    } catch (e) {
      return const SizedBox.shrink();
    }
  }

  Widget _skillChip(String skill, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 4 : (isSmallScreen ? 6 : 8),
        vertical: compact ? 2 : (isSmallScreen ? 3 : 4),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF6EAD5),
        borderRadius: BorderRadius.circular(compact ? 8 : 12),
      ),
      child: CommonText(
        skill,
        fontSize: compact ? 9 : (isSmallScreen ? 10 : 11),
        fontWeight: FontWeight.w600,
        color: Colors.black87,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  String _getDurationText() {
    if (duration != null) {
      return 'For $duration ${durationType ?? 'months'}';
    }
    return 'For 6 Months';
  }
}
