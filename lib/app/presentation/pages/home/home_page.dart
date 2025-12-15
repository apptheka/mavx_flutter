import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/chat/chat_badge_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/home/home_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/home/widgets/header_widget.dart';
import 'package:mavx_flutter/app/presentation/pages/home/widgets/profile_completion_card.dart';
import 'package:mavx_flutter/app/presentation/pages/home/widgets/stats_row.dart';
import 'package:mavx_flutter/app/presentation/pages/home/widgets/section_header.dart';
import 'package:mavx_flutter/app/presentation/pages/home/widgets/job_card.dart';
import 'package:mavx_flutter/app/presentation/pages/my_projects/my_projects_controller.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';
import 'package:mavx_flutter/app/routes/app_routes.dart';
import 'package:mavx_flutter/app/data/models/projects_model.dart';
import 'package:mavx_flutter/app/core/services/chat_service.dart';
import 'package:mavx_flutter/app/domain/repositories/auth_repository.dart';
import 'package:mavx_flutter/app/core/services/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).padding.top,
            color: Color(0xFF0B2944),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeaderWidget(),
                const SizedBox(height: 16),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await controller.fetchProjects();
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ProfileCompletionCard(),
                                StatsRow(
                                  padding: EdgeInsets.zero,
                                  controller: Get.find<HomeController>(),
                                ),
                              ],
                            ),
                          ),

                          Obx(
                            () => SectionHeader(
                              title: 'Top Matches for You',
                              total: controller.topMatches.length,
                            ),
                          ),
                          const _TopMatchesList(),
                          Obx(
                            () => SectionHeader(
                              title: 'Other Projects',
                              total: controller.filteredProjects.length,
                              actionText: 'View all',
                              onAction: () {
                                Get.toNamed(AppRoutes.search);
                              },
                            ),
                          ),
                          const _RecommendedList(),
                          const SizedBox(height: 24),
                          
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "unique_fab_1", // add this
        backgroundColor: AppColors.primaryColor,
        onPressed: () {
           Get.toNamed(AppRoutes.chat);
        },
        child: const _ChatIconWithBadge(),
      ),
    );
  }


}
class _ChatIconWithBadge extends StatelessWidget {
  const _ChatIconWithBadge();

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthRepository>();
    final storage = Get.find<StorageService>();
    final chat = ChatService();
    final badgeCtrl = Get.find<ChatBadgeController>();

    return Obx(() {
      // 👇 forces rebuild when coming back from chat
      badgeCtrl.refreshTick.value;

      return FutureBuilder(
        future: auth.getCurrentUser(),
        builder: (context, snapshot) {
          final user = snapshot.data;
          final uid = user?.data.id?.toString();

          if (uid == null || uid.isEmpty) {
            return const Icon(Icons.chat, color: Colors.white);
          }

          final chatId = 'admin1_$uid';

          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: chat.messagesSnapshots(chatId),
            builder: (context, snap) {
              int unread = 0;

              if (snap.hasData) {
                final lastSeen =
                    storage.prefs.getInt('chat_last_seen_$chatId') ?? 0;

                for (final d in snap.data!.docs) {
                  final data = d.data();
                  final sender = (data['sender'] ?? '').toString();
                  final ts = data['createdAt'];

                  int ms = 0;
                  if (ts is Timestamp) ms = ts.millisecondsSinceEpoch;

                  if (ms > lastSeen && sender != 'expert') {
                    unread++;
                  }
                }
              }

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.chat, color: Colors.white),
                  if (unread > 0)
                    Positioned(
                      right: -12,
                      top: -10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 1),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius:
                              BorderRadius.all(Radius.circular(10)),
                        ),
                        constraints: const BoxConstraints(
                            minWidth: 18, minHeight: 18),
                        child: Center(
                          child: Text(
                            unread > 99 ? '99+' : unread.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        },
      );
    });
  }
}


class _EmptyState extends StatelessWidget {
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  const _EmptyState({
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CommonText(
            title,
            fontSize: 18,
            fontWeight: FontWeight.w800,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          CommonText(
            message,
            color: AppColors.textSecondaryColor,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onPressed: onAction,
            child: CommonText(
              actionLabel,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _TopMatchesList extends StatelessWidget {
  const _TopMatchesList();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final double itemWidth = screenWidth > 0
            ? (screenWidth - 32).clamp(280.0, 600.0) // min 280, max 600
            : MediaQuery.of(context).size.width - 32; // 16px side margins
        return Obx(() {
          final ctrl = Get.find<HomeController>();
          final bool loading =
              ctrl.isLoadingProjects.value || ctrl.isRefreshingTopMatches.value;
          if (loading) {
            return SizedBox(
              height: 236,
              child: Center(
                child: SizedBox(
                  height: 28,
                  width: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.8,
                    color: Color(0xFF0B2944),
                  ),
                ),
              ),
            );
          }
          final items = ctrl.topMatches;
          if (items.isEmpty) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              child: _EmptyState(
                title: 'No matches yet',
                message:
                    'Complete your profile and set preferences to see top matches here.',
                actionLabel: 'Refresh',
                onAction: () => ctrl.refreshTopMatches(),
              ),
            );
          }
          return SizedBox(
            height: 236,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              primary: false,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final p = items[index];
                // touch appliedIds to rebuild when it changes
                final applied = Get.find<HomeController>().appliedIds.contains(
                  p.id ?? -1,
                );
                // Determine if this project is already confirmed
                final myCtrl = Get.isRegistered<MyProjectsController>()
                    ? Get.find<MyProjectsController>()
                    : Get.put(MyProjectsController(), permanent: true);
                final isConfirmed = myCtrl.projects.any(
                  (cp) => (cp.projectId ?? cp.id ?? 0) == (p.id ?? -1),
                );
                return SizedBox(
                  width: itemWidth,
                  child: JobCard(
                    title: p.projectTitle ?? '-',
                    description: p.description ?? (p.projectTitle ?? '-'),
                    company: p.projectCoordinator ?? '—',
                    tags: [Get.find<HomeController>().chipFor(p)],
                    showApply: !isConfirmed,
                    status: isConfirmed ? 'confirmed' : null,
                    compact: true,
                    id: p.id ?? index,
                    applied: applied,
                    skillsJson: p.skillsJson,
                    duration: p.duration,
                    durationType: p.durationType,
                    budget: p.budget,
                    projectCost: p.projectCost,
                    creationDate: p.creationDate,
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemCount: items.length,
            ),
          );
        });
      },
    );
  }
}

class _RecommendedList extends StatelessWidget {
  const _RecommendedList();

  @override
  Widget build(BuildContext context) {
    final filters = const ['All','Consulting','Recruitment','Full Time','Contract Placement','Contract','Internal'];
    final controller = Get.find<HomeController>();
    String labelForProjectType(ProjectModel p) {
      final raw = (p.projectType ?? '').trim().toLowerCase();
      if (raw.isEmpty) return controller.chipFor(p); // fallback to work arrangement
      if (raw.contains('consult')) return 'Consulting';
      if (raw.contains('recruit')) return 'Recruitment';
      if (raw == 'full_time' || raw.contains('full')) return 'Full Time';
      if (raw.contains('contract placement')) return 'Contract Placement';
      if (raw.contains('contract')) return 'Contract';
      if (raw.contains('internal')) return 'Internal';
      // Title-case unknowns
      return raw.split(' ').map((w) => w.isEmpty ? w : (w[0].toUpperCase() + (w.length > 1 ? w.substring(1) : ''))).join(' ');
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40,
            child: Obx(() {
              final selectedIndex = controller.selectedFilter.value;
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final isSelected = selectedIndex == index;
                  return ChoiceChip(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                    label: CommonText(filters[index]),
                    selected: isSelected,
                    showCheckmark: false,
                    onSelected: controller.isLoadingProjects.value
                        ? null
                        : (_) => controller.applyFilter(index),
                    selectedColor: AppColors.secondaryColor,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textSecondaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                    backgroundColor: const Color(0xffe9eaeb),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                      side: const BorderSide(width: 0, color: Colors.transparent),
                    ),
                  );
                },
                itemCount: filters.length,
              );
            }),
          ),
          const SizedBox(height: 12),
          Obx(() {
            final bool loading = controller.isLoadingProjects.value || controller.isRefreshingOtherProjects.value;
            if (loading) {
              return SizedBox(
                height: 120,
                child: Center(
                  child: SizedBox(
                    height: 28,
                    width: 28,
                    child: CircularProgressIndicator(strokeWidth: 2.8, color: Color(0xFF0B2944)),
                  ),
                ),
              );
            }
            final items = controller.filteredProjects;
            if (items.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: _EmptyState(
                  title: 'No projects found',
                  message: 'Try changing filters or browse all projects in the search.',
                  actionLabel: 'Refresh',
                  onAction: () => controller.refreshOtherOnly(),
                ),
              );
            }
            return LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final crossAxisCount = width >= 900 ? 3 : (width >= 700 ? 2 : 1);

                if (crossAxisCount == 1) {
                  // Single column: render as a regular vertical list (no overflow)
                  return Column(
                    children: [
                      for (int i = 0; i < items.length && i < 3; i++) ...[
                        // Determine confirmed for each
                        Builder(builder: (context) {
                          final myCtrl = Get.isRegistered<MyProjectsController>()
                              ? Get.find<MyProjectsController>()
                              : Get.put(MyProjectsController(), permanent: true);
                          final isConfirmed = myCtrl.projects.any(
                            (cp) => (cp.projectId ?? cp.id ?? 0) == (items[i].id ?? -1),
                          );
                          return JobCard(
                          title: items[i].projectTitle ?? '-',
                          description: items[i].description ?? (items[i].projectTitle ?? '-'),
                          company: items[i].projectCoordinator ?? '—',
                          tags: [labelForProjectType(items[i])],
                          showApply: !isConfirmed,
                          status: isConfirmed ? 'confirmed' : null,
                          id: items[i].id ?? i,
                          applied: controller.appliedIds.contains(items[i].id ?? -1),
                          skillsJson: items[i].skillsJson,
                          duration: items[i].duration,
                          durationType: items[i].durationType,
                          budget: items[i].budget,
                          projectCost: items[i].projectCost,
                          creationDate: items[i].creationDate,
                          );
                        }),
                        if (i != items.length - 1) const SizedBox(height: 12),
                      ],
                    ],
                  );
                }

                // Multi-column grid: compute aspect ratio from available width to avoid overflow
                final totalSpacing = 12.0 * (crossAxisCount - 1);
                final horizontalPadding = 16.0; // approx outer padding (8 left + 8 right)
                final cardWidth = (width - totalSpacing - horizontalPadding) / crossAxisCount;
                final targetHeight = 240.0; // expected compact card height
                final aspect = cardWidth / targetHeight;

                return GridView.builder(
                  shrinkWrap: true,
                  primary: false,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length.clamp(0, 6),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: aspect,
                  ),
                  itemBuilder: (_, i) {
                    final p = items[i];
                    final myCtrl = Get.isRegistered<MyProjectsController>()
                        ? Get.find<MyProjectsController>()
                        : Get.put(MyProjectsController(), permanent: true);
                    final isConfirmed = myCtrl.projects.any(
                      (cp) => (cp.projectId ?? cp.id ?? 0) == (p.id ?? -1),
                    );
                    return JobCard(
                      title: p.projectTitle ?? '-',
                      description: p.description ?? (p.projectTitle ?? '-'),
                      company: p.projectCoordinator ?? '—',
                      tags: [labelForProjectType(p)],
                      showApply: !isConfirmed,
                      status: isConfirmed ? 'confirmed' : null,
                      compact: true,
                      id: p.id ?? i,
                      applied: controller.appliedIds.contains(p.id ?? -1),
                      skillsJson: p.skillsJson,
                      duration: p.duration,
                      durationType: p.durationType,
                      budget: p.budget,
                      projectCost: p.projectCost,
                      creationDate: p.creationDate,
                    );
                  },
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
