import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/models/user_model.dart';

part 'auth_providers.g.dart';

// ================== REPOSITORY PROVIDER ==================
@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository();
}

// ================== AUTH STATE MODEL ==================
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

// ================== AUTH NOTIFIER ==================
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<AuthState> build() async {
    final authRepository = ref.read(authRepositoryProvider);

    final isAuthenticated = await authRepository.isAuthenticated();
    final user = isAuthenticated ? await authRepository.getCurrentUser() : null;

    return AuthState(isAuthenticated: isAuthenticated, user: user);
  }

  // ------------------ LOGIN ------------------
  Future<void> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    // clear error + set loading
    final current = state.value ?? const AuthState();
    state = AsyncValue.data(current.copyWith(isLoading: true, error: null));

    try {
      final authRepository = ref.read(authRepositoryProvider);
      final response = await authRepository.login(
        email: email,
        password: password,
        rememberMe: rememberMe,
      );

      if (response.success) {
        // LOGIN OK
        state = AsyncValue.data(
          AuthState(
            isAuthenticated: true,
            user: response.userData,
            isLoading: false,
            error: null,
          ),
        );
      } else {
        // LOGIN FAIL
        state = AsyncValue.data(
          AuthState(
            isAuthenticated: false,
            user: null,
            isLoading: false,
            error: response.message,
          ),
        );
      }
    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');

      // ❌ Lỗi exception cũng phải reset về chưa đăng nhập
      state = AsyncValue.data(
        AuthState(
          isAuthenticated: false,
          user: null,
          isLoading: false,
          error: msg,
        ),
      );
    }
  }

  // ------------------ REGISTER ------------------
  Future<void> register({
    required String email,
    required String password,
    required String passwordConfirmation,
    String? firstName,
    String? lastName,
  }) async {
    final current = state.value ?? const AuthState();
    state = AsyncValue.data(current.copyWith(isLoading: true, error: null));

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
        // Tuỳ BE: nếu register xong auto login thì để true,
        // còn nếu đợi verify OTP mới cho login thì để false.
        state = AsyncValue.data(
          AuthState(
            isAuthenticated: false, // 👈 thường đợi verify OTP, nên để false
            user: response.userData,
            isLoading: false,
            error: null,
          ),
        );
      } else {
        state = AsyncValue.data(
          AuthState(
            isAuthenticated: false,
            user: null,
            isLoading: false,
            error: response.message ?? 'Đăng ký thất bại. Vui lòng thử lại.',
          ),
        );
      }
    } catch (e) {
      state = AsyncValue.data(
        AuthState(
          isAuthenticated: false,
          user: null,
          isLoading: false,
          error: e.toString(),
        ),
      );
    }
  }

  // ------------------ LOGOUT ------------------
  Future<void> logout() async {
    final current = state.value ?? const AuthState();
    state = AsyncValue.data(current.copyWith(isLoading: true));

    try {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.logout();

      state = const AsyncValue.data(
        AuthState(isAuthenticated: false, user: null, isLoading: false),
      );
    } catch (e) {
      // Dù logout fail (do server) vẫn clear local state
      state = const AsyncValue.data(
        AuthState(isAuthenticated: false, user: null, isLoading: false),
      );
    }
  }

  // ------------------ VERIFY OTP ------------------
  /// Trả về true nếu verify thành công, false nếu thất bại
  Future<bool> verifyOtp({
    required String email,
    required String otpCode,
  }) async {
    final current = state.value ?? const AuthState();
    state = AsyncValue.data(current.copyWith(isLoading: true, error: null));

    try {
      final authRepository = ref.read(authRepositoryProvider);
      final response = await authRepository.verifyOtp(
        email: email,
        otpCode: otpCode,
      );

      if (response.success) {
        // ✅ OTP đúng: chỉ clear loading + error, KHÔNG gán isAuthenticated ở đây
        state = AsyncValue.data(
          current.copyWith(isLoading: false, error: null),
        );
        return true;
      } else {
        // ❌ OTP sai
        state = AsyncValue.data(
          AuthState(
            isAuthenticated: false,
            user: null,
            isLoading: false,
            error: response.message ?? 'Mã OTP không hợp lệ.',
          ),
        );
        return false;
      }
    } catch (e) {
      state = AsyncValue.data(
        AuthState(
          isAuthenticated: false,
          user: null,
          isLoading: false,
          error: e.toString(),
        ),
      );
      return false;
    }
  }

  // ------------------ REFRESH PROFILE ------------------
  Future<void> refreshProfile() async {
    final authRepository = ref.read(authRepositoryProvider);
    final user = await authRepository.getCurrentUser();

    final current = state.value ?? const AuthState();
    state = AsyncValue.data(
      current.copyWith(user: user, isAuthenticated: true),
    );
  }

  // ------------------ CLEAR ERROR ------------------
  void clearError() {
    final current = state.value;
    if (current != null) {
      state = AsyncValue.data(current.copyWith(error: null));
    }
  }
}

// ================== CONVENIENCE PROVIDERS ==================
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
