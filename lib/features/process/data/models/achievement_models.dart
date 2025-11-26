// lib/features/process/data/models/achievement_models.dart
import 'package:json_annotation/json_annotation.dart';

part 'achievement_models.g.dart';

@JsonSerializable()
class AchievementSummary {
  final double? workoutPlanPercent;
  final double? mealPlanPercent;

  AchievementSummary({this.workoutPlanPercent, this.mealPlanPercent});

  factory AchievementSummary.fromJson(Map<String, dynamic> json) =>
      _$AchievementSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$AchievementSummaryToJson(this);
}
