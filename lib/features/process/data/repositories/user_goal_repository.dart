import 'package:fitai_mobile/features/process/data/services/user_goal_service.dart';

abstract class IUserGoalRepository {
  Future<bool> updateUserGoal(String goalName);
}

class UserGoalRepository implements IUserGoalRepository {
  final UserGoalService _service;

  UserGoalRepository({UserGoalService? service})
    : _service = service ?? UserGoalService();

  @override
  Future<bool> updateUserGoal(String goalName) {
    return _service.updateUserGoal(goalName);
  }
}
