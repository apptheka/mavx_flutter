import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/register/controller/register_controller.dart';

class RegisterStep4 extends StatelessWidget {
  const RegisterStep4({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<RegisterController>();
    return Form(
      key: c.formKeyStep4,
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: SizedBox(height: 120, child: Text('Final Step (upload/ID etc.)')),
      ),
    );
  }
}
