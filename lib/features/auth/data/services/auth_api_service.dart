import 'package:dio/dio.dart';
import 'package:fitai_mobile/features/auth/data/models/change_password_request.dart';
import 'package:fitai_mobile/features/auth/data/models/subscription_current_response.dart';
import 'package:fitai_mobile/features/auth/data/models/user_model.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/auth_response.dart';

class AuthApiService {
  final ApiClient _apiClient = ApiClient.account();

  // Login user
  Future<AuthResponse> login(LoginRequest loginRequest) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiConstants.login,
        data: loginRequest.toJson(),
      );

      // ✅ Trường hợp 200 OK, có data
      if (response.statusCode == 200 && response.data != null) {
        return AuthResponse.fromJson(response.data!);
      }

      // ❗ Nếu server trả status khác 200 nhưng vẫn có body JSON
      // (ví dụ 401, 422 với { success: false, message: '...' })
      if (response.data != null) {
        return AuthResponse.fromJson(response.data!);
      }

      throw Exception('Login failed: Invalid response');
    } on DioException catch (e) {
      // 📦 Nếu server có trả về body JSON (sai tk/mk, validate fail, ...)
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        // -> convert thành AuthResponse (success = false, message = '...')
        return AuthResponse.fromJson(data);
      }

      // 🔌 Không có response (mất mạng, DNS fail, host unreachable, ...)
      // -> ĐỂ REPOSITORY XỬ LÝ, ĐỪNG WRAP NỮA
      rethrow;
    }
  }

  // Register user
  Future<AuthResponse> register(RegisterRequest registerRequest) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiConstants.register,
        data: registerRequest.toJson(),
      );

      if (response.statusCode == 200 && response.data != null) {
        // API hiện trả về: { success: true, message: ..., data: { otpCode: 123456 } }
        // Tránh parse 'data' như UserModel vì không cùng schema
        final body = response.data!;
        final success = body['success'] == true;
        final message = (body['message'] ?? '').toString();
        return AuthResponse(success: success, message: message);
      } else {
        throw Exception('Registration failed: Invalid response');
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
        // Try to parse error response
        try {
          final errorResponse = AuthResponse.fromJson(e.response!.data);
          throw Exception('Registration failed: ${errorResponse.message}');
        } catch (_) {
          // If parsing fails, use generic error
          throw Exception(
            'Registration failed: ${e.response?.data['message'] ?? e.message}',
          );
        }
      } else {
        throw Exception('Registration failed: ${e.message}');
      }
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  // Verify OTP
  Future<AuthResponse> verifyOtp({
    required String email,
    required String otpCode,
  }) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiConstants.verifyOtp,
        data: {'email': email, 'otpCode': otpCode},
      );

      if (response.statusCode == 200 && response.data != null) {
        return AuthResponse.fromJson(response.data!);
      } else {
        throw Exception('OTP verification failed: Invalid response');
      }
    } on DioException catch (e) {
      final data = e.response?.data;

      if (data is Map<String, dynamic>) {
        final message = (data['message'] ?? 'Mã OTP không hợp lệ.').toString();
        return AuthResponse(success: false, message: message);
      }

      final fallback = e.message ?? 'Không thể xác thực OTP, vui lòng thử lại.';
      return AuthResponse(success: false, message: fallback);
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'OTP verification failed: $e',
      );
    }
  }

  Future<AuthResponse> resendOtp({required String email}) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiConstants.resendOtp,
        data: {'email': email},
      );

      if (response.statusCode == 200 && response.data != null) {
        final body = response.data!;
        final success = body['success'] as bool? ?? false;
        final message = (body['message'] ?? 'Không thể gửi lại mã OTP.')
            .toString();
        return AuthResponse(success: success, message: message);
      }

      return const AuthResponse(
        success: false,
        message: 'Không thể gửi lại mã OTP. Vui lòng thử lại.',
      );
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        final message = (data['message'] ?? 'Không thể gửi lại mã OTP.')
            .toString();
        return AuthResponse(success: false, message: message);
      }
      return AuthResponse(
        success: false,
        message: e.message ?? 'Không thể gửi lại mã OTP.',
      );
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Không thể gửi lại mã OTP: $e',
      );
    }
  }

  // // Refresh token
  // Future<AuthResponse> refreshToken(String refreshToken) async {
  //    try {
  //     final response = await _apiClient.post<Map<String, dynamic>>(
  //       ApiConstants.refreshToken,
  //       data: {'refresh_token': refreshToken},
  //     );

  //     if (response.statusCode == 200 && response.data != null) {
  //       return AuthResponse.fromJson(response.data!);
  //     } else {
  //       throw Exception('Token refresh failed: Invalid response');
  //     }
  //   } on DioException catch (e) {
  //     throw Exception('Token refresh failed: ${e.message}');
  //   } catch (e) {
  //     throw Exception('Token refresh failed: $e');
  //   }
  // }

  // Logout user
  Future<void> logout() async {
    try {
      await _apiClient.post(ApiConstants.logout);
    } on DioException catch (e) {
      throw Exception('Logout failed: ${e.message}');
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  // Forgot password
  Future<AuthResponse> forgotPassword(String email) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiConstants.forgotPassword,
        data: {'email': email},
      );

      if (response.statusCode == 200 && response.data != null) {
        return AuthResponse.fromJson(response.data!);
      } else {
        throw Exception('Forgot password failed: Invalid response');
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
        try {
          final errorResponse = AuthResponse.fromJson(e.response!.data);
          throw Exception('Forgot password failed: ${errorResponse.message}');
        } catch (_) {
          throw Exception(
            'Forgot password failed: ${e.response?.data['message'] ?? e.message}',
          );
        }
      } else {
        throw Exception('Forgot password failed: ${e.message}');
      }
    } catch (e) {
      throw Exception('Forgot password failed: $e');
    }
  }

  // Reset password
  Future<AuthResponse> resetPassword({
    required String email,
    required String password,
    required String passwordConfirmation,
    required String token,
  }) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiConstants.resetPassword,
        data: {
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'token': token,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        return AuthResponse.fromJson(response.data!);
      } else {
        throw Exception('Password reset failed: Invalid response');
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
        try {
          final errorResponse = AuthResponse.fromJson(e.response!.data);
          throw Exception('Password reset failed: ${errorResponse.message}');
        } catch (_) {
          throw Exception(
            'Password reset failed: ${e.response?.data['message'] ?? e.message}',
          );
        }
      } else {
        throw Exception('Password reset failed: ${e.message}');
      }
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  // Verify email
  Future<AuthResponse> verifyEmail({
    required String userId,
    required String hash,
  }) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiConstants.verifyEmail,
        data: {'user_id': userId, 'hash': hash},
      );

      if (response.statusCode == 200 && response.data != null) {
        return AuthResponse.fromJson(response.data!);
      } else {
        throw Exception('Email verification failed: Invalid response');
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
        try {
          final errorResponse = AuthResponse.fromJson(e.response!.data);
          throw Exception(
            'Email verification failed: ${errorResponse.message}',
          );
        } catch (_) {
          throw Exception(
            'Email verification failed: ${e.response?.data['message'] ?? e.message}',
          );
        }
      } else {
        throw Exception('Email verification failed: ${e.message}');
      }
    } catch (e) {
      throw Exception('Email verification failed: $e');
    }
  }

  Future<AuthResponse> getCurrentUserProfile({UserModel? baseUser}) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        ApiConstants.currentUser,
      );

      if (response.statusCode == 200 && response.data != null) {
        final body = response.data!;

        final data = body['data'];
        UserModel? user;

        if (data is Map<String, dynamic>) {
          // merge JSON từ user cache + profile mới
          final merged = <String, dynamic>{
            if (baseUser != null) ...baseUser.toJson(),
            ...data,
          };

          user = UserModel.fromJson(merged);
        } else if (baseUser != null) {
          // nếu API không trả data thì dùng tạm cache
          user = baseUser;
        }

        return AuthResponse(
          success: body['success'] == true,
          message: (body['message'] ?? '').toString(),
          accessToken: baseUser?.token,
          user: user,
        );
      } else {
        throw Exception('Get profile failed: Invalid response');
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
        try {
          final body = e.response!.data as Map<String, dynamic>;
          final msg = (body['message'] ?? '').toString();
          throw Exception('Get profile failed: $msg');
        } catch (_) {
          throw Exception(
            'Get profile failed: ${e.response?.data['message'] ?? e.message}',
          );
        }
      } else {
        throw Exception('Get profile failed: ${e.message}');
      }
    } catch (e) {
      throw Exception('Get profile failed: $e');
    }
  }

  Future<AuthResponse> changePassword(ChangePasswordRequest request) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiConstants.changePassword,
        data: request.toJson(),
      );

      final body = response.data;

      if (body != null) {
        final success = body['success'] == true;
        final message = (body['message'] ?? '').toString();

        return AuthResponse(success: success, message: message);
      }

      throw Exception('Change password failed: Invalid response');
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        final success = data['success'] == true;
        final message = (data['message'] ?? '').toString();

        return AuthResponse(success: success, message: message);
      }
      rethrow;
    }
  }

  /// Lấy gói subscription hiện tại của user
  Future<SubscriptionCurrentResponse> getCurrentUserSubscription(
    String userId,
  ) async {
    try {
      // Gợi ý ApiConstants – bạn thêm vào file ApiConstants:
      // static String currentUserSubscription(String userId)
      //   => '/api/subscription/user/$userId/current';

      final response = await _apiClient.get<Map<String, dynamic>>(
        ApiConstants.currentUserSubscription(userId),
      );

      final body = response.data;
      if (body != null) {
        // Backend trả dạng: { success: true/false, message?, data: {...}|null }
        return SubscriptionCurrentResponse.fromJson(body);
      }

      throw Exception('Get current subscription failed: Invalid response');
    } on DioException catch (e) {
      final data = e.response?.data;

      // Nếu server vẫn trả JSON (success=false, message='...', data=null)
      if (data is Map<String, dynamic>) {
        return SubscriptionCurrentResponse.fromJson(data);
      }

      // Lỗi mạng / không có response -> cho bubble lên cho Repository xử lý
      rethrow;
    } catch (e) {
      // Trường hợp lỗi bất ngờ khác – gói lại cho dễ debug
      throw Exception('Get current subscription failed: $e');
    }
  }
}
