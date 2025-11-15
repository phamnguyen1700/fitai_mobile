// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_demo_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkoutDemoListResponse _$WorkoutDemoListResponseFromJson(
  Map<String, dynamic> json,
) => WorkoutDemoListResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  totalRecords: (json['totalRecords'] as num).toInt(),
  data: (json['data'] as List<dynamic>)
      .map((e) => WorkoutDemo.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$WorkoutDemoListResponseToJson(
  WorkoutDemoListResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'totalRecords': instance.totalRecords,
  'data': instance.data.map((e) => e.toJson()).toList(),
};

WorkoutDemo _$WorkoutDemoFromJson(Map<String, dynamic> json) => WorkoutDemo(
  workoutDemoId: json['workoutDemoId'] as String,
  planName: json['planName'] as String,
  isDeleted: json['isDeleted'] as bool,
  days: (json['days'] as List<dynamic>)
      .map((e) => WorkoutDay.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$WorkoutDemoToJson(WorkoutDemo instance) =>
    <String, dynamic>{
      'workoutDemoId': instance.workoutDemoId,
      'planName': instance.planName,
      'isDeleted': instance.isDeleted,
      'days': instance.days.map((e) => e.toJson()).toList(),
    };

WorkoutDay _$WorkoutDayFromJson(Map<String, dynamic> json) => WorkoutDay(
  day: (json['day'] as num).toInt(),
  dayName: json['dayName'] as String,
  exercises: (json['exercises'] as List<dynamic>)
      .map((e) => ExerciseItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$WorkoutDayToJson(WorkoutDay instance) =>
    <String, dynamic>{
      'day': instance.day,
      'dayName': instance.dayName,
      'exercises': instance.exercises.map((e) => e.toJson()).toList(),
    };

ExerciseItem _$ExerciseItemFromJson(Map<String, dynamic> json) => ExerciseItem(
  name: json['name'] as String?,
  description: json['description'] as String?,
  videoUrl: json['videoUrl'] as String?,
  level: json['level'] as String?,
  category: json['category'] == null
      ? null
      : ExerciseCategory.fromJson(json['category'] as Map<String, dynamic>),
  sets: (json['sets'] as num?)?.toInt(),
  reps: (json['reps'] as num?)?.toInt(),
  minutes: (json['minutes'] as num?)?.toInt(),
);

Map<String, dynamic> _$ExerciseItemToJson(ExerciseItem instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'videoUrl': instance.videoUrl,
      'level': instance.level,
      'category': instance.category?.toJson(),
      'sets': instance.sets,
      'reps': instance.reps,
      'minutes': instance.minutes,
    };

ExerciseCategory _$ExerciseCategoryFromJson(Map<String, dynamic> json) =>
    ExerciseCategory(
      name: json['name'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$ExerciseCategoryToJson(ExerciseCategory instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
    };
