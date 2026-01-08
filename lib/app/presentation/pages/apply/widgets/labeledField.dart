import 'package:flutter/material.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';

class LabeledField extends StatelessWidget {
  const LabeledField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.keyboardType,
    this.validator,
    this.maxLines,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 360;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(label),
        const SizedBox(height: 8),
        TextFormField(
          onTapOutside: (event){
            FocusScope.of(context).unfocus();
          },  
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          maxLines: maxLines ?? (keyboardType == TextInputType.multiline ? null : 1),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.black38),
            filled: true,
            fillColor: const Color(0xFFF5F6FA),
            contentPadding: EdgeInsets.symmetric(
              horizontal: isSmall ? 14 : 16,
              vertical: isSmall ? 12 : 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return CommonText(
      text,
      color: Colors.black87,
      fontWeight: FontWeight.w700,
    );
  }
}