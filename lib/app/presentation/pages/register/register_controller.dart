import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/domain/usecases/get_all_industries_usecase.dart';
import 'package:mavx_flutter/app/domain/usecases/get_all_specification_usecase.dart';
import 'package:mavx_flutter/app/domain/usecases/upload_file_usecase.dart';

class RegisterController extends GetxController {
  final GetAllSpecificationUseCase getAllSpecificationUseCase = Get.find<GetAllSpecificationUseCase>();
  final GetAllIndustriesUseCase getAllIndustriesUseCase = Get.find<GetAllIndustriesUseCase>();
  final UploadFileUseCase uploadFileUseCase = Get.find<UploadFileUseCase>();
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

  // Step 1 focus nodes (DOB auto-advance)
  final dayFocus = FocusNode();
  final monthFocus = FocusNode();
  final yearFocus = FocusNode();

  // Step 2 controllers (examples)
  final continentCtrl = TextEditingController();
  final mobileCtrl = TextEditingController();
  final primaryEmailCtrl = TextEditingController();
  final alternateEmailCtrl = TextEditingController();
  final experienceCtrl = TextEditingController();
  final ctcCtrl = TextEditingController();

  // Step 2 country code state
  final RxString dialCode = '+91'.obs; // default India
  final RxString flagEmoji = '🇮🇳'.obs;

  // Step 3 controllers (examples)
  final linkedInCtrl = TextEditingController(); 
  final roleTypeCtrl = ''.obs;
  final primaryFunctionCtrl = ''.obs;
  final industryCtrl = ''.obs;
  final otherPrimaryFunctionCtrl = TextEditingController();
  final currentEmployerCtrl = TextEditingController();
  final RxList<DropdownMenuItem<String>> primaryFunctionItems = <DropdownMenuItem<String>>[].obs;
  final RxList<DropdownMenuItem<String>> industryItems = <DropdownMenuItem<String>>[].obs;
  final List<DropdownMenuItem<String>> roleTypeItems = [
    DropdownMenuItem(
      value: 'Peramanent',
      child: Text('Peramanent'),
    ),
    DropdownMenuItem(
      value: 'Contract',
      child: Text('Contract'),
    ),
    DropdownMenuItem(
      value: 'Both',
      child: Text('Both'),
    ),
  ];

  // Step 4 controllers (examples)
  final idTypeCtrl = "".obs;
  final idTypeItems = [
    DropdownMenuItem(
      value: 'Aadhar',
      child: Text('Aadhar'),
    ),
    DropdownMenuItem(
      value: 'PAN',
      child: Text('PAN'),
    ),
  ];
  final secondaryFunctionCtrl = ''.obs;
  final achievementsCtrl = TextEditingController();

  // Upload states and resulting URLs
  final RxBool uploadingResume = false.obs;
  final RxBool uploadingId = false.obs;
  final RxBool uploadingProfile = false.obs;

  final RxString resumeUrl = ''.obs;
  final RxString idUrl = ''.obs;
  final RxString profileUrl = ''.obs;

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

  // Country picker for mobile dial code
  void selectCountry(BuildContext context) {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      useSafeArea: true,
      onSelect: (Country country) {
        dialCode.value = '+${country.phoneCode}';
        flagEmoji.value = country.flagEmoji;
      },
    );
  }

  // Pick date of birth using material date picker and fill day/month/year
  Future<void> pickDob(BuildContext context) async {
    // Establish a sensible initial date
    final now = DateTime.now();
    DateTime? initialDate;
    try {
      final d = int.tryParse(dayCtrl.text);
      final m = int.tryParse(monthCtrl.text);
      final y = int.tryParse(yearCtrl.text);
      if (d != null && m != null && y != null) {
        initialDate = DateTime(y, m, d);
      }
    } catch (_) {
      initialDate = null;
    }
    initialDate ??= DateTime(now.year - 18, now.month, now.day); // default ~18y old

    final firstDate = DateTime(1900, 1, 1);
    final lastDate = DateTime(now.year, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate.isBefore(firstDate) ? firstDate : initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: 'Select Date of Birth',
    );
    if (picked != null) {
      String two(int n) => n.toString().padLeft(2, '0');
      dayCtrl.text = two(picked.day);
      monthCtrl.text = two(picked.month);
      yearCtrl.text = picked.year.toString();
      // Unfocus after auto-fill
      yearFocus.unfocus();
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Load specialisations to populate primary function dropdown
    getAllSpecification();
    getAllIndustries();
  }

  Future<void> getAllSpecification() async {
    try {
      final response = await getAllSpecificationUseCase.call();
      if (response.status == 200) {
        primaryFunctionItems.assignAll(
          response.data.data.map((e) => DropdownMenuItem<String>(
                value: e.id.toString(),
                child: Text(e.title),
              )),
        );
      }
    } catch (e, st) { 
      log('getAllSpecification failed: $e', stackTrace: st);
    }
  }
  Future<void> getAllIndustries() async {
    try {
      final response = await getAllIndustriesUseCase.call();
      if (response.status == 200) {
        industryItems.assignAll(
          response.data.data.map((e) => DropdownMenuItem<String>(
                value: e.id.toString(),
                child: Text(e.title),
              )),
        );
      }
    } catch (e, st) { 
      log('getAllSpecification failed: $e', stackTrace: st);
    }
  }

  // Upload helpers. UI should pass local file paths, we upload then store URLs.
  Future<void> uploadResume(String filePath) async {
    uploadingResume.value = true;
    try {
      log('uploading resume: $filePath');
      final url = await uploadFileUseCase(
        fieldName: 'file',
        filePath: filePath,
        fields: {'type': 'resume'},
      );
      resumeUrl.value = url;
    } catch (e, st) {

      log('uploadResume failed: $e', stackTrace: st);
      rethrow;
    } finally {
      uploadingResume.value = false;
    }
  }

  Future<void> uploadIdDocument(String filePath) async {
    uploadingId.value = true;
    try {
      final url = await uploadFileUseCase(
        fieldName: 'file',
        filePath: filePath,
        fields: {'type': 'id'},
      );
      idUrl.value = url;
    } catch (e, st) {
      log('uploadIdDocument failed: $e', stackTrace: st);
      rethrow;
    } finally {
      uploadingId.value = false;
    }
  }

  Future<void> uploadProfileImage(String filePath) async {
    uploadingProfile.value = true;
    try {
      final url = await uploadFileUseCase(
        fieldName: 'file',
        filePath: filePath,
        fields: {'type': 'profile'},
      );
      profileUrl.value = url;
    } catch (e, st) {
      log('uploadProfileImage failed: $e', stackTrace: st);
      rethrow;
    } finally {
      uploadingProfile.value = false;
    }
  }

  @override
  void onClose() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    passwordCtrl.dispose();
    cityCtrl.dispose();
    stateCtrl.dispose();
    countryCtrl.dispose();
    dayCtrl.dispose();
    monthCtrl.dispose();
    yearCtrl.dispose();
    dayFocus.dispose();
    monthFocus.dispose();
    yearFocus.dispose();
    continentCtrl.dispose();
    mobileCtrl.dispose();
    primaryEmailCtrl.dispose();
    alternateEmailCtrl.dispose();
    experienceCtrl.dispose();
    ctcCtrl.dispose();
    linkedInCtrl.dispose();  
    achievementsCtrl.dispose(); 
    otherPrimaryFunctionCtrl.dispose();
    super.onClose();
  }
}
