// lib/features/process/data/repositories/process_repository.dart
import 'package:fitai_mobile/features/daily/data/models/process_models.dart';
import 'package:fitai_mobile/features/daily/data/services/process_services.dart';

class ProcessRepository {
  final ProcessService _service;

  ProcessRepository([ProcessService? service])
    : _service = service ?? ProcessService();

  /// Previous checkpoint completion percent
  ///
  /// GET /api/checkpoints/previous/completion-percent
  Future<PreviousCheckpointCompletionResponse>
  getPreviousCheckpointCompletionPercent() async {
    final res = await _service.getPreviousCheckpointCompletionPercentRaw();

    // res.data dạng Map<String, dynamic>
    return PreviousCheckpointCompletionResponse.fromJson(
      res.data as Map<String, dynamic>,
    );
  }

  /// Progress line chart data
  ///
  /// GET /api/checkpoints/linechart
  Future<ProgressLineChartResponse> getProgressLineChart() async {
    final res = await _service.getLineChartRaw();

    return ProgressLineChartResponse.fromJson(res.data as Map<String, dynamic>);
  }

  /// Body composition cho pie chart
  ///
  /// GET /api/checkpoints/piechart
  Future<BodyCompositionPieResponse> getBodyCompositionPie() async {
    final res = await _service.getPieChartRaw();

    return BodyCompositionPieResponse.fromJson(
      res.data as Map<String, dynamic>,
    );
  }
}
