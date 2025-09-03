import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/core/constants/app_constants.dart';
import 'package:mavx_flutter/app/core/services/extensions.dart';
import 'package:mavx_flutter/app/data/models/industries_model.dart';
import 'package:mavx_flutter/app/data/providers/api_provider.dart';
import 'package:mavx_flutter/app/domain/repositories/industries_repository.dart';

class IndustriesRepositoryImpl implements IndustriesRepository {
  final ApiProvider apiProvider = Get.find<ApiProvider>();
  @override
  Future<IndustriesResponse> getAllIndustries() async {
    try {
      final res = await apiProvider.get(
        "${AppConstants.getAllIndustries}?page=1&limit=10",
      );
      final decriptValue = jsonDecode(res.decrypt());
      log("Decrypted Register ${decriptValue.toString()}");
      IndustriesResponse industriesResponse = IndustriesResponse.fromJson(decriptValue);
      return industriesResponse;
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }
}
