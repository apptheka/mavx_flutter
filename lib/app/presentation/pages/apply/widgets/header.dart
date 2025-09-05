import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.titleSize,
    required this.subtitleSize,
    this.title,
    this.company,
    this.projectType,
  });

  final double titleSize;
  final double subtitleSize;
  final String? title;
  final String? company;
  final String? projectType;

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.of(context).size.width < 360;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Avatar-like placeholder
        Container(
          width: isNarrow ? 48 : 56,
          height: isNarrow ? 48 : 56,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFEFF3FF),
          ),
          alignment: Alignment.center,
          child: Container(
            width: isNarrow ? 16 : 18,
            height: isNarrow ? 16 : 18,
            decoration: const BoxDecoration(
              color: Color(0xFF3B82F6),
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (title?.trim().isNotEmpty == true ? title! : 'Project') + '\n' + (company?.trim().isNotEmpty == true ? company! : 'Company'),
                style: TextStyle(
                  fontSize: titleSize,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0B2944),
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                runSpacing: 4,
                spacing: 8,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.badge_outlined, size: 14, color: Colors.black45),
                      SizedBox(width: 4),
                      // Company already shown in title line above; keeping badge as a visual element
                      Text('', style: TextStyle(color: Colors.black54, fontSize: 12)),
                    ],
                  ),
                  Container(
                    width: 2,
                    height: 12,
                    color: Colors.black12,
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Project Type : ',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: subtitleSize,
                      ),
                      children: [
                        TextSpan(
                          text: projectType?.trim().isNotEmpty == true ? projectType! : 'N/A',
                          style: TextStyle(
                            color: Color(0xFF3B82F6),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}