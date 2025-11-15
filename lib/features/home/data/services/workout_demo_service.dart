import 'package:dio/dio.dart';
import 'package:fitai_mobile/core/api/api_client.dart';
import 'package:fitai_mobile/core/api/api_constants.dart';
import '../models/workout_demo_models.dart';

class WorkoutDemoService {
  final ApiClient _client;
  WorkoutDemoService([ApiClient? client])
    : _client = client ?? ApiClient.fitness();

  Future<WorkoutDemoListResponse> getWorkoutDemos({
    int pageNumber = 1,
    int pageSize = 15,
    bool? isDeleted,
  }) async {
    final Response res = await _client.get(
      ApiConstants.workoutDemo,
      queryParameters: {
        'pageNumber': pageNumber,
        'pageSize': pageSize,
        if (isDeleted != null) 'isDeleted': isDeleted,
      },
    );

    return WorkoutDemoListResponse.fromJson(res.data as Map<String, dynamic>);
  }
}
