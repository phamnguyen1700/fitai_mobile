import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/activity_level_metadata.dart';
import '../../data/repositories/activity_level_repository.dart';

final activityLevelRepositoryProvider = Provider<ActivityLevelRepository>(
  (ref) => ActivityLevelRepository(),
);

final activityLevelsProvider = FutureProvider<List<ActivityLevelMetadata>>((
  ref,
) async {
  final repo = ref.watch(activityLevelRepositoryProvider);
  return repo.getActivityLevels();
});
