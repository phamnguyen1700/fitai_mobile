// lib/core/network/providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../config/env_config.dart';
import 'dio_client.dart';
import 'api_service.dart';

// Lưu token tạm thời (có thể thay bằng secure storage)
final authTokenProvider = StateProvider<String?>((_) => null);
const kApiBaseUrl = 'http://54.179.34.55:8081/swagger/index.html/api';

// DioClient dùng baseUrl từ .env và đọc token từ provider
final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient(
    baseUrl: kApiBaseUrl,
    accessToken: () async => ref.read(authTokenProvider),
    // extraHeaders: () async => {'X-App-Platform': 'flutter'},
  );
});

// ApiService dùng chung cho toàn app
final serviceProvider = Provider<ApiService>((ref) {
  final client = ref.watch(dioClientProvider);
  return ApiService(client);
});
