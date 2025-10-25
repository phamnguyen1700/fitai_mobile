import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/auth_response.dart';

class AuthApiService {
  final ApiClient _apiClient = ApiClient();
  
  // Login user
  Future<AuthResponse> login(LoginRequest loginRequest) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiConstants.login,
        data: loginRequest.toJson(),
      );
      
      if (response.statusCode == 200 && response.data != null) {
        return AuthResponse.fromJson(response.data!);
      } else {
        throw Exception('Login failed: Invalid response');
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
        // Try to parse error response
        try {
          final errorResponse = AuthResponse.fromJson(e.response!.data);
          throw Exception('Login failed: ${errorResponse.message}');
        } catch (_) {
          // If parsing fails, use generic error
          throw Exception('Login failed: ${e.response?.data['message'] ?? e.message}');
        }
      } else {
        throw Exception('Login failed: ${e.message}');
      }
    } catch (e) {
      throw Exception('Login failed: $e');
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
        return AuthResponse.fromJson(response.data!);
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
          throw Exception('Registration failed: ${e.response?.data['message'] ?? e.message}');
        }
      } else {
        throw Exception('Registration failed: ${e.message}');
      }
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }
  
  // Refresh token
  Future<AuthResponse> refreshToken(String refreshToken) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiConstants.refreshToken,
        data: {'refresh_token': refreshToken},
      );
      
      if (response.statusCode == 200 && response.data != null) {
        return AuthResponse.fromJson(response.data!);
      } else {
        throw Exception('Token refresh failed: Invalid response');
      }
    } on DioException catch (e) {
      throw Exception('Token refresh failed: ${e.message}');
    } catch (e) {
      throw Exception('Token refresh failed: $e');
    }
  }
  
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
          throw Exception('Forgot password failed: ${e.response?.data['message'] ?? e.message}');
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
          throw Exception('Password reset failed: ${e.response?.data['message'] ?? e.message}');
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
        data: {
          'user_id': userId,
          'hash': hash,
        },
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
          throw Exception('Email verification failed: ${errorResponse.message}');
        } catch (_) {
          throw Exception('Email verification failed: ${e.response?.data['message'] ?? e.message}');
        }
      } else {
        throw Exception('Email verification failed: ${e.message}');
      }
    } catch (e) {
      throw Exception('Email verification failed: $e');
    }
  }
}