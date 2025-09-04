import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/register/register_controller.dart';
import 'package:mavx_flutter/app/presentation/widgets/app_text_field.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';

class RegisterStep1 extends StatelessWidget {
  const RegisterStep1({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<RegisterController>();
    return Form(
      key: c.formKeyStep1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 22),
              CommonText("First Name", fontSize: 13, fontWeight: FontWeight.w600),
              const SizedBox(height: 8),
              AppTextField(
                hintText: 'Enter First Name',
                controller: c.firstNameCtrl,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'First name required'
                    : null,
              ),
              const SizedBox(height: 12),
              CommonText("Last Name", fontSize: 13, fontWeight: FontWeight.w600),
              const SizedBox(height: 8),
              AppTextField(
                hintText: 'Enter Last Name',
                controller: c.lastNameCtrl,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Last name required' : null,
              ),
              const SizedBox(height: 12),
              CommonText("Password", fontSize: 13, fontWeight: FontWeight.w600),
              const SizedBox(height: 8),
              Obx(() => AppTextField(
                    hintText: 'Enter Password',
                    controller: c.passwordCtrl,
                    obscureText: c.isPasswordHidden.value,
                    suffixIcon: IconButton(
                      icon: Icon(
                        c.isPasswordHidden.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () => c.isPasswordHidden.toggle(),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Password required';
                      if (v.length < 6) return 'Min 6 characters';
                      return null;
                    },
                  )),
              const SizedBox(height: 16),
              CommonText(
                "Date Of Birth",
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      hintText: 'Day',
                      maxLength: 2,
                      controller: c.dayCtrl,
                      focusNode: c.dayFocus,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (v) {
                        if (v.length >= 2) {
                          FocusScope.of(context).requestFocus(c.monthFocus);
                        } else if (v.isEmpty) {
                          
                          // Focus back to previous field if available
                        }
                      },
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Day required' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppTextField(
                      hintText: 'Month',
                      maxLength: 2,
                      controller: c.monthCtrl,
                      focusNode: c.monthFocus,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (v) {
                        if (v.length >= 2) {
                          FocusScope.of(context).requestFocus(c.yearFocus);
                        } else if (v.isEmpty) {
                          FocusScope.of(context).requestFocus(c.dayFocus);
                        }
                      },
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Month required'
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppTextField(
                      hintText: 'Year',
                      maxLength: 4,
                      controller: c.yearCtrl,
                      focusNode: c.yearFocus,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (v) {
                        if (v.length >= 4) {
                          c.yearFocus.unfocus();
                        } else if (v.isEmpty) {
                          FocusScope.of(context).requestFocus(c.monthFocus);
                        }
                      },
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today_rounded),
                        color: Colors.grey[700],
                        onPressed: () => c.pickDob(context),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Year required'
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText(
                          "City/State",
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        const SizedBox(height: 8),
                        AppTextField(
                          hintText: 'City',
                          controller: c.cityCtrl,
                          validator: (v) =>
                              (v == null || v.trim().isEmpty) ? 'Required' : null,
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
                          "Country",
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        const SizedBox(height: 8),
                        AppTextField(
                          hintText: 'Country',
                          controller: c.countryCtrl,
                          validator: (v) =>
                              (v == null || v.trim().isEmpty) ? 'Required' : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 22), // bottom spacer
            ],
          ),
        ),
      ),
    );
  }
}
