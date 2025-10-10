import 'package:fitai_mobile/core/network/app_exception.dart';
import 'package:fitai_mobile/features/auth/data/models/user_model.dart';
import 'package:fitai_mobile/features/auth/data/remote/auth_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class IAuthRepository {
  Future<UserModel> login(String email, String password);
}

class AuthRepository implements IAuthRepository {
  final AuthApi _api;
  AuthRepository(this._api);

  @override
  Future<UserModel> login(String email, String password) async {
    final json = await _api.login(email: email, password: password);
    if (json['success'] != true) {
      throw AppException.server(
        (json['message'] ?? 'Đăng nhập thất bại').toString(),
      );
    }
    final data = json['data'] as Map<String, dynamic>?;
    if (data == null) throw AppException.parse();

    return UserModel.fromMap(data);
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(authApiProvider));
});
