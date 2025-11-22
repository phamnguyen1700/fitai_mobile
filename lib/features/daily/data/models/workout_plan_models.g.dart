// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_plan_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkoutPlanScheduleResponse _$WorkoutPlanScheduleResponseFromJson(
  Map<String, dynamic> json,
) => WorkoutPlanScheduleResponse(
  data: WorkoutPlanScheduleData.fromJson(json['data'] as Map<String, dynamic>),
  success: json['success'] as bool,
  message: json['message'] as String,
);

Map<String, dynamic> _$WorkoutPlanScheduleResponseToJson(
  WorkoutPlanScheduleResponse instance,
) => <String, dynamic>{
  'data': instance.data.toJson(),
  'success': instance.success,
  'message': instance.message,
};

WorkoutPlanScheduleData _$WorkoutPlanScheduleDataFromJson(
  Map<String, dynamic> json,
) => WorkoutPlanScheduleData(
  workoutPlanId: json['workoutPlanId'] as String,
  totalDays: (json['totalDays'] as num).toInt(),
  days: (json['days'] as List<dynamic>)
      .map((e) => WorkoutPlanDayModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$WorkoutPlanScheduleDataToJson(
  WorkoutPlanScheduleData instance,
) => <String, dynamic>{
  'workoutPlanId': instance.workoutPlanId,
  'totalDays': instance.totalDays,
  'days': instance.days.map((e) => e.toJson()).toList(),
};

WorkoutPlanDayModel _$WorkoutPlanDayModelFromJson(Map<String, dynamic> json) =>
    WorkoutPlanDayModel(
      dayNumber: (json['dayNumber'] as num).toInt(),
      dayName: json['dayName'] as String,
      totalExercises: (json['totalExercises'] as num).toInt(),
      exercises: (json['exercises'] as List<dynamic>)
          .map((e) => WorkoutExerciseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WorkoutPlanDayModelToJson(
  WorkoutPlanDayModel instance,
) => <String, dynamic>{
  'dayNumber': instance.dayNumber,
  'dayName': instance.dayName,
  'totalExercises': instance.totalExercises,
  'exercises': instance.exercises.map((e) => e.toJson()).toList(),
};

WorkoutExerciseModel _$WorkoutExerciseModelFromJson(
  Map<String, dynamic> json,
) => WorkoutExerciseModel(
  exerciseLogId: json['exerciseLogId'] as String?,
  exerciseId: json['exerciseId'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  category: json['category'] as String,
  videoUrl: json['videoUrl'] as String?,
  level: json['level'] as String,
  sets: (json['sets'] as num?)?.toInt(),
  reps: (json['reps'] as num?)?.toInt(),
  durationMinutes: (json['durationMinutes'] as num?)?.toInt(),
  note: json['note'] as String?,
  isCompleted: json['isCompleted'] as bool,
  commentCount: (json['commentCount'] as num).toInt(),
  advisorReview: json['advisorReview'] == null
      ? null
      : WorkoutAdvisorReview.fromJson(
          json['advisorReview'] as Map<String, dynamic>,
        ),
  videoLogUrl: json['videoLogUrl'] as String?,
);

Map<String, dynamic> _$WorkoutExerciseModelToJson(
  WorkoutExerciseModel instance,
) => <String, dynamic>{
  'exerciseLogId': instance.exerciseLogId,
  'exerciseId': instance.exerciseId,
  'name': instance.name,
  'description': instance.description,
  'category': instance.category,
  'videoUrl': instance.videoUrl,
  'level': instance.level,
  'sets': instance.sets,
  'reps': instance.reps,
  'durationMinutes': instance.durationMinutes,
  'note': instance.note,
  'isCompleted': instance.isCompleted,
  'commentCount': instance.commentCount,
  'advisorReview': instance.advisorReview?.toJson(),
  'videoLogUrl': instance.videoLogUrl,
};

WorkoutAdvisorReview _$WorkoutAdvisorReviewFromJson(
  Map<String, dynamic> json,
) => WorkoutAdvisorReview(
  advisorId: json['advisorId'] as String,
  completionPercent: (json['completionPercent'] as num?)?.toDouble(),
  reviewedAt: json['reviewedAt'] == null
      ? null
      : DateTime.parse(json['reviewedAt'] as String),
);

Map<String, dynamic> _$WorkoutAdvisorReviewToJson(
  WorkoutAdvisorReview instance,
) => <String, dynamic>{
  'advisorId': instance.advisorId,
  'completionPercent': instance.completionPercent,
  'reviewedAt': instance.reviewedAt?.toIso8601String(),
};
