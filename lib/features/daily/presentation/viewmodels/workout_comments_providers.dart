// lib/features/daily/presentation/viewmodels/workout_comments_providers.dart

import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:fitai_mobile/features/daily/data/models/workout_comments_models.dart';
import 'package:fitai_mobile/features/daily/data/repositories/workout_comments_repository.dart';

part 'workout_comments_providers.g.dart';

/// Repository provider
@riverpod
WorkoutCommentRepository workoutCommentRepository(
  WorkoutCommentRepositoryRef ref,
) {
  return WorkoutCommentRepository();
}

/// Controller dạng family theo exerciseLogId
///
/// Dùng được cho:
/// - load comments
/// - add comment
/// - delete comment
@riverpod
class WorkoutCommentsController extends _$WorkoutCommentsController {
  late final String _exerciseLogId;

  @override
  Future<WorkoutExerciseCommentsData> build(String exerciseLogId) async {
    _exerciseLogId = exerciseLogId;

    final repo = ref.read(workoutCommentRepositoryProvider);

    if (exerciseLogId.isEmpty) {
      // nếu logId rỗng thì trả về object trống
      return WorkoutExerciseCommentsData(
        exerciseLogId: '',
        exerciseName: '',
        comments: const [],
      );
    }

    // gọi API load danh sách ban đầu
    return repo.getComments(exerciseLogId);
  }

  /// Thêm comment
  Future<void> addComment(String content) async {
    final repo = ref.read(workoutCommentRepositoryProvider);

    state = const AsyncLoading();

    try {
      // 🔹 API trả về WorkoutCommentPostData
      final postData = await repo.addComment(
        exerciseLogId: _exerciseLogId,
        content: content,
      );

      // 🔹 Convert về WorkoutExerciseCommentsData (kiểu mà controller quản lý)
      final refreshed = WorkoutExerciseCommentsData(
        exerciseLogId: postData.exerciseLogId,
        exerciseName: postData.exerciseName,
        comments: postData.comments,
      );

      state = AsyncData(refreshed);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// Xoá comment
  Future<void> deleteComment(String commentId) async {
    final repo = ref.read(workoutCommentRepositoryProvider);

    state = const AsyncLoading();

    try {
      // 🔹 Repo đã trả về WorkoutExerciseCommentsData rồi
      final refreshed = await repo.deleteComment(
        exerciseLogId: _exerciseLogId,
        commentId: commentId,
      );

      state = AsyncData(refreshed);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
