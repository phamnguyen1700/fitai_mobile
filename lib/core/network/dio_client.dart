import 'package:dio/dio.dart';
import 'server_error.dart';

typedef TokenProvider = Future<String?> Function();
typedef ExtraHeadersProvider = Future<Map<String, String>?> Function();

class DioClient {
  final Dio dio;

  DioClient({
    required String baseUrl,
    TokenProvider? accessToken,
    ExtraHeadersProvider? extraHeaders,
    Duration connectTimeout = const Duration(seconds: 10),
    Duration receiveTimeout = const Duration(seconds: 20),
  }) : dio = Dio(
         BaseOptions(
           baseUrl: baseUrl,
           connectTimeout: connectTimeout,
           receiveTimeout: receiveTimeout,
           headers: const {'Content-Type': 'application/json'},
         ),
       ) {
    dio.interceptors.add(
      _AppInterceptor(accessToken: accessToken, extraHeaders: extraHeaders),
    );
  }
}

class _AppInterceptor extends Interceptor {
  final TokenProvider? accessToken;
  final ExtraHeadersProvider? extraHeaders;

  _AppInterceptor({this.accessToken, this.extraHeaders});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await accessToken?.call();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    final extra = await extraHeaders?.call();
    if (extra != null && extra.isNotEmpty) {
      options.headers.addAll(extra);
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String message = 'Đã xảy ra lỗi. Vui lòng thử lại.';
    final int? status = err.response?.statusCode;

    final data = err.response?.data;
    if (data is Map) {
      message =
          data['message']?.toString() ??
          (data['error'] is Map
              ? data['error']['message']?.toString()
              : null) ??
          message;
    }

    handler.next(
      err.copyWith(
        error: ServerError(message: message, statusCode: status),
      ),
    );
  }
}
