// lib/features/process/data/services/achievement_service.dart
import 'package:fitai_mobile/core/api/api_client.dart'; // nơi có ApiClient.fitness()
import 'package:fitai_mobile/core/api/api_constants.dart';
import '../models/achievement_models.dart';

class AchievementService {
  final ApiClient _client;

  AchievementService({ApiClient? client})
    : _client = client ?? ApiClient.fitness();

  /// Gọi GET /api/checkpoints/achievement
  ///
  /// Response mẫu:
  /// {
  ///   "data": {
  ///     "workoutPlanPercent": null,
  ///     "mealPlanPercent": null
  ///   },
  ///   "success": true,
  ///   "message": "Achievement summary retrieved successfully"
  /// }
  Future<AchievementSummary?> getAchievementSummary() async {
    final res = await _client.get(ApiConstants.checkpointsAchievement);

    // Tuỳ backend, em có thể check statusCode / success ở đây
    final body = res.data;
    if (body is! Map<String, dynamic>) return null;

    final data = body['data'];
    if (data is! Map<String, dynamic>) return null;

    return AchievementSummary.fromJson(data);
  }
}
