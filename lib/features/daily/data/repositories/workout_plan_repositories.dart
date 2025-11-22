import 'package:fitai_mobile/features/daily/data/models/workout_plan_models.dart';
import 'package:fitai_mobile/features/daily/data/services/workout_plan_services.dart';

/// Repository cho workout plan:
/// - Ẩn chi tiết gọi API
/// - Trả về model đã parse sẵn
class WorkoutPlanRepository {
  final WorkoutPlanService _service;

  WorkoutPlanRepository([WorkoutPlanService? service])
    : _service = service ?? WorkoutPlanService();

  /// Lấy toàn bộ lịch tập hiện tại (planId + tổng ngày + list ngày + bài)
  Future<WorkoutPlanScheduleData> fetchWorkoutSchedule() async {
    final data = await _service.getSchedule();
    return data;
  }

  /// Helper: chỉ cần list ngày tập
  Future<List<WorkoutPlanDayModel>> fetchWorkoutDays() async {
    final data = await fetchWorkoutSchedule();
    return data.days;
  }
}
