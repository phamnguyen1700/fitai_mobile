import 'package:fitai_mobile/features/process/data/models/generate_mealplan_with_target_models.dart';
import 'package:fitai_mobile/features/process/data/models/next_checkpoint_target_models.dart';
import 'package:fitai_mobile/features/process/data/models/prepare_next_checkpoint_response.dart';

import 'package:fitai_mobile/features/process/data/services/ai_healthplan_service.dart';

class AiHealthPlanRepository {
  final AiHealthPlanService _service;

  AiHealthPlanRepository({AiHealthPlanService? service})
    : _service = service ?? AiHealthPlanService();

  // Nếu cần dùng riêng từng bước vẫn expose ra:
  Future<PrepareNextCheckpointResponse> prepareNextCheckpoint() {
    return _service.prepareNextCheckpoint();
  }

  Future<NextCheckpointTargetResponse> getNextTarget() {
    return _service.getNextTarget();
  }

  Future<GenerateMealPlanWithTargetResponse> generateMealPlanWithTarget(
    int targetCalories,
  ) {
    return _service.generateMealPlanWithTarget(targetCalories);
  }

  /// FLOW FULL:
  /// 1) prepare-next-checkpoint
  /// 2) next-target
  /// 3) generate-with-target
  ///
  /// Trả về luôn meal plan đã generate.
  Future<GenerateMealPlanWithTargetResponse>
  prepareAndGenerateMealPlan() async {
    // 1) Prepare
    final prepare = await _service.prepareNextCheckpoint();
    if (!prepare.success) {
      throw Exception(
        prepare.message ?? "Không thể chuẩn bị checkpoint tiếp theo",
      );
    }

    // 2) Next target
    final targetRes = await _service.getNextTarget();
    if (!targetRes.success || targetRes.data == null) {
      throw Exception(
        targetRes.message ?? "Không thể lấy thông tin checkpoint tiếp theo",
      );
    }

    final targetCalories = targetRes.data!.targetCaloriesPerDay;
    if (targetCalories == null) {
      throw Exception("targetCaloriesPerDay bị null");
    }

    // 3) Generate meal plan
    final mealRes = await _service.generateMealPlanWithTarget(targetCalories);
    if (!mealRes.success) {
      throw Exception(mealRes.message ?? "Generate meal plan thất bại");
    }

    return mealRes;
  }
}
