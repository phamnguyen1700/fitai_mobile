// lib/features/daily/data/services/workout_comment_service.dart

import 'package:dio/dio.dart';
import 'package:fitai_mobile/core/api/api_client.dart';

class WorkoutCommentService {
  final ApiClient _client;

  WorkoutCommentService([ApiClient? client])
    : _client = client ?? ApiClient.fitness();

  /// ==========================
  /// POST: Add comment
  /// ==========================
  Future<Response<dynamic>> addComment(
    String exerciseLogId,
    Map<String, dynamic> body,
  ) {
    return _client.post<dynamic>(
      '/workoutplan/exercises/$exerciseLogId/add-comment',
      data: body,
    );
  }

  /// ==========================
  /// GET: Get all comments
  /// ==========================
  Future<Response<dynamic>> getComments(String exerciseLogId) {
    return _client.get<dynamic>(
      '/workoutplan/exercises/$exerciseLogId/comments',
    );
  }

  /// ==========================
  /// DELETE: Delete comment
  /// ==========================
  Future<Response<dynamic>> deleteComment(
    String exerciseLogId,
    String commentId,
  ) {
    return _client.delete<dynamic>(
      '/workoutplan/comments/$exerciseLogId/$commentId',
    );
  }
}
