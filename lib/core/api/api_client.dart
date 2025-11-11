import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'api_constants.dart';

class ApiClient {
  late final Dio _dio;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static ApiClient? _instance;

  // Singleton pattern
  factory ApiClient() {
    _instance ??= ApiClient._internal();
    return _instance!;
  }

  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.fullBaseUrl,
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
          // Handle token refresh on 401 errors
          if (error.response?.statusCode == 401) {
            // final refreshed = await _refreshToken();
            // if (refreshed) {
            //   // Retry the request with new token
            //   final newRequest = await _dio.fetch(error.requestOptions);
            //   handler.resolve(newRequest);
            //   return;
            // } else {
            //   // Clear tokens and redirect to login
            //   await _clearTokens();
            // }
          }
          handler.next(error);
        },
      ),
    );

    // Logging interceptor (only in debug mode)
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

  // // Refresh token logic
  // Future<bool> _refreshToken() async {
  //   try {
  //     final refreshToken = await _secureStorage.read(
  //       key: ApiConstants.refreshTokenKey,
  //     );
  //     if (refreshToken == null) return false;

  //     final response = await _dio.post(
  //       ApiConstants.refreshToken,
  //       data: {'refresh_token': refreshToken},
  //       options: Options(
  //         headers: {
  //           ApiConstants.authorization: null,
  //         }, // Remove auth header for refresh
  //       ),
  //     );

  //     if (response.statusCode == 200) {
  //       final newAccessToken = response.data['access_token'];
  //       final newRefreshToken = response.data['refresh_token'];

  //       await _secureStorage.write(
  //         key: ApiConstants.accessTokenKey,
  //         value: newAccessToken,
  //       );
  //       await _secureStorage.write(
  //         key: ApiConstants.refreshTokenKey,
  //         value: newRefreshToken,
  //       );

  //       return true;
  //     }
  //   } catch (e) {
  //     print('Token refresh failed: $e');
  //   }
  //   return false;
  // }

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

  // HTTP Methods
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
