import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/models/user_model.dart';

part 'auth_providers.g.dart';

// Auth repository provider
@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository();
}

// Auth state model
class AuthState {
  final bool isAuthenticated;
  final UserModel? user;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.isAuthenticated = false,
    this.user,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    UserModel? user,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  String toString() {
    return 'AuthState(isAuthenticated: $isAuthenticated, user: $user, isLoading: $isLoading, error: $error)';
  }
}

// Auth notifier
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<AuthState> build() async {
    final authRepository = ref.read(authRepositoryProvider);

    final isAuthenticated = await authRepository.isAuthenticated();
    final user = isAuthenticated ? await authRepository.getCurrentUser() : null;

    return AuthState(isAuthenticated: isAuthenticated, user: user);
  }

  // Login method
  Future<void> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    // clear error + set loading
    state = AsyncValue.data(
      state.value?.copyWith(isLoading: true, error: null) ??
          const AuthState(isLoading: true),
    );

    try {
      final authRepository = ref.read(authRepositoryProvider);
      final response = await authRepository.login(
        email: email,
        password: password,
        rememberMe: rememberMe,
      );

      if (response.success) {
        state = AsyncValue.data(
          AuthState(
            isAuthenticated: true,
            user: response.userData,
            isLoading: false,
            error: null,
          ),
        );
      } else {
        state = AsyncValue.data(
          state.value!.copyWith(
            isLoading: false,
            error: response.message ?? 'Email hoặc mật khẩu không chính xác.',
          ),
        );
      }
    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      state = AsyncValue.data(
        state.value!.copyWith(isLoading: false, error: msg),
      );
    }
  }

  // Register method
  Future<void> register({
    required String email,
    required String password,
    required String passwordConfirmation,
    String? firstName,
    String? lastName,
  }) async {
    state = AsyncValue.data(
      state.value!.copyWith(isLoading: true, error: null),
    );

    try {
      final authRepository = ref.read(authRepositoryProvider);
      final response = await authRepository.register(
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        firstName: firstName,
        lastName: lastName,
      );

      if (response.success) {
        state = AsyncValue.data(
          AuthState(
            isAuthenticated: true,
            user: response.userData,
            isLoading: false,
          ),
        );
      } else {
        state = AsyncValue.data(
          state.value!.copyWith(isLoading: false, error: response.message),
        );
      }
    } catch (e) {
      state = AsyncValue.data(
        state.value!.copyWith(isLoading: false, error: e.toString()),
      );
    }
  }

  // Logout method
  Future<void> logout() async {
    state = AsyncValue.data(state.value!.copyWith(isLoading: true));

    try {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.logout();

      state = const AsyncValue.data(
        AuthState(isAuthenticated: false, user: null, isLoading: false),
      );
    } catch (e) {
      // Even if logout fails, clear local state
      state = AsyncValue.data(
        state.value!.copyWith(
          isAuthenticated: false,
          user: null,
          isLoading: false,
          error: e.toString(),
        ),
      );
    }
  }

  // Verify OTP
  Future<void> verifyOtp({
    required String email,
    required String otpCode,
  }) async {
    state = AsyncValue.data(
      state.value?.copyWith(isLoading: true, error: null) ??
          const AuthState(isLoading: true),
    );

    try {
      final authRepository = ref.read(authRepositoryProvider);
      final response = await authRepository.verifyOtp(
        email: email,
        otpCode: otpCode,
      );

      if (response.success) {
        state = AsyncValue.data(
          state.value?.copyWith(
                isAuthenticated: true,
                user: response.userData,
                isLoading: false,
                error: null,
              ) ??
              AuthState(
                isAuthenticated: true,
                user: response.userData,
                isLoading: false,
              ),
        );
      } else {
        state = AsyncValue.data(
          state.value!.copyWith(isLoading: false, error: response.message),
        );
      }
    } catch (e) {
      state = AsyncValue.data(
        state.value?.copyWith(isLoading: false, error: e.toString()) ??
            AuthState(isLoading: false, error: e.toString()),
      );
    }
  }

  // Làm mới profile từ API (dùng sau khi edit)
  Future<void> refreshProfile() async {
    final authRepository = ref.read(authRepositoryProvider);

    final user = await authRepository.getCurrentUser();
    state = AsyncValue.data(
      state.value?.copyWith(user: user) ??
          AuthState(isAuthenticated: true, user: user),
    );
  }

  // Clear error
  void clearError() {
    if (state.value != null) {
      state = AsyncValue.data(state.value!.copyWith(error: null));
    }
  }

  //   // Refresh token
  //   Future<void> refreshToken() async {
  //     try {
  //       final authRepository = ref.read(authRepositoryProvider);
  //       // await authRepository.refreshToken();

  //       // Reload auth state
  //       ref.invalidateSelf();
  //     } catch (e) {
  //       state = AsyncValue.data(
  //         state.value!.copyWith(
  //           isAuthenticated: false,
  //           user: null,
  //           error: e.toString(),
  //         ),
  //       );
  //     }
  //   }
}

// Convenience providers
@riverpod
bool isAuthenticated(IsAuthenticatedRef ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.when(
    data: (state) => state.isAuthenticated,
    loading: () => false,
    error: (_, __) => false,
  );
}

@riverpod
UserModel? currentUser(CurrentUserRef ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.when(
    data: (state) => state.user,
    loading: () => null,
    error: (_, __) => null,
  );
}

@riverpod
bool isAuthLoading(IsAuthLoadingRef ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.when(
    data: (state) => state.isLoading,
    loading: () => true,
    error: (_, __) => false,
  );
}

@riverpod
String? authError(AuthErrorRef ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.when(
    data: (state) => state.error,
    loading: () => null,
    error: (error, _) => error.toString(),
  );
}
