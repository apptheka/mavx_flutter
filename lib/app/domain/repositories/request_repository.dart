import 'package:mavx_flutter/app/data/models/requests_model.dart';

abstract class RequestRepository {
  Future<RequestResponse> getRequests(String status);
  Future<RequestResponse> updateRequestStatus(
    int projectId,
    int expertId,
    String newStatus,
    String note,
  );
}