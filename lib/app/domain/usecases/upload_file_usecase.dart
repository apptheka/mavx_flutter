import 'package:mavx_flutter/app/domain/repositories/file_repository.dart';

class UploadFileUseCase {
  final FileRepository _repo;
  UploadFileUseCase(this._repo);

  Future<String> call({
    required String fieldName,
    required String filePath,
    Map<String, String>? fields,
  }) {
    return _repo.uploadFile(fieldName: fieldName, filePath: filePath, fields: fields);
  }
}
