import 'package:fitai_mobile/core/network/app_exception.dart';
import 'package:fitai_mobile/core/network/providers.dart';
import 'package:fitai_mobile/features/auth/data/models/user_model.dart';
import 'package:fitai_mobile/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final Ref _ref;
  final AuthRepository _repo;
  AuthNotifier(this._ref, this._repo) : super(const AsyncValue.data(null));

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repo.login(email, password);
      _ref.read(authTokenProvider.notifier).state =
          user.token; // interceptor dùng
      state = AsyncValue.data(user);
    } on AppException catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void logout() {
    _ref.read(authTokenProvider.notifier).state = null;
    state = const AsyncValue.data(null);
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
      return AuthNotifier(ref, ref.watch(authRepositoryProvider));
    });
