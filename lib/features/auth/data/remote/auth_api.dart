import 'package:fitai_mobile/core/network/api_service.dart';
import 'package:fitai_mobile/core/network/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthApi {
  final ApiService _api;
  AuthApi(this._api);

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final res = await _api.post<Map<String, dynamic>>(
      '/auth/login',
      data: {email, password},
    );
    return res.data!['data'] as Map<String, dynamic>;
  }
}

final authApiProvider = Provider<AuthApi>((ref) {
  final api = ref.watch(serviceProvider);
  return AuthApi(api);
});
