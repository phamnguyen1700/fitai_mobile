// lib/features/process/presentation/viewmodels/achievement_providers.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/achievement_repository.dart';
import '../../data/models/achievement_models.dart';

part 'achievement_providers.g.dart';

/// Repo provider (keepAlive vì xài nhiều chỗ cũng ok)
@Riverpod(keepAlive: true)
AchievementRepository achievementRepository(AchievementRepositoryRef ref) {
  return AchievementRepository();
}

/// FutureProvider load AchievementSummary từ repo
@riverpod
Future<AchievementSummary?> achievementSummary(
  AchievementSummaryRef ref,
) async {
  final repo = ref.watch(achievementRepositoryProvider);
  return repo.fetchAchievementSummary();
}
