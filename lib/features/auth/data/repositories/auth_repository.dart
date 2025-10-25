import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/auth_response.dart';
import '../models/user_model.dart';
import '../services/auth_api_service.dart';

class AuthRepository {
  final AuthApiService _authApiService = AuthApiService();
  final ApiClient _apiClient = ApiClient();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  // Login with email and password
  Future<AuthResponse> login({
    required String email,
    required String password,
    bool rememberMe = false,
    String? deviceName,
  }) async {
    try {
      final loginRequest = LoginRequest(
        email: email,
        password: password,
        rememberMe: rememberMe,
        deviceName: deviceName ?? 'Mobile App',
      );
      
      final response = await _authApiService.login(loginRequest);
      
      if (response.success && response.token != null) {
        // Store tokens securely using the new response format
        await _apiClient.storeTokens(
          accessToken: response.token!,
          refreshToken: '', // Your API doesn't seem to provide refresh token
          userData: response.userData != null ? jsonEncode(response.userData!.toJson()) : null,
        );
      }
      
      return response;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }
  
  // Register new user
  Future<AuthResponse> register({
    required String email,
    required String password,
    required String passwordConfirmation,
    String? firstName,
    String? lastName,
    String? deviceName,
  }) async {
    try {
      final registerRequest = RegisterRequest(
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        firstName: firstName,
        lastName: lastName,
        deviceName: deviceName ?? 'Mobile App',
      );
      
      final response = await _authApiService.register(registerRequest);
      
      if (response.success && response.token != null) {
        // Store tokens securely using the new response format
        await _apiClient.storeTokens(
          accessToken: response.token!,
          refreshToken: '', // Your API doesn't seem to provide refresh token
          userData: response.userData != null ? jsonEncode(response.userData!.toJson()) : null,
        );
      }
      
      return response;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }
  
  // Logout user
  Future<void> logout() async {
    try {
      await _apiClient.logout();
    } catch (e) {
      // Even if API call fails, clear local tokens
      await _clearLocalTokens();
      rethrow;
    }
  }
  
  // Check if user is currently authenticated
  Future<bool> isAuthenticated() async {
    return await _apiClient.isAuthenticated();
  }
  
  // Get current user data from storage
  Future<UserModel?> getCurrentUser() async {
    try {
      final userData = await _secureStorage.read(key: ApiConstants.userDataKey);
      if (userData != null) {
        final userJson = jsonDecode(userData) as Map<String, dynamic>;
        return UserModel.fromJson(userJson);
      }
    } catch (e) {
      print('Error getting current user: $e');
    }
    return null;
  }
  
  // Get stored access token
  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: ApiConstants.accessTokenKey);
  }
  
  // Get stored refresh token
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: ApiConstants.refreshTokenKey);
  }
  
  // Refresh authentication token
  Future<AuthResponse> refreshToken() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null) {
        throw Exception('No refresh token available');
      }
      
      final response = await _authApiService.refreshToken(refreshToken);
      
      if (response.success && response.accessToken != null) {
        // Update stored tokens
        await _apiClient.storeTokens(
          accessToken: response.accessToken!,
          refreshToken: response.refreshToken ?? refreshToken,
          userData: response.user != null ? jsonEncode(response.user!.toJson()) : null,
        );
      }
      
      return response;
    } catch (e) {
      throw Exception('Token refresh failed: $e');
    }
  }
  
  // Forgot password
  Future<AuthResponse> forgotPassword(String email) async {
    try {
      return await _authApiService.forgotPassword(email);
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
      return await _authApiService.resetPassword(
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        token: token,
      );
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
      return await _authApiService.verifyEmail(
        userId: userId,
        hash: hash,
      );
    } catch (e) {
      throw Exception('Email verification failed: $e');
    }
  }
  
  // Clear local tokens (used when logout fails)
  Future<void> _clearLocalTokens() async {
    await _secureStorage.delete(key: ApiConstants.accessTokenKey);
    await _secureStorage.delete(key: ApiConstants.refreshTokenKey);
    await _secureStorage.delete(key: ApiConstants.userDataKey);
  }
  
  // Update user data in storage
  Future<void> updateUserData(UserModel user) async {
    await _secureStorage.write(
      key: ApiConstants.userDataKey,
      value: jsonEncode(user.toJson()),
    );
  }
  
  // Clear all user data
  Future<void> clearUserData() async {
    await _clearLocalTokens();
  }
}