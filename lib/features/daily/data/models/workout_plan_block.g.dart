// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_plan_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkoutPlanBlock _$WorkoutPlanBlockFromJson(Map<String, dynamic> json) =>
    WorkoutPlanBlock(
      title: json['title'] as String,
      leftStat: json['leftStat'] as String,
      rightStat: json['rightStat'] as String,
      progress: (json['progress'] as num).toDouble(),
      calories: (json['calories'] as num).toInt(),
      levels: (json['levels'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      videoTitle: json['videoTitle'] as String,
      videoThumb: json['videoThumb'] as String,
      category: json['category'] as String,
      sets: (json['sets'] as num?)?.toInt(),
      reps: (json['reps'] as num?)?.toInt(),
      minutes: (json['minutes'] as num?)?.toInt(),
      checked: json['checked'] as bool? ?? false,
      selectedLevelIndex: (json['selectedLevelIndex'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$WorkoutPlanBlockToJson(WorkoutPlanBlock instance) =>
    <String, dynamic>{
      'title': instance.title,
      'leftStat': instance.leftStat,
      'rightStat': instance.rightStat,
      'progress': instance.progress,
      'calories': instance.calories,
      'levels': instance.levels,
      'videoTitle': instance.videoTitle,
      'videoThumb': instance.videoThumb,
      'checked': instance.checked,
      'selectedLevelIndex': instance.selectedLevelIndex,
      'category': instance.category,
      'sets': instance.sets,
      'reps': instance.reps,
      'minutes': instance.minutes,
    };
