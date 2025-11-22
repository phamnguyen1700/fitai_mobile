// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadMealPhotoResponse _$UploadMealPhotoResponseFromJson(
  Map<String, dynamic> json,
) => UploadMealPhotoResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: json['data'] == null
      ? null
      : UploadMealPhotoData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UploadMealPhotoResponseToJson(
  UploadMealPhotoResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

UploadMealPhotoData _$UploadMealPhotoDataFromJson(Map<String, dynamic> json) =>
    UploadMealPhotoData(
      mealLogId: json['mealLogId'] as String,
      photoUrl: json['photoUrl'] as String,
      completed: json['completed'] as bool,
      advisorId: json['advisorId'] as String,
    );

Map<String, dynamic> _$UploadMealPhotoDataToJson(
  UploadMealPhotoData instance,
) => <String, dynamic>{
  'mealLogId': instance.mealLogId,
  'photoUrl': instance.photoUrl,
  'completed': instance.completed,
  'advisorId': instance.advisorId,
};

UploadWorkoutVideoResponse _$UploadWorkoutVideoResponseFromJson(
  Map<String, dynamic> json,
) => UploadWorkoutVideoResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: json['data'] == null
      ? null
      : UploadWorkoutVideoData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UploadWorkoutVideoResponseToJson(
  UploadWorkoutVideoResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data?.toJson(),
};

UploadWorkoutVideoData _$UploadWorkoutVideoDataFromJson(
  Map<String, dynamic> json,
) => UploadWorkoutVideoData(
  workoutLogId: json['workoutLogId'] as String,
  exerciseLogId: json['exerciseLogId'] as String?,
  exerciseName: json['exerciseName'] as String?,
  dayNumber: (json['dayNumber'] as num).toInt(),
  isCompleted: json['isCompleted'] as bool,
  photoUrl: json['photoUrl'] as String,
  advisorReview: json['advisorReview'] == null
      ? null
      : AdvisorReview.fromJson(json['advisorReview'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$UploadWorkoutVideoDataToJson(
  UploadWorkoutVideoData instance,
) => <String, dynamic>{
  'workoutLogId': instance.workoutLogId,
  'exerciseLogId': instance.exerciseLogId,
  'exerciseName': instance.exerciseName,
  'dayNumber': instance.dayNumber,
  'isCompleted': instance.isCompleted,
  'photoUrl': instance.photoUrl,
  'advisorReview': instance.advisorReview?.toJson(),
  'createdAt': instance.createdAt.toIso8601String(),
};
