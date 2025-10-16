import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/domain/usecases/get_all_industries_usecase.dart';
import 'package:mavx_flutter/app/domain/usecases/get_all_specification_usecase.dart';
import 'package:mavx_flutter/app/domain/usecases/upload_file_usecase.dart';
import 'package:mavx_flutter/app/domain/usecases/register_usecase.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';
import 'package:mavx_flutter/app/presentation/widgets/snackbar.dart';
import 'package:mavx_flutter/app/routes/app_routes.dart';

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
  final dobCtrl = TextEditingController();
  final dayCtrl = TextEditingController();
  final monthCtrl = TextEditingController();
  final yearCtrl = TextEditingController();

  // Password visibility
  final RxBool isPasswordHidden = true.obs;

  // Step 1 focus nodes (DOB auto-advance)
  final dayFocus = FocusNode();
  final monthFocus = FocusNode();
  final yearFocus = FocusNode();
  // Step 1 ordered focus nodes
  final fnFirstName = FocusNode();
  final fnLastName = FocusNode();
  final fnPassword = FocusNode();
  final fnDob = FocusNode();
  final fnCity = FocusNode();
  final fnCountry = FocusNode();

  // Step 2 controllers (examples)
  final continentCtrl = TextEditingController();
  final mobileCtrl = TextEditingController();
  final primaryEmailCtrl = TextEditingController();
  final alternateEmailCtrl = TextEditingController();
  final experienceCtrl = TextEditingController();
  final ctcCtrl = TextEditingController();
  final skillsCtrl = TextEditingController();
  // Step 2 ordered focus nodes
  final fnContinent = FocusNode();
  final fnMobile = FocusNode();
  final fnPrimaryEmail = FocusNode();
  final fnAlternateEmail = FocusNode();
  final fnExperience = FocusNode();
  final fnCtc = FocusNode();
  final fnSkills = FocusNode();

  // Step 2 country code state
  final RxString dialCode = '+91'.obs; // default India
  final RxString flagEmoji = '🇮🇳'.obs;

  // Step 3 controllers (examples)
  final linkedInCtrl = TextEditingController(); 
  final roleTypeCtrl = ''.obs;
  final primaryFunctionCtrl = ''.obs; 
  final industryCtrl = ''.obs;
  final otherPrimaryFunctionCtrl = TextEditingController();
  final otherPrimaryIndustryCtrl = TextEditingController();
  final currentEmployerCtrl = TextEditingController();
  final RxList<DropdownMenuItem<String>> primaryFunctionItems = <DropdownMenuItem<String>>[].obs;
  final RxList<DropdownMenuItem<String>> secondaryFunction = <DropdownMenuItem<String>>[].obs;
  final RxList<DropdownMenuItem<String>> industryItems = <DropdownMenuItem<String>>[].obs;
  // Step 3 ordered focus nodes
  final fnLinkedIn = FocusNode();
  final fnOtherPrimaryFunction = FocusNode();
  final fnOtherIndustry = FocusNode();
  final fnCurrentEmployer = FocusNode();
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
  // Step 4 focus nodes
  final fnAchievements = FocusNode();

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
    String? dob;
    if (d != null && m != null && y != null) {
      try {
        final candidate = DateTime(y, m, d);
        final isSame = candidate.year == y && candidate.month == m && candidate.day == d;
        final now = DateTime.now();
        final notFuture = !candidate.isAfter(DateTime(now.year, now.month, now.day));
        if (isSame && notFuture) {
          dob = '${y.toString().padLeft(4, '0')}-${two(m)}-${two(d)}';
        }
      } catch (_) {}
    }

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

    // Normalize skills into a consistent comma-separated string
    String? normalizeSkillsCsv(String? raw) {
      final input = raw ?? '';
      final tokens = input
          .split(RegExp(r'[\n,]+'))
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      if (tokens.isEmpty) return null;
      return tokens.join(', ');
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
      'skills_csv': normalizeSkillsCsv(skillsCtrl.text),
      'linkedin': nullIfEmpty(linkedInUrl), 
      'roleType': nullIfEmpty(roleTypeCtrl.value),
      'primaryFunction': parseInt(primaryFunctionCtrl.value),
      'customPrimaryFunction': nullIfEmpty(otherPrimaryFunctionCtrl.text),
      'customPrimaryIndustry': nullIfEmpty(otherPrimaryIndustryCtrl.text),
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
          Get.offNamed('/login');
        } else {
          // Consider any non-pending as approved
          Get.offNamed('/home');
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
    Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 8,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon with animation
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.hourglass_empty,
                size: 40,
                color: Colors.orange.shade600,
              ),
            ),
            const SizedBox(height: 20),
            
            // Title
            CommonText(
              'Profile Under Review',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
            const SizedBox(height: 16),
            
            // Content with better formatting
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.blue.shade100,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue.shade600,
                    size: 24,
                  ),
                  const SizedBox(height: 8),
                  CommonText(
                    'Your profile is currently being reviewed by our team.',
                    fontSize: 16,
                    color: Colors.grey.shade700,
                  ),
                  const SizedBox(height: 8),
                  CommonText(
                    'You\'ll receive a notification once approved and can log in afterward.',
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ), 
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Enhanced button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.offAllNamed(AppRoutes.login),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: CommonText(
                  'Got it',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
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
    // Clamp initialDate within [firstDate, lastDate] to satisfy showDatePicker constraints
    DateTime clampedInitial = initialDate;
    if (clampedInitial.isBefore(firstDate)) clampedInitial = firstDate;
    if (clampedInitial.isAfter(lastDate)) clampedInitial = lastDate;

    final safeContext = Get.context ?? context;
    final picked = await showDatePicker(
      context: safeContext,
      initialDate: clampedInitial,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: 'Select Date of Birth',
    );
    if (picked != null) {
      String two(int n) => n.toString().padLeft(2, '0');
      dayCtrl.text = two(picked.day);
      monthCtrl.text = two(picked.month);
      yearCtrl.text = picked.year.toString();
      dobCtrl.text = '${two(picked.day)}/${two(picked.month)}/${picked.year}';
      // Unfocus after auto-fill
      yearFocus.unfocus();
    }
  }

  // ================= DOB VALIDATION HELPERS =================
  int? _toInt(String? s) => int.tryParse((s ?? '').trim());

  int _daysInMonth(int year, int month) {
    // Using DateTime roll-over to get last day of month
    // DateTime(year, month + 1, 0) gives the last day of the target month
    return DateTime(year, month + 1, 0).day;
  }

  String? validateDay(String? v) {
    final now = DateTime.now();
    final day = _toInt(v);
    if (v == null || v.trim().isEmpty) return 'Day required';
    if (day == null) return 'Invalid day';
    if (day < 1 || day > 31) return 'Day must be 1-31';

    final m = _toInt(monthCtrl.text);
    final y = _toInt(yearCtrl.text);
    if (m != null && y != null && m >= 1 && m <= 12) {
      final maxDay = _daysInMonth(y, m);
      if (day > maxDay) return 'Max $maxDay days in $m/$y';
      // Do not allow future date within current year/month
      if (y == now.year && m == now.month && day > now.day) {
        return 'Date cannot be in the future';
      }
    }
    return null;
  }

  // ================= CONTACT VALIDATION HELPERS =================
  // Email simple RFC-like pattern
  final RegExp _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  // LinkedIn URL: allow linkedin.com/* or lnkd.in/* with http/https
  final RegExp _linkedinRegex = RegExp(
    r'^(https?:\/\/)?(www\.)?(linkedin\.com\/(in|company|pub|school|jobs|profile)\/[^\s]+|lnkd\.in\/[^\s]+)\/?$',
    caseSensitive: false,
  );

  String? validateEmail(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Email required';
    if (!_emailRegex.hasMatch(value)) return 'Invalid email';
    return null;
  }

  String? validateLinkedIn(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'LinkedIn URL required';
    // Require scheme
    final withScheme = value.startsWith('http://') || value.startsWith('https://')
        ? value
        : 'https://$value';
    if (!_linkedinRegex.hasMatch(withScheme)) {
      return 'Enter a valid LinkedIn URL (e.g., https://www.linkedin.com/in/username or https://lnkd.in/...)';
    }
    return null;
  }

  String? validateDob(String? v) {
    // Use the same rules as composing dob in payload: real date and not future
    if (v == null || v.trim().isEmpty) return 'Date of birth required';
    final d = int.tryParse(dayCtrl.text);
    final m = int.tryParse(monthCtrl.text);
    final y = int.tryParse(yearCtrl.text);
    if (d == null || m == null || y == null) return 'Invalid date of birth';
    try {
      final candidate = DateTime(y, m, d);
      final same = candidate.year == y && candidate.month == m && candidate.day == d;
      final now = DateTime.now();
      final notFuture = !candidate.isAfter(DateTime(now.year, now.month, now.day));
      if (!same || !notFuture) return 'Invalid date of birth';
    } catch (_) {
      return 'Invalid date of birth';
    }
    return null;
  }

  String? validateMonth(String? v) {
    final now = DateTime.now();
    final month = _toInt(v);
    if (v == null || v.trim().isEmpty) return 'Month required';
    if (month == null) return 'Invalid month';
    if (month < 1 || month > 12) return 'Month must be 1-12';

    final y = _toInt(yearCtrl.text);
    final d = _toInt(dayCtrl.text);
    if (y != null) {
      if (y > now.year) return 'Year cannot exceed ${now.year}';
      if (y == now.year && month > now.month) {
        return 'Date cannot be in the future';
      }
      if (d != null) {
        final maxDay = _daysInMonth(y, month);
        if (d > maxDay) return 'Max $maxDay days in $month/$y';
      }
    }
    return null;
  }

  String? validateYear(String? v) {
    final now = DateTime.now();
    final year = _toInt(v);
    if (v == null || v.trim().isEmpty) return 'Year required';
    if (year == null) return 'Invalid year';
    if (year < 1900) return 'Year must be >= 1900';
    if (year > now.year) return 'Year cannot exceed ${now.year}';

    final m = _toInt(monthCtrl.text);
    final d = _toInt(dayCtrl.text);
    if (m != null && d != null && m >= 1 && m <= 12) {
      final maxDay = _daysInMonth(year, m);
      if (d < 1 || d > maxDay) return 'Invalid date';
      final picked = DateTime(year, m, d);
      final lastAllowed = DateTime(now.year, now.month, now.day);
      if (picked.isAfter(lastAllowed)) return 'Date cannot be in the future';
    }
    return null;
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
    // Ensure no text field remains focused as controllers are about to be disposed
    FocusManager.instance.primaryFocus?.unfocus();
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    passwordCtrl.dispose();
    cityCtrl.dispose();
    stateCtrl.dispose();
    countryCtrl.dispose();
    dobCtrl.dispose();
    dayCtrl.dispose();
    monthCtrl.dispose();
    yearCtrl.dispose();
    dayFocus.dispose();
    monthFocus.dispose();
    yearFocus.dispose();
    fnFirstName.dispose();
    fnLastName.dispose();
    fnPassword.dispose();
    fnDob.dispose();
    fnCity.dispose();
    fnCountry.dispose();
    continentCtrl.dispose();
    mobileCtrl.dispose();
    primaryEmailCtrl.dispose();
    alternateEmailCtrl.dispose();
    experienceCtrl.dispose();
    ctcCtrl.dispose();
    fnContinent.dispose();
    fnMobile.dispose();
    fnPrimaryEmail.dispose();
    fnAlternateEmail.dispose();
    fnExperience.dispose();
    fnCtc.dispose();
    fnSkills.dispose();
    fnLinkedIn.dispose();
    fnOtherPrimaryFunction.dispose();
    fnOtherIndustry.dispose();
    fnCurrentEmployer.dispose();
    fnAchievements.dispose();
    linkedInCtrl.dispose();  
    achievementsCtrl.dispose(); 
    otherPrimaryFunctionCtrl.dispose();
    otherPrimaryIndustryCtrl.dispose();
    skillsCtrl.dispose();
    super.onClose();
  }
}
