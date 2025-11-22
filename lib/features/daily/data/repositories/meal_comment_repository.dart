// lib/features/daily/data/repositories/meal_comment_repository.dart

import 'package:fitai_mobile/features/daily/data/models/meal_comments_models.dart';
import 'package:fitai_mobile/features/daily/data/services/meal_comment_service.dart';

class MealCommentRepository {
  final MealCommentService _service;

  MealCommentRepository([MealCommentService? service])
    : _service = service ?? MealCommentService();

  /// Lấy toàn bộ comment của 1 meal log
  /// GET /api/mealplan/meals/{mealLogId}/comments
  Future<MealCommentsData> getComments(String mealLogId) async {
    final res = await _service.getComments(mealLogId);
    final parsed = MealCommentsResponse.fromJson(
      res.data as Map<String, dynamic>,
    );
    return parsed.data; // chứa mealLogId, mealType, dayNumber, comments
  }

  /// Thêm comment mới, trả về list comments đã cập nhật
  /// POST /api/mealplan/meals/{mealLogId}/add-comment
  Future<MealCommentsData> addComment({
    required String mealLogId,
    required String content,
  }) async {
    final body = <String, dynamic>{'content': content};

    final res = await _service.addComment(mealLogId, body);
    final parsed = MealCommentsResponse.fromJson(
      res.data as Map<String, dynamic>,
    );
    return parsed.data;
  }

  /// Xoá comment, trả về list comments đã cập nhật
  /// DELETE /api/mealplan/comments/{mealLogId}/{commentId}
  Future<MealCommentsData> deleteComment({
    required String mealLogId,
    required String commentId,
  }) async {
    final res = await _service.deleteComment(mealLogId, commentId);
    final parsed = MealCommentsResponse.fromJson(
      res.data as Map<String, dynamic>,
    );
    return parsed.data;
  }
}
