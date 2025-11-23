// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkpoint_note_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckpointNoteRequest _$CheckpointNoteRequestFromJson(
  Map<String, dynamic> json,
) => CheckpointNoteRequest(
  remindWeekly: json['remindWeekly'] as bool,
  sendReportEmail: json['sendReportEmail'] as bool,
  note: json['note'] as String,
);

Map<String, dynamic> _$CheckpointNoteRequestToJson(
  CheckpointNoteRequest instance,
) => <String, dynamic>{
  'remindWeekly': instance.remindWeekly,
  'sendReportEmail': instance.sendReportEmail,
  'note': instance.note,
};

CheckpointNoteResponse _$CheckpointNoteResponseFromJson(
  Map<String, dynamic> json,
) => CheckpointNoteResponse(success: json['success'] as bool);

Map<String, dynamic> _$CheckpointNoteResponseToJson(
  CheckpointNoteResponse instance,
) => <String, dynamic>{'success': instance.success};
