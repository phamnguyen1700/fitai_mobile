import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/models/user_model.dart';
import '../../data/models/auth_response.dart';

// 👇 THÊM: import model subscription
import '../../data/models/subscription_current_response.dart';

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
  String _mapOtpError(String? message) {
    if (message == null || message.isEmpty) {
      return 'Mã OTP không hợp lệ.';
    }

    final lower = message.toLowerCase();
    if (lower.contains('expire')) {
      return 'Mã OTP đã hết hạn. Vui lòng yêu cầu mã mới.';
    }
    if (lower.contains('invalid')) {
      return 'Mã OTP không đúng, hãy kiểm tra lại.';
    }

    return message;
  }

  // ------------------ CHANGE PASSWORD ------------------
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final current = state.value ?? const AuthState();

    // bật loading, clear error cũ
    state = AsyncValue.data(current.copyWith(isLoading: true, error: null));

    try {
      final authRepository = ref.read(authRepositoryProvider);

      final response = await authRepository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      if (response.success) {
        // ✅ Đổi mật khẩu OK: giữ nguyên user + isAuthenticated
        state = AsyncValue.data(
          current.copyWith(isLoading: false, error: null),
        );
        return true;
      } else {
        // ❌ BE trả success = false -> show message từ server
        final rawMsg = response.message;
        final friendlyMsg = rawMsg == 'Current password is incorrect'
            ? 'Mật khẩu hiện tại không chính xác.'
            : rawMsg;

        state = AsyncValue.data(
          current.copyWith(isLoading: false, error: friendlyMsg),
        );
        return false;
      }
    } catch (e) {
      // lỗi khác (mạng, parse, v.v.)
      final msg = e.toString().replaceFirst('Exception: ', '');
      state = AsyncValue.data(current.copyWith(isLoading: false, error: msg));
      return false;
    }
  }

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
        // LOGIN OK -> set state đăng nhập
        state = AsyncValue.data(
          AuthState(
            isAuthenticated: true,
            user: response.userData,
            isLoading: false,
            error: null,
          ),
        );

        // 🔔 Sau khi login thành công -> load gói subscription hiện tại
        await ref.read(subscriptionNotifierProvider.notifier).refresh();
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
        // Thường đợi verify OTP mới đăng nhập
        state = AsyncValue.data(
          AuthState(
            isAuthenticated: false,
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
            error: response.message,
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
    } catch (_) {
      // ignore
    } finally {
      // Clear subscription khi logout
      ref.read(subscriptionNotifierProvider.notifier).clear();

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
        final mappedMessage = _mapOtpError(response.message);
        state = AsyncValue.data(
          AuthState(
            isAuthenticated: false,
            user: null,
            isLoading: false,
            error: mappedMessage,
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

  Future<AuthResponse> resendOtp({required String email}) async {
    final current = state.value ?? const AuthState();
    state = AsyncValue.data(current.copyWith(isLoading: true));

    try {
      final authRepository = ref.read(authRepositoryProvider);
      final response = await authRepository.resendOtp(email: email);

      state = AsyncValue.data(current.copyWith(isLoading: false));
      return response;
    } catch (e) {
      state = AsyncValue.data(
        current.copyWith(isLoading: false, error: e.toString()),
      );
      return AuthResponse(success: false, message: e.toString());
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

// ================== SUBSCRIPTION NOTIFIER ==================
@riverpod
class SubscriptionNotifier extends _$SubscriptionNotifier {
  @override
  Future<SubscriptionData?> build() async {
    // Chỉ load khi có chỗ nào watch subscriptionNotifierProvider
    // và user đã login.
    final authRepo = ref.read(authRepositoryProvider);
    try {
      final res = await authRepo.getCurrentUserSubscription();
      if (res.success) return res.data;
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Gọi lại API lấy subscription hiện tại (dùng sau khi login)
  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final authRepo = ref.read(authRepositoryProvider);
      final res = await authRepo.getCurrentUserSubscription();
      if (res.success) return res.data;
      return null;
    });
  }

  /// Clear khi logout
  void clear() {
    state = const AsyncData(null);
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

// ---------- Convenience cho Subscription ----------
@riverpod
SubscriptionData? currentSubscription(CurrentSubscriptionRef ref) {
  final subState = ref.watch(subscriptionNotifierProvider);
  return subState.when(
    data: (data) => data,
    loading: () => null,
    error: (_, __) => null,
  );
}

@riverpod
String? currentTierType(CurrentTierTypeRef ref) {
  final sub = ref.watch(currentSubscriptionProvider);
  return sub?.tierType;
}
