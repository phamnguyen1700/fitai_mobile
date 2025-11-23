import 'package:dio/dio.dart';
import 'package:fitai_mobile/core/api/api_client.dart';
import 'package:fitai_mobile/core/api/api_constants.dart';

import '../models/completion_models.dart';

class CompletionService {
  final ApiClient _client;

  CompletionService({ApiClient? client})
    : _client = client ?? ApiClient.fitness();

  /// GET /checkpoints/previous/completion-percent
  Future<CompletionPercentResponse> getPreviousCheckpointCompletion() async {
    try {
      final Response res = await _client.get(
        ApiConstants.previousCheckpointCompletionPercent,
      );

      return CompletionPercentResponse.fromJson(
        res.data as Map<String, dynamic>,
      );
    } on DioException {
      rethrow;
    }
  }

  /// Helper tiện cho UI
  Future<CompletionPercentData?> getPreviousCompletionData() async {
    final resp = await getPreviousCheckpointCompletion();
    return resp.data;
  }
}
