import 'package:dio/dio.dart';
import '../models/meal_plan_models.dart';
import '../services/meal_plan_services.dart';

class MealPlanRepository {
  final MealPlanService _service;

  MealPlanRepository([MealPlanService? service])
    : _service = service ?? MealPlanService();

  Future<MealDayData> getDailyMeals({required int dayNumber}) async {
    try {
      final res = await _service.getDailyMeals(dayNumber: dayNumber);
      final json = res.data as Map<String, dynamic>;
      final parsed = DailyMealsResponse.fromJson(json);
      return parsed.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        return MealDayData.empty(dayNumber: dayNumber);
      }
      rethrow;
    }
  }
}
