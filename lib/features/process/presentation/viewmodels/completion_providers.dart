import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:fitai_mobile/features/process/data/models/completion_models.dart';
import 'package:fitai_mobile/features/process/data/models/completion_result.dart';
import 'package:fitai_mobile/features/process/data/repositories/completion_repository.dart';

part 'completion_providers.g.dart';

/// Repo provider (singleton)
@riverpod
CompletionRepository completionRepository(CompletionRepositoryRef ref) {
  return CompletionRepository();
}

/// ======================================
/// Lấy full CompletionResult từ repo
/// ======================================
@riverpod
Future<CompletionResult> previousCompletionResult(
  PreviousCompletionResultRef ref,
) async {
  final repo = ref.watch(completionRepositoryProvider);
  return repo.getPreviousCompletion();
}

/// ======================================
/// Chỉ lấy phần data cho UI
/// (CompletionPercentData? hoặc null)
/// ======================================
@riverpod
Future<CompletionPercentData?> previousCompletionData(
  PreviousCompletionDataRef ref,
) async {
  final result = await ref.watch(previousCompletionResultProvider.future);
  return result.data;
}

/// ======================================
/// Lấy progress cho WeeklyCheckInCard
/// result.status != has_plan → progress = 0
/// ======================================
@riverpod
Future<double> previousCompletionProgress(
  PreviousCompletionProgressRef ref,
) async {
  final result = await ref.watch(previousCompletionResultProvider.future);
  final data = result.data;

  if (result.status != 'has_plan') return 0.0;
  if (data == null || data.completionPercent == null) return 0.0;

  final pct = data.completionPercent!.clamp(0, 100);
  return pct / 100.0;
}

/// ======================================
/// STATUS PROVIDER (dùng cho OnboardingGate)
/// Trả về: "has_plan" | "no_plan" | "error" | "loading"
/// ======================================
@riverpod
String checkpointStatus(CheckpointStatusRef ref) {
  final asyncResult = ref.watch(previousCompletionResultProvider);

  return asyncResult.when(
    loading: () => 'loading',
    error: (_, __) => 'error',
    data: (result) => result.status,
  );
}
