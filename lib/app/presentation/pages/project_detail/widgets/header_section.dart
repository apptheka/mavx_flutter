import 'package:flutter/material.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:mavx_flutter/app/core/constants/image_assets.dart';
import 'package:mavx_flutter/app/core/constants/assets.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.greyColor,
                child: Image.asset(ImageAssets.jobLogo),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Digital Transformation Advisor',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: const [
                        Text(
                          'Vatrix Global',
                          style: TextStyle(color: AppColors.textSecondaryColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _Chip(
                text: 'Strategy',
                color: Color(0xFFF7E7D6),
              ),
              _Chip(text: 'SaaS', color: Color(0xFFF6DFDF)),
              _Chip(text: 'Remote', color: Color(0xFFDCEFE2)),
              _Chip(
                text: 'High Priority',
                color: Color(0xFFD7E6F4),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(height: 2,color: AppColors.textTertiaryColor.withValues(alpha: 0.4),thickness: 1,),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text(
                'On Site',
                style: TextStyle(
                  color: Color(0xff4fbace),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 10),
              _VSep(),
              const SizedBox(width: 10),
              const Text(
                'New York, USA',
                style: TextStyle(
                  color: AppColors.textSecondaryColor,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 10),
              _VSep(),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  '\$45K – \$55K/month',
                  style: TextStyle(
                    color: AppColors.textPrimaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'For 6 Months',
            style: TextStyle(
              color: AppColors.textPrimaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const _IconText(text: 'Posted: 1 hour ago'),
          const SizedBox(height: 10),
          Divider(height: 2,color: AppColors.textTertiaryColor.withValues(alpha: 0.4),thickness: 1,),
          const SizedBox(height: 12),
          Row(
            children: [
              _Badge(text: '92% Match', color: AppColors.lightGreen.withValues(alpha: 0.4),textColor: AppColors.green,),
              Spacer(),
              Row(
                children: [
                 Image.asset(IconAssets.badge,height: 16,width: 16,),
                 const SizedBox(width: 6,),
                 const Text('Excellent Fit',style: TextStyle(color: AppColors.green,fontWeight: FontWeight.w700,fontSize: 13),)
                ]
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  final Color color; 
  const _Chip({
    required this.text,
    this.color = const Color(0xFFEFF4F8), 
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle( 
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _VSep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 14,
      color: AppColors.textTertiaryColor.withValues(alpha: 0.4),
    );
  }
}

class _IconText extends StatelessWidget {
  final String text;
  const _IconText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.textSecondaryColor,
              fontSize: 13,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor; 
  const _Badge({
    required this.text,
    required this.color,
    this.textColor = Colors.white, 
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
