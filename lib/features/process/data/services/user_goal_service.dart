// lib/features/process/data/services/user_goal_service.dart

import 'package:dio/dio.dart';
import 'package:fitai_mobile/core/api/api_client.dart';
import 'package:fitai_mobile/core/api/api_constants.dart';

class UserGoalService {
  final ApiClient _client;

  UserGoalService({ApiClient? client})
    : _client = client ?? ApiClient.account();

  /// PATCH /api/user/goal
  /// body: { "goal": "Weight_Gain" }
  Future<bool> updateUserGoal(String goalName) async {
    try {
      final Response res = await _client.patch(
        ApiConstants.goal, // đổi tên hằng theo file ApiConstants của bạn
        data: {'goal': goalName},
      );

      final root = res.data;
      if (root is Map<String, dynamic>) {
        return (root['success'] ?? false) == true;
      }
      // nếu backend không có field success thì coi như ok
      return true;
    } on DioException {
      rethrow;
    }
  }
}
