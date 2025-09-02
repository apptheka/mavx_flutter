import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/register/controller/register_controller.dart';
import 'package:mavx_flutter/app/presentation/widgets/app_text_field.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';

class RegisterStep3 extends StatelessWidget {
  const RegisterStep3({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<RegisterController>();
    return Form(
      key: c.formKeyStep3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            const CommonText('LinkedIn Profile URL', fontSize: 13, fontWeight: FontWeight.w600),
            const SizedBox(height: 8),
            AppTextField(
              hintText: 'Enter URL',
              keyboardType: TextInputType.url,
              controller: c.linkedInCtrl,
              validator: (v) {
                final value = v?.trim() ?? '';
                if (value.isEmpty) return 'URL required';
                if (!RegExp(r'^(https?:\/\/)?[^\s.]+\.[^\s]{2,}').hasMatch(value)) return 'Invalid URL';
                return null;
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
