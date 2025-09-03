import 'package:flutter/material.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';

class AppDropdown<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final String? hintText;
  final String? Function(T?)? validator;
  final ValueChanged<T?>? onChanged;
  final EdgeInsetsGeometry? margin;
  final bool isExpanded;

  const AppDropdown({
    super.key,
    required this.items,
    this.value,
    this.hintText,
    this.validator,
    this.onChanged,
    this.margin,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    const fillColor = Color(0xFFF2F3F7); // match AppTextField background
    final borderRadius = BorderRadius.circular(8);

    return Container(
      margin: margin,
      child: DropdownButtonFormField<T>(
        initialValue: value,
        isExpanded: isExpanded,
        items: items,
        selectedItemBuilder: (context) {
          // Force single-line display with ellipsis for the selected value
          return items.map((item) {
            final child = item.child;
            return Align(
              alignment: Alignment.centerLeft,
              child: DefaultTextStyle.merge(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                child: child,
              ),
            );
          }).toList();
        },
        onChanged: onChanged,
        validator: validator,
        icon: const Icon(Icons.arrow_drop_down, color: Colors.black87, size: 24),
        dropdownColor: AppColors.white, 
        style: const TextStyle(
          color: AppColors.textPrimaryColor,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          
          isDense: true,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: AppColors.textSecondaryColor,
            fontSize: 13,
            fontWeight: FontWeight.w100,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          filled: true,
          fillColor: fillColor,
          border: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide.none,
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide.none,
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
      ),
    );
  }
}
