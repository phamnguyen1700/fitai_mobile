import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitai_mobile/features/process/data/services/suggest_goal_service.dart';
import 'package:fitai_mobile/features/process/data/repositories/suggest_goal_repository.dart';

/// Service provider
final suggestGoalServiceProvider = Provider<SuggestGoalService>((ref) {
  return SuggestGoalService();
});

/// Repository provider
final suggestGoalRepositoryProvider = Provider<ISuggestGoalRepository>((ref) {
  final service = ref.watch(suggestGoalServiceProvider);
  return SuggestGoalRepository(service: service);
});
