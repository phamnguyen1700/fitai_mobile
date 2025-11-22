// lib/features/daily/data/services/meal_comment_service.dart
import 'package:dio/dio.dart';
import 'package:fitai_mobile/core/api/api_client.dart';

class MealCommentService {
  final ApiClient _client;

  MealCommentService([ApiClient? client])
    : _client = client ?? ApiClient.fitness();

  /// GET /api/mealplan/meals/{mealLogId}/comments
  Future<Response<dynamic>> getComments(String mealLogId) {
    return _client.get<dynamic>('/mealplan/meals/$mealLogId/comments');
  }

  /// POST /api/mealplan/meals/{mealLogId}/add-comment
  /// body: { "content": "..." }
  Future<Response<dynamic>> addComment(
    String mealLogId,
    Map<String, dynamic> body,
  ) {
    return _client.post<dynamic>(
      '/mealplan/meals/$mealLogId/add-comment',
      data: body,
    );
  }

  /// DELETE /api/mealplan/comments/{mealLogId}/{commentId}
  Future<Response<dynamic>> deleteComment(String mealLogId, String commentId) {
    return _client.delete<dynamic>('/mealplan/comments/$mealLogId/$commentId');
  }
}
