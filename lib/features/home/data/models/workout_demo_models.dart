import 'package:json_annotation/json_annotation.dart';

part 'workout_demo_models.g.dart';

/// ====== TOP-LEVEL RESPONSE ======
@JsonSerializable(explicitToJson: true)
class WorkoutDemoListResponse {
  final bool success;
  final String message;
  final int totalRecords;
  final List<WorkoutDemo> data;

  const WorkoutDemoListResponse({
    required this.success,
    required this.message,
    required this.totalRecords,
    required this.data,
  });

  factory WorkoutDemoListResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkoutDemoListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutDemoListResponseToJson(this);
}

/// ====== WORKOUT DEMO ======
@JsonSerializable(explicitToJson: true)
class WorkoutDemo {
  final String workoutDemoId;
  final String planName;
  final bool isDeleted;
  final List<WorkoutDay> days;

  const WorkoutDemo({
    required this.workoutDemoId,
    required this.planName,
    required this.isDeleted,
    required this.days,
  });

  factory WorkoutDemo.fromJson(Map<String, dynamic> json) =>
      _$WorkoutDemoFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutDemoToJson(this);
}

/// ====== DAY ======
@JsonSerializable(explicitToJson: true)
class WorkoutDay {
  final int day;
  final String dayName;
  final List<ExerciseItem> exercises;

  const WorkoutDay({
    required this.day,
    required this.dayName,
    required this.exercises,
  });

  factory WorkoutDay.fromJson(Map<String, dynamic> json) =>
      _$WorkoutDayFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutDayToJson(this);
}

/// ====== EXERCISE ======
@JsonSerializable(explicitToJson: true)
class ExerciseItem {
  final String? name;
  final String? description;
  final String? videoUrl;

  /// Beginner | Intermediate | Advanced | null (theo dữ liệu của bạn)
  final String? level;

  final ExerciseCategory? category;

  /// Với cardio thì có thể null
  final int? sets;
  final int? reps;

  /// Với cardio có minutes, còn lại thường null
  final int? minutes;

  const ExerciseItem({
    this.name,
    this.description,
    this.videoUrl,
    this.level,
    this.category,
    this.sets,
    this.reps,
    this.minutes,
  });

  factory ExerciseItem.fromJson(Map<String, dynamic> json) =>
      _$ExerciseItemFromJson(json);

  Map<String, dynamic> toJson() => _$ExerciseItemToJson(this);
}

/// ====== CATEGORY ======
@JsonSerializable()
class ExerciseCategory {
  final String name;
  final String description;

  const ExerciseCategory({required this.name, required this.description});

  factory ExerciseCategory.fromJson(Map<String, dynamic> json) =>
      _$ExerciseCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$ExerciseCategoryToJson(this);
}
