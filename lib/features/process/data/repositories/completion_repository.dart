import 'package:dio/dio.dart';
import 'package:fitai_mobile/features/process/data/services/completion_service.dart';
import 'package:fitai_mobile/features/process/data/models/completion_result.dart';

class CompletionRepository {
  final CompletionService _service;

  CompletionRepository({CompletionService? service})
    : _service = service ?? CompletionService();

  /// Trả về CompletionResult thay vì chỉ model
  Future<CompletionResult> getPreviousCompletion() async {
    try {
      final res = await _service.getPreviousCheckpointCompletion();
      final data = res.data;

      final msg = data?.message?.toLowerCase() ?? '';

      if (msg.contains('không tìm thấy plan active') ||
          msg.contains('no active')) {
        return CompletionResult.noPlan(data);
      }

      return CompletionResult.hasPlan(data!);
    } on DioException {
      return CompletionResult.error();
    } catch (_) {
      return CompletionResult.error();
    }
  }
}
