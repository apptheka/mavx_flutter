import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/getStarted/get_started_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/getStarted/widget/progress_dot.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';

class GetStartedPage extends GetView<GetStartedController> {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;
    final bottomCardHeight = isSmallScreen
        ? size.height * 0.52
        : size.height * 0.45;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          // Top image background
          Positioned.fill(
            top: 0,
            bottom: size.height * 0.4,
            child: PageView.builder(
              controller: controller.pageController,
              onPageChanged: controller.onPageChanged,
              itemCount: controller.items.length,
              itemBuilder: (_, i) =>
                  Image.asset(controller.items[i].image, fit: BoxFit.cover),
            ),
          ),
          // Top gradient shadow to highlight Skip button
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Container(
                height: 140,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.25),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Skip button (top-right)
          Positioned(
            top: MediaQuery.of(context).viewPadding.top,
            right: 16,
            child: TextButton(
              onPressed: controller.skipToLast,
              child: const CommonText(
                'Skip',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white, 
              ),
            ),
          ),

          // Bottom Card
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: double.infinity,
              height: bottomCardHeight,
              padding: EdgeInsets.fromLTRB(
                20,
                isSmallScreen ? 16 : 24,
                20,
                (isSmallScreen ? 16 : 24) +
                    MediaQuery.of(context).viewPadding.bottom,
              ),
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(36),
                  topRight: Radius.circular(36),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 16,
                    offset: Offset(0, -6),
                  ),
                ],
              ),
              child: Obx(() {
                final idx = controller.current.value;
                final item = controller.items[idx];
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      item.eyebrow,
                      fontSize: isSmallScreen ? 12 : 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                    SizedBox(height: isSmallScreen ? 6 : 8),
                    CommonText(
                      item.title,
                      fontSize: isSmallScreen ? 24 : 28,
                      lineHeight: 1.25,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.1,
                      color: AppColors.secondaryColor,
                    ),

                    SizedBox(height: isSmallScreen ? 8 : 10),
                    CommonText(
                      item.body,
                      color: AppColors.textPrimaryColor,
                      fontSize: isSmallScreen ? 14 : 17,
                      lineHeight: 1.25,
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(height: isSmallScreen ? 16 : 24),
                    const Spacer(),

                    // Back + CTA
                    if (controller.current.value > 0)
                      Row(
                        children: [
                          // Back circle button
                          InkWell(
                            onTap: controller.prev,
                            borderRadius: BorderRadius.circular(28),
                            child: Container(
                              width: isSmallScreen ? 44 : 48,
                              height: isSmallScreen ? 44 : 48,
                              decoration: BoxDecoration(
                                color: AppColors.greyColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.arrow_back,
                                color: AppColors.black,
                                size: isSmallScreen ? 20 : 22,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Next/Get Started button
                          Expanded(
                            child: SizedBox(
                              height: isSmallScreen ? 48 : 56,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: controller.next,
                                child: CommonText(
                                  controller.isLast ? 'Get Started' : 'Next',
                                  fontSize: isSmallScreen ? 16 : 17,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white,
                                  ),
                                ), 
                            ),
                          ),
                        ],
                      )
                    else
                      SizedBox(
                        width: double.infinity,
                        height: isSmallScreen ? 48 : 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                            elevation: 0,
                          ),
                          onPressed: controller.next,
                          child: Text(
                            controller.isLast ? 'Next' : 'Get Started',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isSmallScreen ? 16 : 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),

                    SizedBox(height: isSmallScreen ? 12 : 40),

                    // Page indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        controller.items.length,
                        (i) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: ProgressDot(active: i == idx),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
