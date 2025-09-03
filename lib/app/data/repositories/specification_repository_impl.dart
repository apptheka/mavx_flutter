import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:mavx_flutter/app/core/constants/app_constants.dart';
import 'package:mavx_flutter/app/core/services/extensions.dart';
import 'package:mavx_flutter/app/data/models/specifications_model.dart';
import 'package:mavx_flutter/app/data/providers/api_provider.dart';
import 'package:mavx_flutter/app/domain/repositories/specification_repository.dart';

class SpecificationRepositoryImpl implements SpecificationRepository {
  final ApiProvider apiProvider = Get.find<ApiProvider>();
  @override
  Future<JobRolesResponse> getAllSpecification() async {
    try {
      final res = await apiProvider.get(
        "${AppConstants.getAllSpecification}?page=1&limit=10",
      );
      final decriptValue = jsonDecode(res.decrypt());
      log("Decrypted Register ${decriptValue.toString()}");
      JobRolesResponse jobRolesResponse = JobRolesResponse.fromJson(decriptValue);
      return jobRolesResponse;
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }
}
