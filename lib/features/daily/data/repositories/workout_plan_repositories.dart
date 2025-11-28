import 'package:dio/dio.dart';
import 'package:fitai_mobile/features/daily/data/models/workout_plan_models.dart';
import 'package:fitai_mobile/features/daily/data/services/workout_plan_services.dart';

class WorkoutPlanRepository {
  final WorkoutPlanService _service;

  WorkoutPlanRepository([WorkoutPlanService? service])
    : _service = service ?? WorkoutPlanService();

  /// Lấy toàn bộ lịch tập hiện tại (có thể null nếu chưa có plan)
  Future<WorkoutPlanScheduleData?> fetchWorkoutSchedule() async {
    try {
      final data = await _service.getSchedule();
      return data;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final body = e.response?.data;
      final msg = body is Map<String, dynamic>
          ? body['message'] as String?
          : null;

      // ✅ user chưa có workout plan -> KHÔNG coi là lỗi
      if (status == 400 && msg == 'No active workout plan') {
        return null;
      }

      rethrow;
    }
  }

  /// Helper: chỉ cần list ngày tập
  Future<List<WorkoutPlanDayModel>> fetchWorkoutDays() async {
    final schedule = await fetchWorkoutSchedule();

    // ✅ Không có plan -> list rỗng
    if (schedule == null) return <WorkoutPlanDayModel>[];

    return schedule.days;
  }
}
