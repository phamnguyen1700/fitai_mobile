import 'package:dio/dio.dart';
import 'package:fitai_mobile/core/api/api_client.dart';
import 'package:fitai_mobile/core/api/api_constants.dart';
import 'package:fitai_mobile/features/process/data/models/checkpoint_note_models.dart';

class CheckpointNoteService {
  final ApiClient _client;

  CheckpointNoteService({ApiClient? client})
    : _client = client ?? ApiClient.fitness();

  /// POST /api/checkpoints/note
  Future<CheckpointNoteResponse> saveNote(CheckpointNoteRequest req) async {
    try {
      final Response res = await _client.post(
        ApiConstants.checkpointNote,
        data: req.toJson(),
      );

      return CheckpointNoteResponse.fromJson(res.data as Map<String, dynamic>);
    } on DioException {
      rethrow;
    }
  }

  /// Helper cho UI: trả về true/false
  Future<bool> saveNoteSuccess(CheckpointNoteRequest req) async {
    final resp = await saveNote(req);
    return resp.success;
  }
}
