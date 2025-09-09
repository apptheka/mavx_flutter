import 'dart:developer';

import 'package:dio/dio.dart' as dio; 
import 'package:get/get.dart';

import '../../core/constants/app_constants.dart';
import 'package:mavx_flutter/app/core/services/storage_service.dart';

class ApiProvider {
  final dio.Dio _dio;
  static bool _isNavigating = false;

  Future<String?> getToken() async {
    try {
      final storage = Get.find<StorageService>();
      final token = storage.prefs.getString(AppConstants.tokenKey);
      return token;
    } catch (e, st) {
      log('getToken() failed: $e', stackTrace: st);
      return null;
    }
  }

  ApiProvider() : _dio = dio.Dio() {
    _dio.options.baseUrl = AppConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.options.headers = {
      'Content-Type': 'application/json', 
      'accept': 'application/json',
      'train' : 'sdlkfj',
      'area' : 'ANDROID',
      'x-api-key' : 'mavxsecretkey_admin12335545',
    };

    _dio.interceptors.add(
      dio.InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Always refresh baseUrl from AppConstants to avoid stale value after hot reloads
          options.baseUrl = AppConstants.baseUrl;
          // Skip auth header for unauthenticated endpoints
          final isLogin = options.path == AppConstants.login;
          final isEncrypt = options.uri.toString().contains('/encrypt');
          if (!isLogin && !isEncrypt) {
            final token = await getToken();
            if (token != null) {
              // Backend expects Authorization header to be the raw token (no 'Bearer ' prefix)
              options.headers['Authorization'] = token;
            }
          }
          return handler.next(options);
        },
        onError: (dio.DioException e, handler) async {
          final statusCode = e.response?.statusCode;
          log("statusCode: $statusCode");
          // Check for 401 or 403
          if (statusCode == 401 || statusCode == 403) {
            if (!_isNavigating) {
              _isNavigating = true;
              // await navigateToLogin();
             
            }
            return;
          }

          return handler.next(e);
        },
      ),
    );

    // Add interceptors for logging, error handling, etc.
    _dio.interceptors.add(
      dio.LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        logPrint: (object) => print(object.toString()),
      ),
    );
  }

  // Generic GET method
  Future<String> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      final resp = response.data;
      if (resp is Map) {
        // 1) Prefer nested encrypt payload: {data: {encryptedData: <base64>}}
        final dataField = resp['data'];
        if (dataField is Map && dataField['encryptedData'] is String) {
          final ed = dataField['encryptedData'] as String;
          if (ed.isNotEmpty) return ed;
        }
        // 2) Support both {data: ...} and {response: ...} as plain strings
        final enc = (resp['data'] ?? resp['response']);
        if (enc is String && enc.isNotEmpty) return enc;
        // 3) Fallback: return raw JSON string
        return resp.toString();
      } else if (resp is String && resp.isNotEmpty) {
        return resp;
      }
      throw Exception('Empty response payload');
    } on dio.DioException catch (e) {
      log("error: ${e}");
      final responseData = e.response?.data;
      if (responseData is Map) {
        final dataField = responseData['data'];
        if (dataField is Map && dataField['encryptedData'] is String) {
          final ed = dataField['encryptedData'] as String;
          if (ed.isNotEmpty) return ed;
        }
        final enc = (responseData['data'] ?? responseData['response']);
        if (enc is String && enc.isNotEmpty) {
          print("status: ${responseData.toString()}");
          return enc;
        }
        return responseData.toString();
      } else if (responseData is String && responseData.isNotEmpty) {
        print("status: ${responseData.toString()}");
        return responseData;
      }
      throw _handleError(e);
    }
  }

  // Generic PATCH method
  Future<String> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      // Add authorization header
      final token = await getToken();
      if (token != null) {
        // Use raw token to match backend expectations
        _dio.options.headers['Authorization'] = token;
      }

      print('PATCH request to: ${_dio.options.baseUrl}$path');
      print('Request body: $data');

      // Make sure content type is set correctly
      _dio.options.headers['Content-Type'] = 'application/json';
      _dio.options.headers['accept'] = 'application/json';

      // Send the request
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      return response.data['data'];
    } on dio.DioException catch (e) {
      final responseData = e.response?.data;

      if (responseData is Map &&
          responseData['data'] != null &&
          responseData['data'].toString().isNotEmpty) {
        print("status: ${responseData['data'].toString()}");
        return responseData['data'].toString();
      } else {
        throw _handleError(e);
      }
    }
  }

  // Generic POST method
  Future<String> post(
    String path, {
    dynamic request,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      // If caller passes a String (encrypted), wrap into expected envelope key 'request'
      final body = (request is String) ? {"request": request} : request;
      final response = await _dio.post(
        path,
        data: body,
        queryParameters: queryParameters,
      );
      final resp = response.data;
      if (resp is Map) {
        // 1) Prefer nested encrypt payload: {data: {encryptedData: <base64>}}
        final dataField = resp['data'];
        if (dataField is Map && dataField['encryptedData'] is String) {
          final ed = dataField['encryptedData'] as String;
          log("encryptedData $ed");
          if (ed.isNotEmpty) return ed;
        }
        // 2) Support both {data: ...} and {response: ...} as plain strings
        final enc = (resp['data'] ?? resp['response']);
        log("enc $enc");
        if (enc is String && enc.isNotEmpty) return enc;
        // 3) Fallback: return raw JSON string
        return resp.toString();
      } else if (resp is String && resp.isNotEmpty) {
        return resp;
      }
      throw Exception('Empty response payload');
    } on dio.DioException catch (e) {
      final responseData = e.response?.data;
      if (responseData is Map) {
        // Mirror success path for nested encrypt payload
        final dataField = responseData['data'];
        if (dataField is Map && dataField['encryptedData'] is String) {
          final ed = dataField['encryptedData'] as String;
          if (ed.isNotEmpty) return ed;
        }
        final enc = (responseData['data'] ?? responseData['response']);
        if (enc is String && enc.isNotEmpty) {
          print("status: ${responseData.toString()}");
          return enc;
        }
        // Return JSON string if present
        return responseData.toString();
      } else if (responseData is String && responseData.isNotEmpty) {
        print("status: ${responseData.toString()}");
        return responseData;
      }
      throw _handleError(e);
    }
  }

  // Multipart/form-data POST helper
  Future<String> postMultipart(
    String path, {
    Map<String, String>? fields,
    Map<String, String /* filePath */ >? files,
  }) async {
    try {
      final formData = dio.FormData();
      // Append text fields
      fields?.forEach((k, v) => formData.fields.add(MapEntry(k, v)));
      // Append files: map key -> file field name, value -> local file path
      if (files != null) {
        for (final entry in files.entries) {
          final filePath = entry.value;
          final fileName = filePath.split('/').last;
          formData.files.add(
            MapEntry(
              entry.key,
              await dio.MultipartFile.fromFile(filePath, filename: fileName),
            ),
          );
        }
      }

      // Ensure correct headers for multipart: do NOT use application/json
      final headers = Map<String, dynamic>.from(_dio.options.headers);
      headers.remove('Content-Type');
      headers['accept'] = 'application/json';

      final response = await _dio.post(
        path,
        data: formData,
        options: dio.Options(
          contentType: 'multipart/form-data',
          headers: headers,
        ),
      );
      final resp = response.data;
      if (resp is Map) {
        final dataField = resp['data'];
        if (dataField is Map && dataField['encryptedData'] is String) {
          final ed = dataField['encryptedData'] as String;
          if (ed.isNotEmpty) return ed;
        }
        final enc = (resp['data'] ?? resp['response']);
        if (enc is String && enc.isNotEmpty) return enc;
        return resp.toString();
      } else if (resp is String && resp.isNotEmpty) {
        return resp;
      }
      throw Exception('Empty response payload');
    } on dio.DioException catch (e) {
      final responseData = e.response?.data;
      if (responseData is Map) {
        final dataField = responseData['data'];
        if (dataField is Map && dataField['encryptedData'] is String) {
          final ed = dataField['encryptedData'] as String;
          if (ed.isNotEmpty) return ed;
        }
        final enc = (responseData['data'] ?? responseData['response']);
        if (enc is String && enc.isNotEmpty) return enc;
        return responseData.toString();
      } else if (responseData is String && responseData.isNotEmpty) {
        return responseData;
      }
      throw _handleError(e);
    }
  }

  // Generic PUT method
  Future<dio.Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.put(path, data: data, queryParameters: queryParameters);
    } on dio.DioException catch (e) {
      // Mirror GET/POST behavior: if server returned a body, pass it through
      final resp = e.response;
      if (resp != null && resp.data != null) {
        return resp;
      }
      throw _handleError(e);
    }
  }

  // Generic DELETE method
  Future<dio.Response> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.delete(path, queryParameters: queryParameters);
    } on dio.DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Error handling
  Exception _handleError(dio.DioException error) {
    String errorMessage = 'An error occurred';

    switch (error.type) {
      case dio.DioExceptionType.connectionTimeout:
      case dio.DioExceptionType.sendTimeout:
      case dio.DioExceptionType.receiveTimeout:
        errorMessage = 'Connection timeout';
        break;
      case dio.DioExceptionType.badResponse:
        errorMessage = 'Bad response: ${error.response?.statusCode}';

        break;
      case dio.DioExceptionType.cancel:
        errorMessage = 'Request cancelled';
        break;
      case dio.DioExceptionType.connectionError:
        errorMessage = 'Connection error';
        break;
      case dio.DioExceptionType.unknown:
      default:
        errorMessage = 'Unknown error: ${error.message}';
    }

    return Exception(errorMessage);
  }
}
