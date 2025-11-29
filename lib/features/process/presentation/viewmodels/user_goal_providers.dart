import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitai_mobile/features/process/data/services/user_goal_service.dart';
import 'package:fitai_mobile/features/process/data/repositories/user_goal_repository.dart';

final userGoalServiceProvider = Provider<UserGoalService>((ref) {
  return UserGoalService();
});

final userGoalRepositoryProvider = Provider<IUserGoalRepository>((ref) {
  final service = ref.watch(userGoalServiceProvider);
  return UserGoalRepository(service: service);
});
