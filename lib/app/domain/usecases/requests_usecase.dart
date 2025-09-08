import 'package:mavx_flutter/app/data/models/requests_model.dart';
import 'package:mavx_flutter/app/domain/repositories/request_repository.dart';

class RequestsUseCase {
  final RequestRepository requestRepository;

  RequestsUseCase(this.requestRepository);

  Future<RequestResponse> getRequests(String status)async{
    return await requestRepository.getRequests(status);
  }

  Future<RequestResponse> updateRequestStatus(
    int projectId,
    int expertId,
    String newStatus,
    String note,
  ) async {
    return await requestRepository.updateRequestStatus(
      projectId,
      expertId,
      newStatus,
      note,
    );
  }
}
