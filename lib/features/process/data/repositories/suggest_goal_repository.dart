// lib/features/process/data/repositories/suggest_goal_repository.dart

import 'package:fitai_mobile/features/process/data/models/suggest_goal_models.dart';
import 'package:fitai_mobile/features/process/data/services/suggest_goal_service.dart';

/// Abstraction cho tầng domain / viewmodel dễ mock & test
abstract class ISuggestGoalRepository {
  Future<SuggestGoalResponse> getSuggestedGoal();

  /// null nếu API trả success = false
  Future<SuggestGoalData?> getSuggestedGoalData();

  /// true = cần đổi plan, false = không / hoặc request fail
  Future<bool> needToChangePlan();
}

class SuggestGoalRepository implements ISuggestGoalRepository {
  final SuggestGoalService _service;

  SuggestGoalRepository({SuggestGoalService? service})
    : _service = service ?? SuggestGoalService();

  @override
  Future<SuggestGoalResponse> getSuggestedGoal() {
    return _service.getSuggestedGoal();
  }

  @override
  Future<SuggestGoalData?> getSuggestedGoalData() {
    return _service.getSuggestedGoalData();
  }

  @override
  Future<bool> needToChangePlan() {
    return _service.needToChangePlan();
  }
}
