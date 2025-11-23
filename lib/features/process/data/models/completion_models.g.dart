// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'completion_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompletionPercentResponse _$CompletionPercentResponseFromJson(
  Map<String, dynamic> json,
) => CompletionPercentResponse(
  data: json['data'] == null
      ? null
      : CompletionPercentData.fromJson(json['data'] as Map<String, dynamic>),
  success: json['success'] as bool,
  message: json['message'] as String?,
);

Map<String, dynamic> _$CompletionPercentResponseToJson(
  CompletionPercentResponse instance,
) => <String, dynamic>{
  'data': instance.data,
  'success': instance.success,
  'message': instance.message,
};

CompletionPercentData _$CompletionPercentDataFromJson(
  Map<String, dynamic> json,
) => CompletionPercentData(
  completionPercent: (json['completionPercent'] as num?)?.toDouble(),
  checkpointNumber: (json['checkpointNumber'] as num).toInt(),
  planId: json['planId'] as String,
  planName: json['planName'] as String?,
  message: json['message'] as String?,
);

Map<String, dynamic> _$CompletionPercentDataToJson(
  CompletionPercentData instance,
) => <String, dynamic>{
  'completionPercent': instance.completionPercent,
  'checkpointNumber': instance.checkpointNumber,
  'planId': instance.planId,
  'planName': instance.planName,
  'message': instance.message,
};
