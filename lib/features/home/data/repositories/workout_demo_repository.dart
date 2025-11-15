import '../models/workout_demo_models.dart';
import '../services/workout_demo_service.dart';

class WorkoutDemoRepository {
  final WorkoutDemoService _service;
  WorkoutDemoRepository([WorkoutDemoService? service])
    : _service = service ?? WorkoutDemoService();

  Future<WorkoutDemoListResponse> fetch({
    int pageNumber = 1,
    int pageSize = 15,
    bool? isDeleted,
  }) {
    return _service.getWorkoutDemos(
      pageNumber: pageNumber,
      pageSize: pageSize,
      isDeleted: isDeleted,
    );
  }
}
