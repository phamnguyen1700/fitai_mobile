// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'process_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreviousCheckpointCompletionResponse
_$PreviousCheckpointCompletionResponseFromJson(Map<String, dynamic> json) =>
    PreviousCheckpointCompletionResponse(
      data: json['data'] == null
          ? null
          : CheckpointCompletionPercentData.fromJson(
              json['data'] as Map<String, dynamic>,
            ),
      success: json['success'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$PreviousCheckpointCompletionResponseToJson(
  PreviousCheckpointCompletionResponse instance,
) => <String, dynamic>{
  'data': instance.data,
  'success': instance.success,
  'message': instance.message,
};

CheckpointCompletionPercentData _$CheckpointCompletionPercentDataFromJson(
  Map<String, dynamic> json,
) => CheckpointCompletionPercentData(
  completionPercent: json['completionPercent'] as num?,
  checkpointNumber: (json['checkpointNumber'] as num?)?.toInt(),
  planId: json['planId'] as String?,
  planName: json['planName'] as String?,
  message: json['message'] as String?,
);

Map<String, dynamic> _$CheckpointCompletionPercentDataToJson(
  CheckpointCompletionPercentData instance,
) => <String, dynamic>{
  'completionPercent': instance.completionPercent,
  'checkpointNumber': instance.checkpointNumber,
  'planId': instance.planId,
  'planName': instance.planName,
  'message': instance.message,
};

ProgressLineChartResponse _$ProgressLineChartResponseFromJson(
  Map<String, dynamic> json,
) => ProgressLineChartResponse(
  data: (json['data'] as List<dynamic>)
      .map((e) => ProgressLineChartPoint.fromJson(e as Map<String, dynamic>))
      .toList(),
  success: json['success'] as bool,
  message: json['message'] as String,
);

Map<String, dynamic> _$ProgressLineChartResponseToJson(
  ProgressLineChartResponse instance,
) => <String, dynamic>{
  'data': instance.data,
  'success': instance.success,
  'message': instance.message,
};

ProgressLineChartPoint _$ProgressLineChartPointFromJson(
  Map<String, dynamic> json,
) => ProgressLineChartPoint(
  checkpointNumber: (json['checkpointNumber'] as num).toInt(),
  measuredAt: DateTime.parse(json['measuredAt'] as String),
  weightKg: (json['weightKg'] as num).toDouble(),
  skeletalMuscleMass: (json['skeletalMuscleMass'] as num).toDouble(),
  fatMassKg: (json['fatMassKg'] as num).toDouble(),
  frontImageUrl: json['frontImageUrl'] as String?,
  rightImageUrl: json['rightImageUrl'] as String?,
);

Map<String, dynamic> _$ProgressLineChartPointToJson(
  ProgressLineChartPoint instance,
) => <String, dynamic>{
  'checkpointNumber': instance.checkpointNumber,
  'measuredAt': instance.measuredAt.toIso8601String(),
  'weightKg': instance.weightKg,
  'skeletalMuscleMass': instance.skeletalMuscleMass,
  'fatMassKg': instance.fatMassKg,
  'frontImageUrl': instance.frontImageUrl,
  'rightImageUrl': instance.rightImageUrl,
};

BodyCompositionPieResponse _$BodyCompositionPieResponseFromJson(
  Map<String, dynamic> json,
) => BodyCompositionPieResponse(
  data: json['data'] == null
      ? null
      : BodyCompositionPieData.fromJson(json['data'] as Map<String, dynamic>),
  success: json['success'] as bool,
  message: json['message'] as String,
);

Map<String, dynamic> _$BodyCompositionPieResponseToJson(
  BodyCompositionPieResponse instance,
) => <String, dynamic>{
  'data': instance.data,
  'success': instance.success,
  'message': instance.message,
};

BodyCompositionPieData _$BodyCompositionPieDataFromJson(
  Map<String, dynamic> json,
) => BodyCompositionPieData(
  bodyFatPercent: (json['bodyFatPercent'] as num).toDouble(),
  skeletalMusclePercent: (json['skeletalMusclePercent'] as num).toDouble(),
  remainingPercent: (json['remainingPercent'] as num).toDouble(),
  fatLow: (json['fatLow'] as num).toDouble(),
  fatGood: (json['fatGood'] as num).toDouble(),
  fatHigh: (json['fatHigh'] as num).toDouble(),
  muscleGood: (json['muscleGood'] as num).toDouble(),
);

Map<String, dynamic> _$BodyCompositionPieDataToJson(
  BodyCompositionPieData instance,
) => <String, dynamic>{
  'bodyFatPercent': instance.bodyFatPercent,
  'skeletalMusclePercent': instance.skeletalMusclePercent,
  'remainingPercent': instance.remainingPercent,
  'fatLow': instance.fatLow,
  'fatGood': instance.fatGood,
  'fatHigh': instance.fatHigh,
  'muscleGood': instance.muscleGood,
};
