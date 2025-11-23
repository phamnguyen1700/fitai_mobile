import 'package:fitai_mobile/features/process/data/models/completion_models.dart';
import 'package:fitai_mobile/features/process/data/services/completion_service.dart';

class CompletionRepository {
  final CompletionService _service;

  CompletionRepository({CompletionService? service})
    : _service = service ?? CompletionService();

  /// Lấy full response (nếu cần meta / message)
  Future<CompletionPercentResponse> getPreviousCheckpointCompletion() {
    return _service.getPreviousCheckpointCompletion();
  }

  /// Lấy riêng phần `data`
  Future<CompletionPercentData?> getPreviousCompletionData() {
    return _service.getPreviousCompletionData();
  }

  /// Helper cho UI: trả về progress 0.0–1.0
  ///
  /// - Nếu completionPercent null => trả về 0.0
  /// - Nếu >100 hoặc <0 => clamp trong [0, 100] cho chắc
  Future<double> getPreviousCompletionProgress() async {
    final data = await _service.getPreviousCompletionData();
    final percent = data?.completionPercent;

    if (percent == null) return 0.0;

    final clamped = percent.clamp(0, 100);
    return clamped / 100.0;
  }
}
