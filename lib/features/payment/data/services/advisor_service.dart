import 'package:fitai_mobile/core/api/api_client.dart';
import 'package:fitai_mobile/core/api/api_constants.dart';

import '../models/advisor_model.dart';
import '../models/advisor_assign_models.dart';

class AdvisorService {
  final ApiClient _client = ApiClient.account();

  /// GET /api/advisor
  /// Lấy danh sách advisor khả dụng
  Future<List<AdvisorModel>> getAdvisors() async {
    // IMPORTANT: dùng <dynamic> để Dio KHÔNG cố cast sang List
    final res = await _client.get<dynamic>(ApiConstants.advisorList);

    final root = res.data;
    // Debug nếu muốn:
    // print('advisor root type = ${root.runtimeType}');
    if (root is! Map<String, dynamic>) {
      return [];
    }

    final list = root['data'] as List<dynamic>? ?? <dynamic>[];
    return AdvisorModel.listFromJson(list);
  }

  /// POST /api/advisor/assign-advisor
  /// Gán advisor cho user
  Future<void> assignAdvisor(AdvisorAssignRequest request) async {
    await _client.post<void>(
      ApiConstants.advisorAssign,
      data: request.toJson(),
    );
  }

  /// Helper: gán nhanh từ userId + advisorId
  Future<void> assignAdvisorToUser({
    required String userId,
    required String advisorId,
  }) {
    final body = AdvisorAssignRequest(userId: userId, advisorId: advisorId);
    return assignAdvisor(body);
  }
}
