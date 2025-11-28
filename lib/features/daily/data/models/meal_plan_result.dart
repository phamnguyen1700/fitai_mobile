import 'package:fitai_mobile/features/daily/data/models/meal_plan_models.dart';

class MealPlanResult {
  final MealDayData? data;
  final String status; // 'has_plan' | 'no_plan' | 'error'

  const MealPlanResult({required this.data, required this.status});

  factory MealPlanResult.noPlan() =>
      const MealPlanResult(data: null, status: 'no_plan');

  factory MealPlanResult.hasPlan(MealDayData d) =>
      MealPlanResult(data: d, status: 'has_plan');

  factory MealPlanResult.error() =>
      const MealPlanResult(data: null, status: 'error');
}
