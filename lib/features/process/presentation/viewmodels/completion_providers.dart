import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:fitai_mobile/features/process/data/models/completion_models.dart';
import 'package:fitai_mobile/features/process/data/repositories/completion_repository.dart';

part 'completion_providers.g.dart';

/// Repo provider – để chỗ khác có thể override khi test
@riverpod
CompletionRepository completionRepository(CompletionRepositoryRef ref) {
  return CompletionRepository();
}

/// Lấy full data của previous checkpoint
@riverpod
Future<CompletionPercentData?> previousCompletionData(
  PreviousCompletionDataRef ref,
) async {
  final repo = ref.watch(completionRepositoryProvider);
  return repo.getPreviousCompletionData();
}

/// Lấy progress đã chuẩn hoá 0.0–1.0
/// Dùng để map vào WeeklyCheckInCard.progress
@riverpod
Future<double> previousCompletionProgress(
  PreviousCompletionProgressRef ref,
) async {
  final repo = ref.watch(completionRepositoryProvider);
  return repo.getPreviousCompletionProgress();
}
