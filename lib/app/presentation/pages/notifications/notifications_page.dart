import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/notifications/notifications_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/notifications/widgets/filter_tabs.dart';
import 'package:mavx_flutter/app/presentation/pages/notifications/widgets/header.dart';
import 'package:mavx_flutter/app/presentation/pages/notifications/widgets/notification_card.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationsController controller = Get.put(NotificationsController());
    final topInset = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          Container(height: topInset, color: const Color(0xFF0B2944)),
          SafeArea(
            child: Column(
              children: [
                const Header(),
                const FilterTabs(),
                Expanded(
                  child: Obx(() {
                    if (controller.loading.value) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final items = controller.notifications;
                    return RefreshIndicator(
                      onRefresh: controller.refreshList,
                      child: items.isEmpty
                          ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: const [
                                SizedBox(height: 160),
                                Center(
                                  child: CommonText(
                                    'No notifications',
                                    color: AppColors.textSecondaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.all(16),
                              itemCount: items.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final n = items[index];
                                return NotificationCard(
                                  title: n.title,
                                  message: n.message,
                                  type: n.type,
                                  isRead: n.isRead,
                                  time: n.createdAt,
                                  onTap: () => controller.markAsRead(n.id),
                                  onDismissed: () => controller.delete(n.id),
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



