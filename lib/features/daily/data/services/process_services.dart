// lib/features/xxx/data/services/process_service.dart
import 'package:dio/dio.dart';
import 'package:fitai_mobile/core/api/api_client.dart';
import 'package:fitai_mobile/core/api/api_constants.dart';

class ProcessService {
  final ApiClient _client;

  // Nếu sau này bạn muốn trỏ sang microservice khác
  // chỉ cần đổi ApiClient() thành ApiClient.xxx()
  ProcessService([ApiClient? client]) : _client = client ?? ApiClient.fitness();

  /// GET /api/checkpoints/previous/completion-percent
  /// Customer: Get previous checkpoint completion percent
  Future<Response<dynamic>> getPreviousCheckpointCompletionPercentRaw() {
    return _client.get<dynamic>(
      ApiConstants.previousCheckpointCompletionPercent,
    );
  }

  /// GET /api/checkpoints/linechart
  /// Customer: Get progress line chart data
  Future<Response<dynamic>> getLineChartRaw() {
    return _client.get<dynamic>(ApiConstants.checkpointsLineChart);
  }

  /// GET /api/checkpoints/piechart
  /// Customer: Get latest body composition for pie chart
  Future<Response<dynamic>> getPieChartRaw() {
    return _client.get<dynamic>(ApiConstants.checkpointsPieChart);
  }
}
