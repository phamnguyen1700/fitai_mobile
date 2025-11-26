// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'next_checkpoint_target_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NextCheckpointTarget _$NextCheckpointTargetFromJson(
  Map<String, dynamic> json,
) => NextCheckpointTarget(
  expectedWeightChangeKg: (json['expectedWeightChangeKg'] as num?)?.toDouble(),
  startWeightKg: (json['startWeightKg'] as num?)?.toDouble(),
  targetWeightKg: (json['targetWeightKg'] as num?)?.toDouble(),
  goalText: json['goalText'] as String?,
  targetCaloriesPerDay: (json['targetCaloriesPerDay'] as num?)?.toInt(),
  nutritionText: json['nutritionText'] as String?,
);

Map<String, dynamic> _$NextCheckpointTargetToJson(
  NextCheckpointTarget instance,
) => <String, dynamic>{
  'expectedWeightChangeKg': instance.expectedWeightChangeKg,
  'startWeightKg': instance.startWeightKg,
  'targetWeightKg': instance.targetWeightKg,
  'goalText': instance.goalText,
  'targetCaloriesPerDay': instance.targetCaloriesPerDay,
  'nutritionText': instance.nutritionText,
};

NextCheckpointTargetResponse _$NextCheckpointTargetResponseFromJson(
  Map<String, dynamic> json,
) => NextCheckpointTargetResponse(
  data: json['data'] == null
      ? null
      : NextCheckpointTarget.fromJson(json['data'] as Map<String, dynamic>),
  success: json['success'] as bool,
  message: json['message'] as String?,
);

Map<String, dynamic> _$NextCheckpointTargetResponseToJson(
  NextCheckpointTargetResponse instance,
) => <String, dynamic>{
  'data': instance.data,
  'success': instance.success,
  'message': instance.message,
};
