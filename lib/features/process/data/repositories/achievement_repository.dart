// lib/features/process/data/repositories/achievement_repository.dart
import '../models/achievement_models.dart';
import '../services/achievement_service.dart';

class AchievementRepository {
  final AchievementService _service;

  AchievementRepository({AchievementService? service})
    : _service = service ?? AchievementService();

  Future<AchievementSummary?> fetchAchievementSummary() {
    return _service.getAchievementSummary();
  }
}
