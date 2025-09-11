import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/data/models/requests_model.dart';
import 'package:mavx_flutter/app/domain/usecases/requests_usecase.dart';
import 'package:mavx_flutter/app/presentation/widgets/snackbar.dart';

class RequestsController extends GetxController {
  final RequestsUseCase _requestsUseCase = Get.find<RequestsUseCase>();

  // Observable variables
  final RxList<RequestData> requests = <RequestData>[].obs;
  final RxBool loading = false.obs;
  final RxString error = ''.obs;
  final RxString selectedStatus = 'pending'.obs;

  // Status options
  final List<String> statusOptions = ['pending', 'accepted', 'rejected'];

  @override
  void onInit() {
    super.onInit();
    fetchRequests();
  }

  void changeStatus(String status) {
    selectedStatus.value = status;
    fetchRequests();
  }

  Future<void> fetchRequests() async {
    try {
      loading.value = true;
      error.value = '';
      
      final response = await _requestsUseCase.getRequests(selectedStatus.value);
      print('API Response: ${response.toJson()}'); // Debug log
      requests.value = response.data ?? [];
      print('Requests count: ${requests.length}'); // Debug log
    } catch (e) {
      print('Error fetching requests: $e'); // Debug log
      error.value = 'Failed to load requests: ${e.toString()}';
      requests.clear();
    } finally {
      loading.value = false;
    }
  }

  Future<void> refreshRequests() async {
    await fetchRequests();
  }

  Future<void> updateRequestStatus(
    int projectId,
    int expertId,
    String newStatus,
    String note,
  ) async {
    try {
      loading.value = true;
    
      await _requestsUseCase.updateRequestStatus(
        projectId,
        expertId,
        newStatus,
        note,
      );
      showSnackBar(
        title: 'Updated',
        message: 'Request updated',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      await fetchRequests();
    } catch (e) {
      error.value = 'Failed to update request: ${e.toString()}';
    } finally {
      loading.value = false;
    }
  }
}
