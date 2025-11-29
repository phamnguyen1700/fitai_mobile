import 'package:dio/dio.dart';
import 'package:fitai_mobile/core/api/api_client.dart';
import 'package:fitai_mobile/core/api/api_constants.dart';
import 'package:fitai_mobile/features/process/data/models/suggest_goal_models.dart';

class SuggestGoalService {
  final ApiClient _client;

  SuggestGoalService({ApiClient? client})
    : _client = client ?? ApiClient.fitness();

  /// GET /api/checkpoints/suggest-goal
  Future<SuggestGoalResponse> getSuggestedGoal() async {
    try {
      final Response res = await _client.get(ApiConstants.suggestGoal);

      return SuggestGoalResponse.fromJson(res.data as Map<String, dynamic>);
    } on DioException {
      rethrow;
    }
  }

  /// Helper cho UI: chỉ cần lấy data bên trong
  Future<SuggestGoalData?> getSuggestedGoalData() async {
    final resp = await getSuggestedGoal();
    // nếu success = false thì trả null cho dễ handle
    if (!resp.success) return null;
    return resp.data;
  }

  /// Helper cho UI: chỉ cần check có cần đổi plan hay không
  Future<bool> needToChangePlan() async {
    final resp = await getSuggestedGoal();
    return resp.success && resp.data.needToChangePlan;
  }
}
