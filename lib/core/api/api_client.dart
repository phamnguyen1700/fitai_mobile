import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'api_constants.dart';
import 'api_config.dart';

class ApiClient {
  late final Dio _dio;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // ==========================
  // Singleton cho từng service
  // ==========================
  static ApiClient? _accountInstance;
  static ApiClient? _fitnessInstance;
  static ApiClient? _chatInstance;

  /// 👤 Client cho AccountService (port 8081)
  factory ApiClient.account() {
    _accountInstance ??= ApiClient._internal(ApiConfig.accountFullBaseUrl);
    return _accountInstance!;
  }

  /// 🏋️ Client cho FitnessService (port 8082)
  factory ApiClient.fitness() {
    _fitnessInstance ??= ApiClient._internal(ApiConfig.fitnessFullBaseUrl);
    return _fitnessInstance!;
  }

  factory ApiClient.chat() {
    // baseUrl = http://54.179.34.55:8082
    _chatInstance ??= ApiClient._internal(ApiConfig.fitnessBaseUrl);
    return _chatInstance!;
  }

  /// Giữ lại factory cũ cho đỡ vỡ code,
  /// nhưng nên dần dần replace bằng `.account()` hoặc `.fitness()`.
  @Deprecated('Use ApiClient.account() or ApiClient.fitness() instead')
  factory ApiClient() {
    return ApiClient.account();
  }

  // baseUrl được truyền vào để tái sử dụng logic chung
  ApiClient._internal(String baseUrl) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        sendTimeout: ApiConstants.sendTimeout,
        headers: {
          'Content-Type': ApiConstants.contentType,
          'Accept': ApiConstants.contentType,
        },
      ),
    );

    _setupInterceptors();
  }

  void _setupInterceptors() {
    // Auth interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add authorization header if token exists
          final token = await _secureStorage.read(
            key: ApiConstants.accessTokenKey,
          );
          if (token != null) {
            options.headers[ApiConstants.authorization] =
                '${ApiConstants.bearerPrefix}$token';
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (error, handler) async {
          // Handle token refresh on 401 errors (tạm tắt)
          if (error.response?.statusCode == 401) {
            // TODO: refresh token nếu cần
            // await _clearTokens();
          }
          handler.next(error);
        },
      ),
    );

    // Logging interceptor
    if (ApiConfig.ENABLE_LOGGING) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }
  }

  // Clear stored tokens
  Future<void> _clearTokens() async {
    await _secureStorage.delete(key: ApiConstants.accessTokenKey);
    // await _secureStorage.delete(key: ApiConstants.refreshTokenKey);
    await _secureStorage.delete(key: ApiConstants.userDataKey);
  }

  // Store tokens after successful login
  Future<void> storeTokens({
    required String accessToken,
    // required String refreshToken,
    String? userData,
  }) async {
    await _secureStorage.write(
      key: ApiConstants.accessTokenKey,
      value: accessToken,
    );
    // await _secureStorage.write(
    //   key: ApiConstants.refreshTokenKey,
    //   value: refreshToken,
    // );
    if (userData != null) {
      await _secureStorage.write(
        key: ApiConstants.userDataKey,
        value: userData,
      );
    }
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await _secureStorage.read(key: ApiConstants.accessTokenKey);
    return token != null;
  }

  // Logout - clear all stored data
  Future<void> logout() async {
    try {
      await _dio.post(ApiConstants.logout);
    } catch (e) {
      print('Logout API call failed: $e');
    } finally {
      await _clearTokens();
    }
  }

  // ==========================
  // HTTP Methods
  // ==========================

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.patch<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}
