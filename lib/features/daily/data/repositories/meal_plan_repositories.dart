import 'package:dio/dio.dart';
import '../models/meal_plan_models.dart';
import '../services/meal_plan_services.dart';
import '../models/meal_plan_result.dart';

class MealPlanRepository {
  final MealPlanService _service;

  MealPlanRepository([MealPlanService? service])
    : _service = service ?? MealPlanService();

  Future<MealPlanResult> getDailyMeals({required int dayNumber}) async {
    try {
      final res = await _service.getDailyMeals(dayNumber: dayNumber);

      final json = res.data as Map<String, dynamic>;
      final parsed = DailyMealsResponse.fromJson(json);

      return MealPlanResult.hasPlan(parsed.data);
    } on DioException catch (e) {
      final msg = e.response?.data?['message']?.toString().toLowerCase();

      if (msg != null && msg.contains('no active workout plan')) {
        return MealPlanResult.noPlan();
      }

      return MealPlanResult.error();
    }
  }
}
