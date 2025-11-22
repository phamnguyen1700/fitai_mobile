// lib/features/daily/data/models/upload_image.dart
import 'package:json_annotation/json_annotation.dart';

// 🔹 thêm import này (hoặc import relative nếu bạn thích)
import 'meal_plan_models.dart';

part 'upload_image.g.dart';

@JsonSerializable()
class UploadMealPhotoResponse {
  final bool success;
  final String message;
  final UploadMealPhotoData? data;

  UploadMealPhotoResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory UploadMealPhotoResponse.fromJson(Map<String, dynamic> json) =>
      _$UploadMealPhotoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UploadMealPhotoResponseToJson(this);
}

@JsonSerializable()
class UploadMealPhotoData {
  final String mealLogId;
  final String photoUrl;
  final bool completed;
  final String advisorId;

  UploadMealPhotoData({
    required this.mealLogId,
    required this.photoUrl,
    required this.completed,
    required this.advisorId,
  });

  factory UploadMealPhotoData.fromJson(Map<String, dynamic> json) =>
      _$UploadMealPhotoDataFromJson(json);

  Map<String, dynamic> toJson() => _$UploadMealPhotoDataToJson(this);
}

/// ========================
/// WORKOUT VIDEO UPLOAD
/// ========================

@JsonSerializable(explicitToJson: true)
class UploadWorkoutVideoResponse {
  final bool success;
  final String message;
  final UploadWorkoutVideoData? data;

  UploadWorkoutVideoResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory UploadWorkoutVideoResponse.fromJson(Map<String, dynamic> json) =>
      _$UploadWorkoutVideoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UploadWorkoutVideoResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UploadWorkoutVideoData {
  final String workoutLogId;
  final String? exerciseLogId;
  final String? exerciseName;
  final int dayNumber;
  final bool isCompleted;
  final String photoUrl;

  /// dùng lại AdvisorReview từ meal_plan_models.dart
  final AdvisorReview? advisorReview;

  final DateTime createdAt;

  UploadWorkoutVideoData({
    required this.workoutLogId,
    this.exerciseLogId,
    this.exerciseName,
    required this.dayNumber,
    required this.isCompleted,
    required this.photoUrl,
    this.advisorReview,
    required this.createdAt,
  });

  factory UploadWorkoutVideoData.fromJson(Map<String, dynamic> json) =>
      _$UploadWorkoutVideoDataFromJson(json);

  Map<String, dynamic> toJson() => _$UploadWorkoutVideoDataToJson(this);
}
