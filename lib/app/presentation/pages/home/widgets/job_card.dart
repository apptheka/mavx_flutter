import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/core/constants/assets.dart';
import 'package:mavx_flutter/app/core/constants/image_assets.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';
import 'package:mavx_flutter/app/presentation/pages/home/home_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/search/search_controller.dart'as search;
import 'package:mavx_flutter/app/presentation/pages/saved/saved_controller.dart'as saved;
import 'package:mavx_flutter/app/routes/app_routes.dart';

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
    final titleFontSize = isSmallScreen ? 14.0 : 16.0;
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
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        ImageAssets.userAvatar,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: isSmallScreen ? 8 : 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0B2944),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Image.asset(
                            IconAssets.apartement,
                            width: isSmallScreen ? 12 : 14,
                            height: isSmallScreen ? 12 : 14,
                            color: Colors.black45,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              company,
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: isSmallScreen ? 12 : 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (showBookmark && !applied)
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
            const Divider(height: 16, color: Color(0xFFE6E9EF)),
            SizedBox(height: compact ? 4 : 6),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 280) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (tags.isNotEmpty)
                        Text(
                          tags.first,
                          style: TextStyle(
                            color: _getProjectTypeColor(tags.first),
                            fontWeight: FontWeight.w700,
                            fontSize: isSmallScreen ? 12 : 14,
                          ),
                        ),
                    ],
                  );
                }

                return Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: isSmallScreen ? 6 : 10,
                  runSpacing: 6,
                  children: [
                    if (tags.isNotEmpty)
                      Text(
                        tags.first,
                        style: TextStyle(
                          color: _getProjectTypeColor(tags.first),
                          fontWeight: FontWeight.w700,
                          fontSize: isSmallScreen ? 12 : 14,
                        ),
                      ),
                  ],
                );
              },
            ),
            SizedBox(height: compact ? 4 : 6),
            Text(
              'For 6 Months',
              style: TextStyle(
                color: Colors.black87,
                fontSize: isSmallScreen ? 12 : 14,
              ),
            ),
            SizedBox(height: compact ? 2 : 4),
            Text(
              'Posted: 1 hour ago',
              style: TextStyle(
                color: Colors.black54,
                fontSize: isSmallScreen ? 10 : 12,
              ),
            ),
            if (showApply) ...[
              SizedBox(height: compact ? spacingSmall : spacingMedium),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isTight = constraints.maxWidth < 220;
                  if (isTight || isSmallScreen) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _matchBadge(status ?? '92% Match', isSmallScreen),
                        SizedBox(height: compact ? 6 : spacingSmall),
                        SizedBox(
                          height: buttonHeight,
                          child: ElevatedButton(
                            onPressed: applied
                                ? null
                                : () async {
                                    final res = await Get.toNamed(
                                      AppRoutes.apply,
                                      arguments: id,
                                    );
                                    if (res == true) {
                                      // refresh applied state across pages after returning
                                      if (Get.isRegistered<HomeController>()) {
                                        Get.find<HomeController>()
                                            .refreshAppliedIds();
                                      }
                                      if (Get.isRegistered<
                                        search.SearchController
                                      >()) {
                                        Get.find<search.SearchController>()
                                            .refreshAppliedIds();
                                      }
                                      if (Get.isRegistered<
                                        saved.SavedController
                                      >()) {
                                        // refresh saved list to remove applied items
                                        Get.find<saved.SavedController>()
                                            .fetchSaved();
                                      }
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0B2944),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
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
                  }
                  return Row(
                    children: [
                      _matchBadge(status ?? '92% Match', isSmallScreen),
                      const Spacer(),
                      SizedBox(
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
                                    if (Get.isRegistered<HomeController>()) {
                                      Get.find<HomeController>()
                                          .refreshAppliedIds();
                                    }
                                    if (Get.isRegistered<
                                      search.SearchController
                                    >()) {
                                      Get.find<search.SearchController>()
                                          .refreshAppliedIds();
                                    }
                                    if (Get.isRegistered<
                                      saved.SavedController
                                    >()) {
                                      Get.find<saved.SavedController>()
                                          .fetchSaved();
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
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: isSmall ? 10 : 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
