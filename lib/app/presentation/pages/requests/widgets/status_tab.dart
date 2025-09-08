
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/requests/requests_controller.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';

class StatusTabs extends StatelessWidget {
  const StatusTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RequestsController>();
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: controller.statusOptions.map((status) {
          return Expanded(
            child: Obx(() {
              final isSelected = controller.selectedStatus.value == status;
              return GestureDetector(
                onTap: () => controller.changeStatus(status),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF0B2944) : Colors.grey[200],
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Center(
                    child: CommonText(
                      status.capitalize ?? status,
                      color: isSelected ? Colors.white : Colors.black54,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }),
          );
        }).toList(),
      ),
    );
  }
}