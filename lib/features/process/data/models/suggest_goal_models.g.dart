// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suggest_goal_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SuggestGoalResponse _$SuggestGoalResponseFromJson(Map<String, dynamic> json) =>
    SuggestGoalResponse(
      data: SuggestGoalData.fromJson(json['data'] as Map<String, dynamic>),
      success: json['success'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$SuggestGoalResponseToJson(
  SuggestGoalResponse instance,
) => <String, dynamic>{
  'data': instance.data,
  'success': instance.success,
  'message': instance.message,
};

SuggestGoalData _$SuggestGoalDataFromJson(Map<String, dynamic> json) =>
    SuggestGoalData(
      goalType: (json['goalType'] as num).toInt(),
      goalName: json['goalName'] as String,
      goalNameVi: json['goalNameVi'] as String,
      needToChangePlan: json['needToChangePlan'] as bool,
    );

Map<String, dynamic> _$SuggestGoalDataToJson(SuggestGoalData instance) =>
    <String, dynamic>{
      'goalType': instance.goalType,
      'goalName': instance.goalName,
      'goalNameVi': instance.goalNameVi,
      'needToChangePlan': instance.needToChangePlan,
    };
