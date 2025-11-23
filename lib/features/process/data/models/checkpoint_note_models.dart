import 'package:json_annotation/json_annotation.dart';

part 'checkpoint_note_models.g.dart';

/// =======================
/// REQUEST: /checkpoints/note
/// =======================
@JsonSerializable()
class CheckpointNoteRequest {
  final bool remindWeekly;
  final bool sendReportEmail;
  final String note;

  CheckpointNoteRequest({
    required this.remindWeekly,
    required this.sendReportEmail,
    required this.note,
  });

  factory CheckpointNoteRequest.fromJson(Map<String, dynamic> json) =>
      _$CheckpointNoteRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CheckpointNoteRequestToJson(this);
}

/// =======================
/// RESPONSE: { "success": true }
/// =======================
@JsonSerializable()
class CheckpointNoteResponse {
  final bool success;

  CheckpointNoteResponse({required this.success});

  factory CheckpointNoteResponse.fromJson(Map<String, dynamic> json) =>
      _$CheckpointNoteResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CheckpointNoteResponseToJson(this);
}
