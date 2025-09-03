abstract class FileRepository {
  /// Uploads a file to the backend and returns the accessible URL string.
  Future<String> uploadFile({
    required String fieldName,
    required String filePath,
    Map<String, String>? fields,
  });
}
