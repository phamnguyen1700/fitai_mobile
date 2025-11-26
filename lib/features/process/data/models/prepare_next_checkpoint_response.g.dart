// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prepare_next_checkpoint_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrepareNextCheckpointResponse _$PrepareNextCheckpointResponseFromJson(
  Map<String, dynamic> json,
) => PrepareNextCheckpointResponse(
  data: json['data'] as String?,
  success: json['success'] as bool,
  message: json['message'] as String?,
);

Map<String, dynamic> _$PrepareNextCheckpointResponseToJson(
  PrepareNextCheckpointResponse instance,
) => <String, dynamic>{
  'data': instance.data,
  'success': instance.success,
  'message': instance.message,
};
