// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'latest_body_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LatestBodyDataModel _$LatestBodyDataModelFromJson(Map<String, dynamic> json) =>
    LatestBodyDataModel(
      frontImageUrl: json['frontImageUrl'] as String?,
      rightImageUrl: json['rightImageUrl'] as String?,
      estimationId: json['estimationId'] as String?,
      customScanId: json['customScanId'] as String?,
      measurements: json['measurements'] as Map<String, dynamic>?,
      bodyComposition: json['bodyComposition'] as Map<String, dynamic>?,
      status: json['status'] as bool,
      userId: json['userId'] as String,
      activityLevel: json['activityLevel'] as String,
      bmi: (json['bmi'] as num).toDouble(),
      bmr: (json['bmr'] as num).toDouble(),
      tdee: (json['tdee'] as num).toDouble(),
      height: (json['height'] as num).toInt(),
      weight: (json['weight'] as num).toDouble(),
      id: json['id'] as String,
      lastCreate: DateTime.parse(json['lastCreate'] as String),
      lastUpdate: DateTime.parse(json['lastUpdate'] as String),
    );

Map<String, dynamic> _$LatestBodyDataModelToJson(
  LatestBodyDataModel instance,
) => <String, dynamic>{
  'frontImageUrl': instance.frontImageUrl,
  'rightImageUrl': instance.rightImageUrl,
  'estimationId': instance.estimationId,
  'customScanId': instance.customScanId,
  'measurements': instance.measurements,
  'bodyComposition': instance.bodyComposition,
  'status': instance.status,
  'userId': instance.userId,
  'activityLevel': instance.activityLevel,
  'bmi': instance.bmi,
  'bmr': instance.bmr,
  'tdee': instance.tdee,
  'height': instance.height,
  'weight': instance.weight,
  'id': instance.id,
  'lastCreate': instance.lastCreate.toIso8601String(),
  'lastUpdate': instance.lastUpdate.toIso8601String(),
};
