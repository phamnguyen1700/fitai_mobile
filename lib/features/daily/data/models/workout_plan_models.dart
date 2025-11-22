import 'package:json_annotation/json_annotation.dart';

part 'workout_plan_models.g.dart';

/// -------------------------
/// Root Response
/// -------------------------
@JsonSerializable(explicitToJson: true)
class WorkoutPlanScheduleResponse {
  final WorkoutPlanScheduleData data;
  final bool success;
  final String message;

  WorkoutPlanScheduleResponse({
    required this.data,
    required this.success,
    required this.message,
  });

  factory WorkoutPlanScheduleResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkoutPlanScheduleResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutPlanScheduleResponseToJson(this);
}

/// -------------------------
/// Data Level
/// -------------------------
@JsonSerializable(explicitToJson: true)
class WorkoutPlanScheduleData {
  final String workoutPlanId;
  final int totalDays;
  final List<WorkoutPlanDayModel> days;

  WorkoutPlanScheduleData({
    required this.workoutPlanId,
    required this.totalDays,
    required this.days,
  });

  factory WorkoutPlanScheduleData.fromJson(Map<String, dynamic> json) =>
      _$WorkoutPlanScheduleDataFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutPlanScheduleDataToJson(this);
}

/// -------------------------
/// Day Model
/// -------------------------
@JsonSerializable(explicitToJson: true)
class WorkoutPlanDayModel {
  final int dayNumber;
  final String dayName;
  final int totalExercises;
  final List<WorkoutExerciseModel> exercises;

  WorkoutPlanDayModel({
    required this.dayNumber,
    required this.dayName,
    required this.totalExercises,
    required this.exercises,
  });

  factory WorkoutPlanDayModel.fromJson(Map<String, dynamic> json) =>
      _$WorkoutPlanDayModelFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutPlanDayModelToJson(this);
}

/// -------------------------
/// Exercise Model
/// -------------------------
@JsonSerializable(explicitToJson: true)
class WorkoutExerciseModel {
  final String? exerciseLogId;
  final String exerciseId;
  final String name;
  final String description;
  final String category;
  final String? videoUrl;
  final String level;
  final int? sets;
  final int? reps;
  final int? durationMinutes;
  final String? note;
  final bool isCompleted;
  final int commentCount;
  final WorkoutAdvisorReview? advisorReview;
  final String? videoLogUrl;

  WorkoutExerciseModel({
    required this.exerciseLogId,
    required this.exerciseId,
    required this.name,
    required this.description,
    required this.category,
    required this.videoUrl,
    required this.level,
    required this.sets,
    required this.reps,
    required this.durationMinutes,
    required this.note,
    required this.isCompleted,
    required this.commentCount,
    required this.advisorReview,
    required this.videoLogUrl,
  });

  factory WorkoutExerciseModel.fromJson(Map<String, dynamic> json) =>
      _$WorkoutExerciseModelFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutExerciseModelToJson(this);
}

/// -------------------------
/// Advisor Review
/// -------------------------
@JsonSerializable()
class WorkoutAdvisorReview {
  final String advisorId;
  final double? completionPercent;
  final DateTime? reviewedAt;

  WorkoutAdvisorReview({
    required this.advisorId,
    required this.completionPercent,
    required this.reviewedAt,
  });

  factory WorkoutAdvisorReview.fromJson(Map<String, dynamic> json) =>
      _$WorkoutAdvisorReviewFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutAdvisorReviewToJson(this);
}
