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
  static const String resendOtp = '/auth/resend-otp';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyEmail = '/auth/verify-email';
  static const String activityLevels = '/api/metadata/activity-levels';
  static const String subscriptionProducts = '/subscription/active-products';
  static const String bodygramUpload = '/bodygram/upload-body-images';
  static const String bodygramAnalyze = '/bodygram/analyze-body-images';
  static const String dietaryPreference = '/dietarypreference';
  static const String latestBodyData = '/bodydata/latest';

  // User endpoints
  static const String profile = '/user/profile';
  static const String updateProfile = '/user/profile';
  static const String changePassword = '/auth/change-password';
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
  static const String aiHealthPlanCreate = '/api/aihealthplan/create';

  //daily
  static const String dailyMeals = '/mealplan/daily-meals';
  static const String mealPlanGenerate = '/api/mealplan/generate';
  static const String workoutPlanGenerate = '/api/workoutplan/generate';
  static const previousCheckpointCompletionPercent =
      '/checkpoints/previous/completion-percent';
  static const String workoutPlanSaveAll =
      '/api/aihealthplan/workout-plan/save-all';
  static const String mealPlanSaveBatch =
      '/api/aihealthplan/meal-plan/save-batch';
  static const aiHealthPlanActivate = '/api/aihealthplan/activate';
  static const checkpointsLineChart = '/checkpoints/linechart';
  static const checkpointsPieChart = '/checkpoints/piechart';
  static const String workoutPlanSchedule = '/workoutplan/schedule';
  static const String mealUploadPhoto = '/mealplan/upload-photo';
  static const String mealMarkCompleted = '/mealplan/mark-completed';
  static const uploadWorkoutVideo = '/workoutplan/upload-video';
  static const markExerciseCompleted = '/workoutplan/mark-exercise-completed';

  //process
  static const String checkpointNote = '/checkpoints/note';
  static const String checkpointsAchievement = '/checkpoints/achievement';
  static const prepareNextCheckpoint = "/aihealthplan/prepare-next-checkpoint";
  static const nextTarget = "/checkpoints/next-target";
  static const generateMealPlanWithTarget = "/mealplan/generate-with-target";

  //checkout
  static const String paymentCreate = '/payment/create';
  static const String advisorList = '/advisor';
  static const String advisorAssign = '/advisor/assign-advisor';
  static String currentUserSubscription(String userId) =>
      '/subscription/user/$userId/current';
}
