import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/notifications/notifications_controller.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';

class FilterTabs extends GetView<NotificationsController> {
  const FilterTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final current = controller.currentFilter.value;
      return Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: const BoxDecoration(color: Colors.white,borderRadius: BorderRadius.vertical(bottom: Radius.circular(40))),
        child: Row(
          children: [
            _chip('all', current == 'all', () => controller.setFilter('all')),
            const SizedBox(width: 8),
            _chip('unread', current == 'unread', () => controller.setFilter('unread')),
            const SizedBox(width: 8),
            _chip('read', current == 'read', () => controller.setFilter('read')),
            const Spacer(),
            TextButton(
              onPressed: controller.markAllAsRead,
              child: const Text('Mark all as read'),
            ),
          ],
        ),
      );
    });
  }

  Widget _chip(String label, bool selected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF0B2944) : const Color(0xFFF1F3F6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: CommonText(
          label.capitalizeFirst!,
          color: selected ? Colors.white : const Color(0xFF0B2944),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}