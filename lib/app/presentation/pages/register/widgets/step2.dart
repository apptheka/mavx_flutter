import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/register/register_controller.dart';
import 'package:mavx_flutter/app/presentation/widgets/app_text_field.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';

class RegisterStep2 extends StatelessWidget {
  const RegisterStep2({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<RegisterController>();
    return Form(
      key: c.formKeyStep2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CommonText("Continent", fontSize: 13, fontWeight: FontWeight.w600),
               SizedBox(height: 8),
              AppTextField(
                textCapitalization:  TextCapitalization.sentences,
                keyboardType: TextInputType.name,
                focusNode: c.fnContinent,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(c.fnMobile),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z ]')),
                ],
                hintText: 'Continent',
                controller: c.continentCtrl,
                validator: (v) {
                  final value = v?.trim() ?? '';
                  if (value.isEmpty) return 'Continent required';
                  if (!RegExp(r'^[A-Za-z ]+$').hasMatch(value)) {
                    return 'Only letters and spaces allowed';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CommonText("Mobile", fontSize: 13, fontWeight: FontWeight.w600),
              const SizedBox(height: 8),
              Obx(() {
                final screenWidth = MediaQuery.of(context).size.width;
                // Make the country-code area more compact to reduce gap
                final prefixWidth = (screenWidth * 0.26).clamp(74.0, 105.0).toDouble();
                return AppTextField(
                  maxLength: 10,
                  hintText: 'Enter Mobile',
                  controller: c.mobileCtrl,
                  keyboardType: TextInputType.number,
                  focusNode: c.fnMobile,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(c.fnPrimaryEmail),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  prefixIcon: SizedBox(
                    width: prefixWidth,
                    child: InkWell(
                      onTap: () => c.selectCountry(context),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CommonText(
                              c.flagEmoji.value,
                              fontSize: 18,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: CommonText(
                                c.dialCode.value,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 2),
                            const Icon(Icons.arrow_drop_down, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                  validator: (v) {
                    final value = v?.trim() ?? '';
                    if (value.isEmpty) return 'Mobile required';
                    if (!RegExp(r'^[0-9]{7,15}$').hasMatch(value)) {
                      return 'Invalid mobile';
                    }
                    return null;
                  },
                );
  }),
            const SizedBox(height: 16),
              CommonText("Email", fontSize: 13, fontWeight: FontWeight.w600),
              const SizedBox(height: 8),
              AppTextField(
                hintText: 'Enter Email',
                controller: c.primaryEmailCtrl,
                keyboardType: TextInputType.emailAddress,
                focusNode: c.fnPrimaryEmail,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(c.fnAlternateEmail),
                validator: c.validateEmail,
              ),
              const SizedBox(height: 16),
              CommonText(
                "Alternate Email",
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 8),
              AppTextField(
                hintText: 'Enter Alternate Email',
                controller: c.alternateEmailCtrl,
                keyboardType: TextInputType.emailAddress,
                focusNode: c.fnAlternateEmail,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(c.fnExperience),
                validator: (v) {
                  final err = c.validateEmail(v);
                  if (err != null) return err;
                  if ((v ?? '').trim() == c.primaryEmailCtrl.text.trim()) {
                    return 'Email cannot be same as primary email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText(
                          "Total Experience(Years)",
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        const SizedBox(height: 8),
                        AppTextField(
                          hintText: 'Enter Experience',
                          controller: c.experienceCtrl,
                          focusNode: c.fnExperience,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(c.fnCtc),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Experience required'
                              : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText(
                          "CTC (Month/Week/Day)",
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        const SizedBox(height: 8),
                        AppTextField(
                          hintText: 'Enter CTC',
                          controller: c.ctcCtrl,
                          focusNode: c.fnCtc,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(c.fnSkills),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'CTC required'
                              : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CommonText("Skills", fontSize: 13, fontWeight: FontWeight.w600),
              const SizedBox(height: 8),
              AppTextField(
                hintText: 'e.g., JavaScript, React',
                controller: c.skillsCtrl,
                textCapitalization: TextCapitalization.words,
                focusNode: c.fnSkills,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  final ctrl = Get.find<RegisterController>();
                  if (ctrl.validateCurrentStep()) {
                    ctrl.nextStep();
                  } else {
                    FocusScope.of(context).unfocus();
                  }
                },
                inputFormatters: [
                  // prevent actual newlines; we only want comma-separated input
                  FilteringTextInputFormatter.deny(RegExp(r'\n')),
                ],
                validator: (v) {
                  final raw = (v ?? '').trim();
                  final tokens = raw
                      .split(RegExp(r'[\n,]+'))
                      .map((e) => e.trim())
                      .where((e) => e.isNotEmpty)
                      .toList();
                  if (tokens.isEmpty) {
                    return 'Please enter at least one skill';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 6),
              const CommonText(
                'Tip: Separate multiple skills with commas. Example: JavaScript, React, Node.js',
                fontSize: 12,
                color: Colors.black54,
              ),
              const SizedBox(height: 16),
          ],
          ),
        ),
      ),
    );
  }
}
