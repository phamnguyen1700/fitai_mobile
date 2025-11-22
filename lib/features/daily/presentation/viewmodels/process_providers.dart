import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:fitai_mobile/features/daily/data/repositories/process_repositories.dart';
import 'package:fitai_mobile/features/daily/data/models/process_models.dart';

part 'process_providers.g.dart';

/// Provider cho ProcessRepository
@riverpod
ProcessRepository processRepository(ProcessRepositoryRef ref) {
  return ProcessRepository();
}

/// Previous checkpoint completion percent
///
/// GET /api/checkpoints/previous/completion-percent
@riverpod
Future<PreviousCheckpointCompletionResponse> previousCheckpointCompletion(
  PreviousCheckpointCompletionRef ref,
) {
  final repo = ref.read(processRepositoryProvider);
  return repo.getPreviousCheckpointCompletionPercent();
}

/// Progress line chart
///
/// GET /api/checkpoints/linechart
@riverpod
Future<ProgressLineChartResponse> progressLineChart(ProgressLineChartRef ref) {
  final repo = ref.read(processRepositoryProvider);
  return repo.getProgressLineChart();
}

/// Body composition pie chart
///
/// GET /api/checkpoints/piechart
@riverpod
Future<BodyCompositionPieResponse> bodyCompositionPie(
  BodyCompositionPieRef ref,
) {
  final repo = ref.read(processRepositoryProvider);
  return repo.getBodyCompositionPie();
}
