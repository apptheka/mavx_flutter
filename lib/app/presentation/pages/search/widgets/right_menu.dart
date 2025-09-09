import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/search/search_controller.dart' as search;

class RightOptionsList extends StatelessWidget {
  const RightOptionsList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<search.SearchPageController>(builder: (controller) {
      final isType = controller.leftMenuIndex.value == 0;
      if (isType) {
        final items = controller.projectTypes;
        // touch length to create a reactive dependency on the set
        final _ = controller.stagedProjectTypeIds.length;
        return ListView.separated(
          itemCount: items.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final item = items[index];
            final selected = controller.stagedProjectTypeIds.contains(item.id);
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              title: Text(item.title),
              trailing: selected
                  ? const Icon(Icons.check_circle, color: Color(0xFF0B2944))
                  : const SizedBox.shrink(),
              onTap: () => controller.toggleProjectType(item.id),
            );
          },
        );
      } else {
        final items = controller.industries;
        // touch length to create a reactive dependency on the set
        final _ = controller.stagedIndustryIds.length;
        return ListView.separated(
          itemCount: items.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final item = items[index];
            final selected = controller.stagedIndustryIds.contains(item.id);
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              title: Text(item.title),
              trailing: selected
                  ? const Icon(Icons.check_circle, color: Color(0xFF0B2944))
                  : const SizedBox.shrink(),
              onTap: () => controller.toggleIndustry(item.id),
            );
          },
        );
      }
    });
  }
}
