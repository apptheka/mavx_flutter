import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  // steps
  final int totalSteps = 4;
  final RxInt currentStep = 1.obs;
  // controls when to show validation errors in the UI
  final RxBool showErrors = false.obs;

  // Step form keys
  final formKeyStep1 = GlobalKey<FormState>();
  final formKeyStep2 = GlobalKey<FormState>();
  final formKeyStep3 = GlobalKey<FormState>();
  final formKeyStep4 = GlobalKey<FormState>();

  // Step 1 controllers
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final stateCtrl = TextEditingController();
  final countryCtrl = TextEditingController();
  final dayCtrl = TextEditingController();
  final monthCtrl = TextEditingController();
  final yearCtrl = TextEditingController(); 
  final experienceCtrl = TextEditingController();
  final ctcCtrl = TextEditingController();

  // Step 2 controllers (examples)
  final continentCtrl = TextEditingController();
  final mobileCtrl = TextEditingController();
  final primaryEmailCtrl = TextEditingController();

  // Step 3 controllers (examples)
  final linkedInCtrl = TextEditingController();
  final roleTypeCtrl = TextEditingController();

  // Step 4 controllers (examples)
  final idTypeCtrl = TextEditingController();

  bool get isFirstStep => currentStep.value == 1;
  bool get isLastStep => currentStep.value == totalSteps;

  void nextStep() {
    if (_validateCurrentStep()) {
      if (!isLastStep) currentStep.value++;
    }
  }

  void prevStep() {
    if (!isFirstStep) currentStep.value--;
  }

  bool _validateCurrentStep() {
    switch (currentStep.value) {
      case 1:
        return formKeyStep1.currentState?.validate() ?? false;
      case 2:
        return formKeyStep2.currentState?.validate() ?? false;
      case 3:
        return formKeyStep3.currentState?.validate() ?? false;
      case 4:
        return formKeyStep4.currentState?.validate() ?? false;
      default:
        return false;
    }
  }

  // Public wrapper for validation so UI can control when to trigger errors
  bool validateCurrentStep() => _validateCurrentStep();

  @override
  void onClose() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    passwordCtrl.dispose();
    cityCtrl.dispose();
    stateCtrl.dispose();
    countryCtrl.dispose();
    continentCtrl.dispose();
    mobileCtrl.dispose();
    primaryEmailCtrl.dispose();
    linkedInCtrl.dispose();
    roleTypeCtrl.dispose();
    idTypeCtrl.dispose();
    super.onClose();
  }
}
