import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/requests/requests_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/requests/widgets/header.dart';
import 'package:mavx_flutter/app/presentation/pages/requests/widgets/request_card.dart';
import 'package:mavx_flutter/app/presentation/pages/requests/widgets/status_tab.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';

class RequestsPage extends StatelessWidget {
  const RequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final RequestsController controller = Get.put(RequestsController());
    final topInset = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          Container(height: topInset, color: const Color(0xFF0B2944)),
          SafeArea(
            child: Column(
              children: [
                const HeaderRequests(),
                StatusTabs(),
                Expanded(
                  child: Obx(() {
                    return RefreshIndicator(
                      onRefresh: controller.refreshRequests,
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
                          : controller.requests.isEmpty
                          ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: const [
                                SizedBox(height: 100),
                                Center(
                                  child: CommonText(
                                    'No requests found.',
                                    color: AppColors.textSecondaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
                              itemCount: controller.requests.length,
                              padding: const EdgeInsets.all(16),
                              itemBuilder: (context, index) {
                                final request = controller.requests[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: RequestCard(request: request),
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
