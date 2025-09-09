import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText; 
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final bool enabled;
  final bool autofocus;
  final int maxLines;
  final int? maxLength; 
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextCapitalization? textCapitalization;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged; 
  final FocusNode? focusNode;
  final bool readOnly;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final Color? borderColor;
  final TextAlign? textAlign;

  const AppTextField({  
    super.key,
    this.controller, 
    this.hintText,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.obscureText = false,
    this.enabled = true,
    this.autofocus = false,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
    this.onChanged, 
    this.focusNode,
    this.readOnly = false,
    this.onTap,
    this.margin,
    this.borderColor,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    // Light, elevated-looking fill to match the provided design
    const fillColor = Color(0xFFF2F3F7); // subtle light grey
    final borderRadius = BorderRadius.circular(8);

    return Container(
      margin: margin,
      child: TextFormField(
        maxLength: maxLength, 
        textCapitalization: textCapitalization ?? TextCapitalization.sentences,
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        inputFormatters: inputFormatters,
        obscureText: obscureText,
        enabled: enabled,
        autofocus: autofocus,
        readOnly: readOnly,
        maxLines: obscureText ? 1 : maxLines, 
        onChanged: onChanged,
        onTap: onTap,
        onTapOutside: (v) => FocusScope.of(context).unfocus(),
        validator: validator,
        textAlign: textAlign ?? TextAlign.start,
        style: const TextStyle(
          color: AppColors.textPrimaryColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          isDense: true, 
          hintText: hintText,
          hintStyle: const TextStyle(
            color: AppColors.textSecondaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          // Hide the default maxLength counter below the TextField
          counterText: '',
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          filled: true,
          fillColor: fillColor,
          // Borders: use custom borderColor if provided; otherwise none
          border: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: borderColor == null
                ? BorderSide.none
                : BorderSide(color: borderColor!, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: borderColor == null
                ? BorderSide.none
                : BorderSide(color: borderColor!, width: 1),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: borderColor == null
                ? BorderSide.none
                : BorderSide(color: borderColor!, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: borderColor == null
                ? BorderSide.none
                : BorderSide(color: borderColor!, width: 1.2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: const BorderSide(color: AppColors.errorColor, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: const BorderSide(color: AppColors.errorColor, width: 1),
          ),
        ),
        cursorColor: AppColors.textBlueColor,
      ),
    );
  }
}
