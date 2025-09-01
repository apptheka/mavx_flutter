import 'package:flutter/material.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';

class CommonText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final FontStyle? fontStyle;
  final double? letterSpacing;
  final double? lineHeight;
  final TextDecoration? decoration;
  final double? opacity;
  final bool? isLineThrough;
  

  const CommonText(
    this.text, {
    super.key,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontStyle,
    this.letterSpacing,
    this.lineHeight,
    this.decoration,
    this.opacity,
    this.isLineThrough = false, // Default value here
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity ?? 1.0,
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Inter Tight',
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          fontStyle: fontStyle,
          letterSpacing: letterSpacing,
          height: lineHeight,
          decoration: isLineThrough == true ? TextDecoration.lineThrough : decoration,
          decorationThickness: 2,
          decorationStyle: TextDecorationStyle.solid,
          decorationColor: AppColors.textTertiaryColor,
        ),
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }
} 