import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mavx_flutter/app/domain/usecases/apply_job_usecase.dart';

import 'package:mavx_flutter/app/domain/usecases/upload_file_usecase.dart';
import 'package:mavx_flutter/app/domain/repositories/auth_repository.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/profile_controller.dart';
import 'package:mavx_flutter/app/core/constants/app_constants.dart';
import 'package:mavx_flutter/app/core/services/extensions.dart';
import 'package:mavx_flutter/app/domain/usecases/projects_usecase.dart';
import 'package:mavx_flutter/app/data/models/projects_model.dart';

class ApplyController extends GetxController {
  ApplyController({
    UploadFileUseCase? uploadFileUseCase,
    ApplyJobUseCase? applyJobUseCase,
    AuthRepository? authRepository,
    ProjectsUseCase? projectsUseCase,
  }) : _uploadFileUseCase = uploadFileUseCase ?? Get.find<UploadFileUseCase>(),
       _applyJobUseCase = applyJobUseCase ?? Get.find<ApplyJobUseCase>(),
       _authRepository = authRepository ?? Get.find<AuthRepository>(),
       _projectsUseCase = projectsUseCase ?? Get.find<ProjectsUseCase>();

  final UploadFileUseCase _uploadFileUseCase;
  final ApplyJobUseCase _applyJobUseCase;
  final AuthRepository _authRepository;
  final ProjectsUseCase _projectsUseCase;

  final TextEditingController perHourCostCtrl = TextEditingController();
  final TextEditingController currentCtcCtrl = TextEditingController();
  final TextEditingController expectedCtcCtrl = TextEditingController();
  final TextEditingController aboutYouCtrl = TextEditingController();
  final TextEditingController holdingOfferCtrl = TextEditingController();
  final TextEditingController availabilityWeekCtrl = TextEditingController();
  final TextEditingController availabilityDayCtrl = TextEditingController();

  final RxBool uploading = false.obs;
  final RxString uploadedFileName = ''.obs;
  final RxString uploadedUrl = ''.obs;
  final RxString existingResumeUrl = ''.obs;
  final RxBool applying = false.obs;
  late final int projectId;
  final Rxn<ProjectModel> project = Rxn<ProjectModel>();
  final RxBool loadingProject = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Read project id from navigation args
    final arg = Get.arguments;
    if (arg is int) {
      projectId = arg;
    } else {
      projectId = 0;
    }
    // Load project details for header
    if (projectId != 0) {
      _loadProject();
    }
    // Seed existing resume from ProfileController
    if (Get.isRegistered<ProfileController>()) {
      final pc = Get.find<ProfileController>();
      final raw = pc.registeredProfile.value.resume ?? '';
      if (raw.isNotEmpty) {
        existingResumeUrl.value = _prefixBaseUrl(raw);
      }
    }
  }

  Future<void> _loadProject() async {
    try {
      loadingProject.value = true;
      final resp = await _projectsUseCase.projectById(projectId);
      if (resp.data != null && resp.data!.isNotEmpty) {
        project.value = resp.data!.first;
      }
    } catch (e) {
      // ignore but keep UI robust
    } finally {
      loadingProject.value = false;
    }
  }

  String _prefixBaseUrl(String path) {
    if (path.startsWith('http')) return path;
    return '${AppConstants.baseUrl}$path';
  }

  Future<void> pickAndUpload() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );
      if (result == null || result.files.isEmpty) return;

      final file = result.files.single;
      final path = file.path;
      if (path == null) {
        Get.snackbar('Error', 'Unable to read selected file path');
        return;
      }

      uploading.value = true;
      uploadedFileName.value = file.name;

      // Upload the file. Field name can be adjusted if backend expects a specific key.
      final url = await _uploadFileUseCase(
        fieldName: 'document',
        filePath: path,
        fields: {
          // You can pass additional fields if needed by the backend
          'type': 'cv',
        },
      );
      uploadedUrl.value = url;
      existingResumeUrl.value = url;

      Get.snackbar('Success', 'File uploaded successfully');
    } catch (e) {
      Get.snackbar('Upload Failed', e.toString());
    } finally {
      uploading.value = false;
    }
  }

  Future<void> apply() async {
    try {
      applying.value = true;
      final currentUser = await _authRepository.getCurrentUser();
      final uid = currentUser?.data.id ?? 0;
      if (uid == 0 || projectId == 0) {
        Get.snackbar('Error', 'Missing user or project information');
        return;
      }

      // Build payload similar to web; encrypt via extension
      final payload = {
        'user_id': uid,
        'current_ctc': currentCtcCtrl.text.trim(),
        'expected_ctc': expectedCtcCtrl.text.trim(),
        'updated_cv': (uploadedUrl.value.isNotEmpty
            ? uploadedUrl.value
            : existingResumeUrl.value),
        'about_you': aboutYouCtrl.text.trim(),
        'holding_offer': int.tryParse(holdingOfferCtrl.text.trim()) ?? 0,
        'project_id': projectId,
        'per_hour_cost': int.tryParse(perHourCostCtrl.text.trim()) ?? 0,
        'week_available': int.tryParse(availabilityWeekCtrl.text.trim()) ?? 0,
        'time_available': availabilityDayCtrl.text.trim(),
      };
      final encrypted = payload.toJsonRequest().encript();

      final result = await _applyJobUseCase.applyJob(
        projectId: projectId,
        encryptedRequest: encrypted,
      );
      Get.snackbar(
        'Applied',
        result.isNotEmpty ? result : 'Application submitted',
      );
    } catch (e) {
      Get.snackbar('Apply Failed', e.toString());
    } finally {
      applying.value = false;
    }
  }

  @override
  void onClose() {
    perHourCostCtrl.dispose();
    availabilityWeekCtrl.dispose();
    availabilityDayCtrl.dispose();
    super.onClose();
  }
}
