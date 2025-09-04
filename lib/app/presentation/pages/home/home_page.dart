import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/home/home_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/home/widgets/header_widget.dart';
import 'package:mavx_flutter/app/presentation/pages/home/widgets/profile_completion_card.dart';
import 'package:mavx_flutter/app/presentation/pages/home/widgets/stats_row.dart';
import 'package:mavx_flutter/app/presentation/pages/home/widgets/section_header.dart';
import 'package:mavx_flutter/app/presentation/pages/home/widgets/job_card.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';

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
                            children: const [
                              ProfileCompletionCard(),
                              SizedBox(height: 12),
                              StatsRow(padding: EdgeInsets.zero),
                            ],
                          ),
                        ),
                        const SectionHeader(
                          title: 'Top Matches for You',
                          total: 2,
                        ),
                        const _TopMatchesList(),
                        const SectionHeader(title: 'Other Projects', total: 2),
                        const _RecommendedList(),
                        const SizedBox(height: 24),
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

class _TopMatchesList extends StatelessWidget {
  const _TopMatchesList();

  @override
  Widget build(BuildContext context) {
    final double itemWidth =
        MediaQuery.of(context).size.width - 32; // 16px side margins
    return SizedBox(
      height: 236,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        primary: false,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(width: 8),
          SizedBox(
            width: itemWidth,
            child: const JobCard(
              title: 'Digital Transformation Advisor',
              company: 'Veltrix Global',
              tags: ['On Site'],
              showApply: true,  
              compact: true,
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: itemWidth,
            child: const JobCard(
              title: 'Senior Product Designer',
              company: 'Acme Studio', 
              tags: ['Hybrid'],
              showApply: true,
              compact: true,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class _RecommendedList extends StatefulWidget {
  const _RecommendedList();

  @override
  State<_RecommendedList> createState() => _RecommendedListState();
}

class _RecommendedListState extends State<_RecommendedList> {
  int selected = 0; // 0: All, 1: On Site, 2: Remote, 3: Hybrid

  @override
  Widget build(BuildContext context) {
    final filters = ['All', 'On Site', 'Remote', 'Hybrid'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final isSelected = selected == index;
                return ChoiceChip(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 3,
                  ),
                  label: Text(filters[index]),
                  selected: isSelected,
                  showCheckmark: false,
                  onSelected: (_) => setState(() => selected = index),
                  selectedColor: AppColors.secondaryColor,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : AppColors.textSecondaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                  backgroundColor: Color(0xffe9eaeb),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                    side: BorderSide(width: 0, color: Colors.transparent),
                  ),
                );
              },
              itemCount: filters.length,
            ),
          ),
          const SizedBox(height: 12),
          // Vertical list of cards (non-scrollable, participates in main scroll)
          const JobCard(
            title: 'Business Process Analyst',
            company: 'Hybris', 
            tags: ['Hybrid'],
            showApply: true,
          ),
          const SizedBox(height: 12),
          const JobCard(
            title: 'Technical Architect - Java / Cloud',
            company: 'CloudWorks',
            tags: ['Remote', 'Hybrid'],
            showApply: true,
          ),
        ],
      ),
    );
  }
}
