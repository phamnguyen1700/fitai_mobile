// lib/features/process/presentation/viewmodels/ai_healthplan_providers.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:fitai_mobile/features/process/data/services/ai_healthplan_service.dart';
import 'package:fitai_mobile/features/process/data/repositories/ai_healthplan_repository.dart';
import 'package:fitai_mobile/features/process/data/models/generate_mealplan_with_target_models.dart';
import 'package:fitai_mobile/features/process/data/models/next_checkpoint_target_models.dart';

// Dùng lại model DailyMealPlan + MealPlanCoreData từ flow cũ
import 'package:fitai_mobile/features/home/data/models/chat_thread_models.dart'
    show DailyMealPlan;

part 'ai_healthplan_providers.g.dart';

// ===================== NEXT CHECKPOINT TARGET ===================== //

@Riverpod(keepAlive: true)
Future<NextCheckpointTarget?> nextCheckpointTarget(
  NextCheckpointTargetRef ref,
) async {
  final repo = ref.watch(aiHealthPlanRepositoryProvider);

  final res = await repo.getNextTarget();

  if (!res.success) {
    throw Exception(
      res.message ?? 'Không thể lấy thông tin checkpoint tiếp theo',
    );
  }

  return res.data;
}

// ===================== SERVICE ===================== //

@Riverpod(keepAlive: true)
AiHealthPlanService aiHealthPlanService(AiHealthPlanServiceRef ref) {
  return AiHealthPlanService();
}

// ===================== REPOSITORY ===================== //

@Riverpod(keepAlive: true)
AiHealthPlanRepository aiHealthPlanRepository(AiHealthPlanRepositoryRef ref) {
  final service = ref.watch(aiHealthPlanServiceProvider);
  return AiHealthPlanRepository(service: service);
}

// ===================== MEAL PLAN GENERATE (3 API CHAIN) ===================== //

@Riverpod(keepAlive: true)
Future<GenerateMealPlanWithTargetResponse> mealPlanGenerate(
  MealPlanGenerateRef ref,
) async {
  final repo = ref.watch(aiHealthPlanRepositoryProvider);
  return repo.prepareAndGenerateMealPlan();
}

/// Trả về danh sách DailyMealPlan (7–14 ngày) cho UI dùng
@Riverpod(keepAlive: true)
Future<List<DailyMealPlan>> mealPlanDays(MealPlanDaysRef ref) async {
  final resp = await ref.watch(mealPlanGenerateProvider.future);

  final data = resp.data;
  if (data == null) return [];

  // JSON dạng:
  // {
  //   "data": {
  //     "processingTime": "...",
  //     "targetCalories": 2400,
  //     "data": { "dailyMeals": [ ... ] }
  //   },
  //   ...
  // }
  //
  // => resp.data (GenerateMealPlanWithTargetData)
  //    .data (MealPlanCoreData)
  //    .dailyMeals (List<DailyMealPlan>)
  return data.data.dailyMeals;
}
