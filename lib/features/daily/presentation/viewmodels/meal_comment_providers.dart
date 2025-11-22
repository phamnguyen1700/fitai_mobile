// lib/features/daily/presentation/viewmodels/meal_comment_providers.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:fitai_mobile/features/daily/data/models/meal_comments_models.dart';
import 'package:fitai_mobile/features/daily/data/repositories/meal_comment_repository.dart';

part 'meal_comment_providers.g.dart';

/// Provider cho repository (dùng port fitness)
@riverpod
MealCommentRepository mealCommentRepository(MealCommentRepositoryRef ref) {
  return MealCommentRepository();
}

/// Controller dạng family theo mealLogId
///
/// Dùng được cho cả:
/// - load comments
/// - add comment
/// - delete comment
///
/// Cách dùng:
/// ```dart
/// final state = ref.watch(mealCommentsControllerProvider(mealLogId));
/// // state: AsyncValue<MealCommentsData>
/// ```
///
/// Gọi action:
/// ```dart
/// ref
///   .read(mealCommentsControllerProvider(mealLogId).notifier)
///   .addComment("Hello");
/// ```
@riverpod
class MealCommentsController extends _$MealCommentsController {
  /// mealLogId được truyền vào qua family
  late final String _mealLogId;

  @override
  Future<MealCommentsData> build(String mealLogId) async {
    _mealLogId = mealLogId;

    final repo = ref.read(mealCommentRepositoryProvider);
    return repo.getComments(mealLogId);
  }

  /// Thêm comment mới
  Future<void> addComment(String content) async {
    final repo = ref.read(mealCommentRepositoryProvider);

    // Giữ state cũ để UI không bị giật
    final previous = state.valueOrNull;

    state = const AsyncLoading();

    try {
      final data = await repo.addComment(
        mealLogId: _mealLogId,
        content: content,
      );
      state = AsyncData(data);
    } catch (e, st) {
      // nếu fail, trả lại state cũ + error
      if (previous != null) {
        state = AsyncError(e, st);
      } else {
        state = AsyncError(e, st);
      }
    }
  }

  /// Xoá comment theo id
  Future<void> deleteComment(String commentId) async {
    final repo = ref.read(mealCommentRepositoryProvider);
    final previous = state.valueOrNull;

    state = const AsyncLoading();

    try {
      final data = await repo.deleteComment(
        mealLogId: _mealLogId,
        commentId: commentId,
      );
      state = AsyncData(data);
    } catch (e, st) {
      if (previous != null) {
        state = AsyncError(e, st);
      } else {
        state = AsyncError(e, st);
      }
    }
  }
}
