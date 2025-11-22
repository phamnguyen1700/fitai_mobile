import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fitai_mobile/features/daily/data/models/meal_plan_models.dart';
import 'package:fitai_mobile/features/daily/data/repositories/meal_plan_repositories.dart';

part 'meal_plan_providers.g.dart';

/// Repository singleton (codegen)
@riverpod
MealPlanRepository mealPlanRepository(MealPlanRepositoryRef ref) {
  return MealPlanRepository();
}

@riverpod
class CurrentDay extends _$CurrentDay {
  @override
  int build() {
    final now = DateTime.now();
    return now.weekday;
  }

  void set(int value) => state = value;
}

@riverpod
Future<MealDayData> dailyMeals(DailyMealsRef ref, int dayNumber) async {
  final repo = ref.watch(mealPlanRepositoryProvider);
  return repo.getDailyMeals(dayNumber: dayNumber);
}

@riverpod
Future<MealDayData> todayMeals(TodayMealsRef ref) async {
  final day = ref.watch(currentDayProvider);
  return ref.watch(dailyMealsProvider(day).future);
}
