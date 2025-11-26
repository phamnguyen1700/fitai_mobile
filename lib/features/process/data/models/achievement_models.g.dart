// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievement_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AchievementSummary _$AchievementSummaryFromJson(Map<String, dynamic> json) =>
    AchievementSummary(
      workoutPlanPercent: (json['workoutPlanPercent'] as num?)?.toDouble(),
      mealPlanPercent: (json['mealPlanPercent'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$AchievementSummaryToJson(AchievementSummary instance) =>
    <String, dynamic>{
      'workoutPlanPercent': instance.workoutPlanPercent,
      'mealPlanPercent': instance.mealPlanPercent,
    };
