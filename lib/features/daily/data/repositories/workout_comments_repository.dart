import 'package:dio/dio.dart';
import 'package:fitai_mobile/features/daily/data/models/workout_comments_models.dart';
import 'package:fitai_mobile/features/daily/data/services/workout_comments_services.dart';

class WorkoutCommentRepository {
  final WorkoutCommentService _service;

  WorkoutCommentRepository([WorkoutCommentService? service])
    : _service = service ?? WorkoutCommentService();

  /// ==========================
  /// POST: Add comment to exercise
  /// ==========================
  ///
  /// Trả về `WorkoutCommentPostData` (data sau khi add thành công)
  Future<WorkoutCommentPostData> addComment({
    required String exerciseLogId,
    required String content,
  }) async {
    try {
      final body = AddWorkoutCommentRequest(content: content).toJson();

      final Response resp = await _service.addComment(exerciseLogId, body);

      final json = resp.data as Map<String, dynamic>;
      final parsed = WorkoutCommentPostResponse.fromJson(json);

      if (!parsed.success) {
        throw Exception(parsed.message);
      }

      return parsed.data;
    } on DioException catch (e) {
      // Có thể custom error handling theo style project của bạn
      rethrow;
    }
  }

  /// ==========================
  /// GET: Get all comments for an exercise
  /// ==========================
  ///
  /// Trả về `WorkoutExerciseCommentsData`
  Future<WorkoutExerciseCommentsData> getComments(String exerciseLogId) async {
    try {
      final Response resp = await _service.getComments(exerciseLogId);

      final json = resp.data as Map<String, dynamic>;
      final parsed = WorkoutCommentGetResponse.fromJson(json);

      if (!parsed.success) {
        throw Exception(parsed.message);
      }

      return parsed.data;
    } on DioException catch (e) {
      rethrow;
    }
  }

  /// ==========================
  /// DELETE: Delete a comment
  /// ==========================
  ///
  /// Trả về `WorkoutExerciseCommentsData` (comments sau khi xoá – thường là list đã remove comment)
  Future<WorkoutExerciseCommentsData> deleteComment({
    required String exerciseLogId,
    required String commentId,
  }) async {
    try {
      final Response resp = await _service.deleteComment(
        exerciseLogId,
        commentId,
      );

      final json = resp.data as Map<String, dynamic>;
      final parsed = WorkoutCommentDeleteResponse.fromJson(json);

      if (!parsed.success) {
        throw Exception(parsed.message);
      }

      return parsed.data;
    } on DioException catch (e) {
      rethrow;
    }
  }
}
