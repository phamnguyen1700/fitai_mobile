// lib/core/network/api_service.dart
import 'package:dio/dio.dart';
import 'app_exception.dart';
import 'server_error.dart';
import 'dio_client.dart';

class ApiService {
  final Dio _dio;
  ApiService(DioClient client) : _dio = client.dio;

  Never _throwApp(DioException e) {
    // Ưu tiên thông tin từ interceptor
    if (e.error is ServerError) {
      final se = e.error as ServerError;
      // Map nhanh theo status code
      if (se.statusCode == 401) throw AppException.unauthorized();
      throw AppException.server(se.message, status: se.statusCode);
    }

    // Không có response hoặc không phải JSON đã chuẩn hoá
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.unknown) {
      throw AppException.network(e);
    }

    // Fallback: có response nhưng không bóc được message chuẩn
    final status = e.response?.statusCode;
    final msg = e.message ?? 'Đã xảy ra lỗi. Vui lòng thử lại.';
    if (status == 401) throw AppException.unauthorized();
    throw AppException.server(msg, status: status);
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? query,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: query,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      _throwApp(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? query,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: query,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      _throwApp(e);
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? query,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: query,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      _throwApp(e);
    }
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? query,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.patch<T>(
        path,
        data: data,
        queryParameters: query,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      _throwApp(e);
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    Map<String, dynamic>? query,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        queryParameters: query,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      _throwApp(e);
    }
  }
}
