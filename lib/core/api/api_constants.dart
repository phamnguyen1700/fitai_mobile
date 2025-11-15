import 'package:fitai_mobile/core/api/api_config.dart';

class ApiConstants {
  // Timeout configurations
  static Duration get connectTimeout =>
      Duration(seconds: ApiConfig.CONNECT_TIMEOUT);
  static Duration get receiveTimeout =>
      Duration(seconds: ApiConfig.RECEIVE_TIMEOUT);
  static Duration get sendTimeout => Duration(seconds: ApiConfig.SEND_TIMEOUT);

  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String verifyOtp = '/auth/verify-otp';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyEmail = '/auth/verify-email';
  static const String activityLevels = '/api/metadata/activity-levels';
  static const String subscriptionProducts = '/subscription/active-products';
  static const String bodygramUpload = '/bodygram/upload-body-images';
  static const String dietaryPreference = '/dietarypreference';

  // User endpoints
  static const String profile = '/user/profile';
  static const String updateProfile = '/user/profile';
  static const String changePassword = '/user/change-password'; // Headers
  static const String fullProfile = '/user/full-profile';
  static const String currentUser = '/user/me';

  static const String contentType = 'application/json';
  static const String authorization = 'Authorization';
  static const String bearerPrefix = 'Bearer ';

  // Storage keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';

  //workout
  static const String workoutDemo = '/workoutdemo';
  static const mealDemo = '/mealdemo';
  static const mealDemoDetail = '/mealdemodetail';

  //chat
  static const String chatThreads = '/chatthreads';
}
