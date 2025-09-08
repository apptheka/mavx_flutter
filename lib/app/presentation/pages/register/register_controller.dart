import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/domain/usecases/get_all_industries_usecase.dart';
import 'package:mavx_flutter/app/domain/usecases/get_all_specification_usecase.dart';
import 'package:mavx_flutter/app/domain/usecases/upload_file_usecase.dart';
import 'package:mavx_flutter/app/domain/usecases/register_usecase.dart';
import 'package:mavx_flutter/app/presentation/widgets/snackbar.dart';

class RegisterController extends GetxController {
  final GetAllSpecificationUseCase getAllSpecificationUseCase = Get.find<GetAllSpecificationUseCase>();
  final GetAllIndustriesUseCase getAllIndustriesUseCase = Get.find<GetAllIndustriesUseCase>();
  final UploadFileUseCase uploadFileUseCase = Get.find<UploadFileUseCase>();
  final RegisterUseCase registerUseCase = Get.find<RegisterUseCase>();
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

  // Password visibility
  final RxBool isPasswordHidden = true.obs;

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
  final secondaryFactorCtrl = "".obs;
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


    bool _isValidPlatformUrl({
    required String platformType,
    required String url,
  }) {
    final trimmed = url.trim();
    final uri = Uri.tryParse(trimmed);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) return false;
    if (!(uri.scheme == 'http' || uri.scheme == 'https')) return false;

    final host = uri.host.toLowerCase();
    final p = platformType.toLowerCase();

    if (p.contains('linkedin')) {
      // Accept linkedin.com and shortener lnkd.in
      return host.endsWith('linkedin.com') || host.endsWith('lnkd.in');
    } 
    // Default allow
    return true;
  }

  // Public wrapper for validation so UI can control when to trigger errors
  bool validateCurrentStep() => _validateCurrentStep();

  // Build registration payload from the collected form fields and uploaded file URLs
  Map<String, dynamic> registerPayload() {
    String two(int n) => n.toString().padLeft(2, '0');
    String? nullIfEmpty(String? v) {
      final t = v?.trim() ?? '';
      return t.isEmpty ? null : t;
    }

    // Compose DOB yyyy-MM-dd if parts are valid
    final d = int.tryParse(dayCtrl.text);
    final m = int.tryParse(monthCtrl.text);
    final y = int.tryParse(yearCtrl.text);
    final String? dob = (d != null && m != null && y != null)
        ? '${y.toString().padLeft(4, '0')}-${two(m)}-${two(d)}'
        : null;

    // Compose phone with dial code
    final String? phone = nullIfEmpty(mobileCtrl.text) != null
        ? '${dialCode.value}${mobileCtrl.text.trim()}'
        : null;

    // Combine city/state for a simple location string
    final String location = [
      nullIfEmpty(cityCtrl.text),
      nullIfEmpty(stateCtrl.text),
    ].whereType<String>().where((e) => e.isNotEmpty).join(', ');

    // Parse integer fields where required
    int? parseInt(String? s) => int.tryParse((s ?? '').trim());

    final linkedInUrl = linkedInCtrl.text.trim();
    if (linkedInUrl.isNotEmpty && !_isValidPlatformUrl(platformType: 'linkedin', url: linkedInUrl)) {
      showSnackBar(
        title: 'Invalid LinkedIn URL',
        message: 'Please enter a valid LinkedIn URL',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      ); 
    }

    final payload = <String, dynamic>{
      'fullName': nullIfEmpty(firstNameCtrl.text),
      'lastName': nullIfEmpty(lastNameCtrl.text),
      'password': nullIfEmpty(passwordCtrl.text),
      'dob': dob,
      'location': nullIfEmpty(location),
      'country': nullIfEmpty(countryCtrl.text),
      'continent': nullIfEmpty(continentCtrl.text),
      'phone': phone,
      'email': nullIfEmpty(primaryEmailCtrl.text),
      'alternateEmail': nullIfEmpty(alternateEmailCtrl.text),
      'experience': parseInt(experienceCtrl.text),
      'ctc': nullIfEmpty(ctcCtrl.text),
      'linkedin': nullIfEmpty(linkedInUrl), 
      'roleType': nullIfEmpty(roleTypeCtrl.value),
      'primaryFunction': parseInt(primaryFunctionCtrl.value),
      'customPrimaryFunction': nullIfEmpty(otherPrimaryFunctionCtrl.text),
      'primarySector': parseInt(industryCtrl.value),
      'customPrimarySector': null, // no UI yet; keep for API compatibility
      'employer': nullIfEmpty(currentEmployerCtrl.text),
      'secondaryFunction': parseInt(secondaryFunctionCtrl.value),
      'secondarySector': null, // not captured in UI currently
      'achievements': nullIfEmpty(achievementsCtrl.text), 
      'resume': nullIfEmpty(resumeUrl.value),
      'idType': nullIfEmpty(idTypeCtrl.value),
      'idFile': nullIfEmpty(idUrl.value),
      'profile': nullIfEmpty(profileUrl.value),
    };

    // Remove nulls to avoid sending empty fields
    payload.removeWhere((key, value) => value == null);
    return payload;
  }

  // Submit registration by sending only the JSON payload (files are already uploaded)
  Future<void> submitRegistration() async {
    try {
      // Optionally ensure final step is valid before submit
      if (!validateCurrentStep()) return;

      final payload = registerPayload();
      log('register payload: ' + payload.toString());
      final result = await registerUseCase.call(payload);
      log('register status: ${result.status}, message: ${result.message}');
      if (result.status == 200) {
        final status = result.data?.status?.toLowerCase();
        if (status == 'pending') {
          await _showPendingDialog();
          // After acknowledging, send user to login
          Get.offAllNamed('/login');
        } else {
          // Consider any non-pending as approved
          Get.offAllNamed('/home');
        }
      }else if(result.status == 400){
        Get.snackbar(
          'Error',
          'Email and phone number must be unique',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          barBlur: 20,
          animationDuration: const Duration(seconds: 2),
          colorText: Colors.white,
        );
      }
    } catch (e, st) {
      log('submitRegistration failed: $e', stackTrace: st);
      rethrow;
    }
  }

  Future<void> _showPendingDialog() async {
    return Get.dialog(
      AlertDialog(
        title: const Text('Profile Under Review'),
        content: const Text(
          'Your profile is under review. You will be notified once approved. You can log in after approval.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

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
