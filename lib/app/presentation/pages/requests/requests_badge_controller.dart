import 'package:get/get.dart';
import 'package:mavx_flutter/app/domain/usecases/requests_usecase.dart';

class RequestsBadgeController extends GetxController {
  final RequestsUseCase _requestsUseCase = Get.find<RequestsUseCase>();

  final RxInt pendingCount = 0.obs;
  final RxBool loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPending();
  }

  Future<void> fetchPending() async {
    try {
      loading.value = true;
      final response = await _requestsUseCase.getRequests('pending');
      pendingCount.value = (response.data?.length ?? 0);
    } catch (_) {
      // keep previous count on error
    } finally {
      loading.value = false;
    }
  }
}
