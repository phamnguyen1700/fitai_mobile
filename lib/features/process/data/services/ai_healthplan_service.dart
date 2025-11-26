import 'package:fitai_mobile/core/api/api_client.dart';
import 'package:fitai_mobile/core/api/api_constants.dart';

import 'package:fitai_mobile/features/process/data/models/prepare_next_checkpoint_response.dart';
import 'package:fitai_mobile/features/process/data/models/next_checkpoint_target_models.dart';
import 'package:fitai_mobile/features/process/data/models/generate_mealplan_with_target_models.dart';

class AiHealthPlanService {
  final ApiClient _client;

  AiHealthPlanService({ApiClient? client})
    : _client = client ?? ApiClient.fitness();

  /// 1) POST /api/aihealthplan/prepare-next-checkpoint
  Future<PrepareNextCheckpointResponse> prepareNextCheckpoint() async {
    final res = await _client.post(ApiConstants.prepareNextCheckpoint);
    return PrepareNextCheckpointResponse.fromJson(res.data);
  }

  /// 2) GET /api/checkpoints/next-target
  Future<NextCheckpointTargetResponse> getNextTarget() async {
    final res = await _client.get(ApiConstants.nextTarget);
    return NextCheckpointTargetResponse.fromJson(res.data);
  }

  /// 3) POST /api/mealplan/generate-with-target
  Future<GenerateMealPlanWithTargetResponse> generateMealPlanWithTarget(
    int targetCalories,
  ) async {
    final body = {"targetCalories": targetCalories};

    final res = await _client.post(
      ApiConstants.generateMealPlanWithTarget,
      data: body,
    );

    return GenerateMealPlanWithTargetResponse.fromJson(res.data);
  }
}
