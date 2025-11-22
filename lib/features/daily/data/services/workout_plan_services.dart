import 'package:dio/dio.dart';
import 'package:fitai_mobile/core/api/api_client.dart';
import 'package:fitai_mobile/core/api/api_constants.dart';
import 'package:fitai_mobile/features/daily/data/models/workout_plan_models.dart';

class WorkoutPlanService {
  final ApiClient _client;

  /// Mặc định dùng ApiClient.fitness()
  WorkoutPlanService([ApiClient? client])
    : _client = client ?? ApiClient.fitness();

  /// Gọi raw, nếu bạn muốn tự xử lý response/error bên ngoài
  Future<Response<dynamic>> getScheduleRaw() {
    return _client.get<dynamic>(ApiConstants.workoutPlanSchedule);
  }

  /// Gọi và parse thẳng sang model đã sinh .g.dart
  Future<WorkoutPlanScheduleData> getSchedule() async {
    final res = await getScheduleRaw();

    final json = res.data as Map<String, dynamic>;
    final parsed = WorkoutPlanScheduleResponse.fromJson(json);

    return parsed.data;
  }
}
