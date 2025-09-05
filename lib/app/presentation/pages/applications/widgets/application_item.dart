import 'package:flutter/material.dart';
import 'package:mavx_flutter/app/data/models/projects_model.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';

class ApplicationItem extends StatelessWidget {
  final ProjectModel project;
  final bool applied;
  final VoidCallback? onTap;

  const ApplicationItem({super.key, required this.project, required this.applied, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: const Color(0xFFE6E9EF)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Leading dot/avatar
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFEFF3FF),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.work_outline, color: Color(0xFF3B82F6)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: CommonText(
                          project.projectTitle ?? 'Untitled Project',
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimaryColor,
                        ),
                      ),
                      if (applied)
                        const Row(
                          children: [
                            Icon(Icons.verified_rounded, size: 18, color: Color(0xFF3B82F6)),
                            SizedBox(width: 4),
                            Text('Applied', style: TextStyle(color: Color(0xFF3B82F6), fontWeight: FontWeight.w700)),
                          ],
                        )
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.category_outlined, size: 14, color: Colors.black45),
                      const SizedBox(width: 4),
                      CommonText(
                        project.projectType ?? 'N/A',
                        fontSize: 12,
                        color: AppColors.textSecondaryColor,
                      ),
                    ],
                  ),
                  if ((project.description ?? '').isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      project.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
