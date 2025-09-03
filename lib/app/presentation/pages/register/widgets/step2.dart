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
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            const SizedBox(height: 16),
            CommonText("Continent", fontSize: 13, fontWeight: FontWeight.w600),
            const SizedBox(height: 8),
            AppTextField(
              hintText: 'Continent',
              controller: c.continentCtrl,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Continent required' : null,
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
                          Text(
                            c.flagEmoji.value,
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              c.dialCode.value,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 2),
                          const Icon(Icons.arrow_drop_down, size: 20),
                          // Removed trailing extra gap
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
              textCapitalization: TextCapitalization.none,
              hintText: 'Enter Email',
              controller: c.primaryEmailCtrl,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Email required';
                if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim())) {
                  return 'Invalid email';
                }
                return null;
              },
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
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Email required';
                if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim())) {
                  return 'Invalid email';
                }
                if (v.trim() == c.primaryEmailCtrl.text.trim()) {
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
          ],
          ),
        ),
      ),
    );
  }
}
