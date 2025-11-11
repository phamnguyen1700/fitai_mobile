import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Class quản lý các biến môi trường
class EnvConfig {
  static String get baseUrl => dotenv.env['API_BASE_URL'] ?? '';
}
