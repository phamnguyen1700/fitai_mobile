import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fitai_mobile/features/daily/data/models/workout_plan_models.dart';
import 'package:fitai_mobile/features/daily/data/repositories/workout_plan_repositories.dart';

part 'workout_plan_providers.g.dart';

@riverpod
WorkoutPlanRepository workoutPlanRepository(WorkoutPlanRepositoryRef ref) {
  return WorkoutPlanRepository();
}

@riverpod
Future<WorkoutPlanScheduleData?> workoutPlanSchedule(
  WorkoutPlanScheduleRef ref,
) async {
  final repo = ref.read(workoutPlanRepositoryProvider);
  return repo.fetchWorkoutSchedule(); // <-- có thể trả null
}

@riverpod
Future<List<WorkoutPlanDayModel>> workoutPlanDays(
  WorkoutPlanDaysRef ref,
) async {
  final repo = ref.read(workoutPlanRepositoryProvider);
  return repo.fetchWorkoutDays(); // <-- trả [] nếu chưa có plan
}
