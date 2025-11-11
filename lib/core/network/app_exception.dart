class AppException implements Exception {
  final String message;
  final int? statusCode;
  final Object? cause;

  AppException(this.message, {this.statusCode, this.cause});

  @override
  String toString() => 'AppException($statusCode): $message';

  factory AppException.server(String message, {int? status}) =>
      AppException(message, statusCode: status);

  factory AppException.network([Object? e]) =>
      AppException('Lỗi mạng, vui lòng thử lại.', cause: e);

  factory AppException.parse([Object? e]) =>
      AppException('Lỗi phân tích dữ liệu.', cause: e);

  factory AppException.unauthorized([
    String msg = 'Phiên đăng nhập đã hết hạn',
  ]) => AppException(msg, statusCode: 401);
}
