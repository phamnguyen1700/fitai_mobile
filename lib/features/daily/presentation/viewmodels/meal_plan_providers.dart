import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fitai_mobile/features/daily/data/repositories/meal_plan_repositories.dart';
import 'package:fitai_mobile/features/daily/data/models/meal_plan_result.dart';

part 'meal_plan_providers.g.dart';

/// Repository singleton (codegen)
@riverpod
MealPlanRepository mealPlanRepository(MealPlanRepositoryRef ref) {
  return MealPlanRepository();
}

/// ============
/// Current Day
/// ============
@riverpod
class CurrentDay extends _$CurrentDay {
  @override
  int build() {
    final now = DateTime.now();
    return now.weekday; // Monday=1 → Sunday=7
  }

  void set(int value) => state = value;
}

/// ===============================
/// FETCH DAILY MEALS (result full)
/// ===============================
@riverpod
Future<MealPlanResult> dailyMeals(DailyMealsRef ref, int dayNumber) async {
  final repo = ref.watch(mealPlanRepositoryProvider);
  return repo.getDailyMeals(dayNumber: dayNumber);
}

/// ===============================
/// TODAY MEALS (theo currentDay)
/// ===============================
@riverpod
Future<MealPlanResult> todayMeals(TodayMealsRef ref) async {
  final day = ref.watch(currentDayProvider);
  return ref.watch(dailyMealsProvider(day).future);
}

/// ======================================
/// STATUS PROVIDER — để OnboardingGate bắt
/// ======================================
/// trả về: 'has_plan' | 'no_plan' | 'error' | 'loading'
@riverpod
String mealPlanStatus(MealPlanStatusRef ref) {
  final asyncResult = ref.watch(todayMealsProvider);

  return asyncResult.when(
    loading: () => 'loading',
    error: (_, __) => 'error',
    data: (result) => result.status,
  );
}
