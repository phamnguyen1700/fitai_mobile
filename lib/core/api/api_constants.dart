import '../config/api_config.dart';

class ApiConstants {
  // Base URLs (using ApiConfig)
  static String get baseUrl => ApiConfig.baseUrl;
  static String get fullBaseUrl => ApiConfig.fullBaseUrl;
  
  // Timeout configurations
  static Duration get connectTimeout => Duration(seconds: ApiConfig.CONNECT_TIMEOUT);
  static Duration get receiveTimeout => Duration(seconds: ApiConfig.RECEIVE_TIMEOUT);
  static Duration get sendTimeout => Duration(seconds: ApiConfig.SEND_TIMEOUT);
  
  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyEmail = '/auth/verify-email';
  
  // User endpoints
  static const String profile = '/user/profile';
  static const String updateProfile = '/user/profile';
  static const String changePassword = '/user/change-password';
  
  // Headers
  static const String contentType = 'application/json';
  static const String authorization = 'Authorization';
  static const String bearerPrefix = 'Bearer ';
  
  // Storage keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
}