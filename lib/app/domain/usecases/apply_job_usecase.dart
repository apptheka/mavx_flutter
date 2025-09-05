import 'package:mavx_flutter/app/domain/repositories/apply_job_repository.dart';

class ApplyJobUseCase {
  final ApplyJobRepository applyJobRepository;
  ApplyJobUseCase(this.applyJobRepository);

  Future<String> applyJob({
    required int projectId,
    required String encryptedRequest,
  }) async {
    return await applyJobRepository.applyJob(
      projectId: projectId,
      encryptedRequest: encryptedRequest,
    );
  }
}
