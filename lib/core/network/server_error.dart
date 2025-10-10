/// Lỗi “đọc được” đã được interceptor chuẩn hoá và gắn vào DioException.error
class ServerError {
  final String message;
  final int? statusCode;

  const ServerError({required this.message, this.statusCode});

  @override
  String toString() => 'ServerError($statusCode, $message)';
}
