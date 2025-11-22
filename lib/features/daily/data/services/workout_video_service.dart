import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fitai_mobile/core/api/api_client.dart';
import 'package:fitai_mobile/core/api/api_constants.dart';

class WorkoutVideoService {
  final ApiClient _client;

  WorkoutVideoService([ApiClient? client])
    : _client = client ?? ApiClient.fitness();

  /// POST /workoutplan/upload-video
  Future<Map<String, dynamic>> uploadVideo({
    required int dayNumber,
    required String exerciseId,
    required File video,
  }) async {
    final formData = FormData.fromMap({
      'DayNumber': dayNumber,
      'ExerciseId': exerciseId,
      'VideoFile': await MultipartFile.fromFile(
        video.path,
        filename: video.uri.pathSegments.last,
      ),
    });

    final res = await _client.post<Map<String, dynamic>>(
      ApiConstants.uploadWorkoutVideo,
      data: formData,
    );

    return res.data ?? {};
  }

  /// POST /workoutplan/mark-exercise-completed
  Future<void> markCompleted({
    required int dayNumber,
    required String exerciseId,
  }) async {
    await _client.post(
      ApiConstants.markExerciseCompleted,
      queryParameters: {'dayNumber': dayNumber, 'exerciseId': exerciseId},
    );
  }
}
