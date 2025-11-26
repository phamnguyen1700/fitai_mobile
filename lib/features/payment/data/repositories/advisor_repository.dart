import 'package:fitai_mobile/features/payment/data/models/advisor_model.dart';
import 'package:fitai_mobile/features/payment/data/models/advisor_assign_models.dart';
import 'package:fitai_mobile/features/payment/data/services/advisor_service.dart';

class AdvisorRepository {
  final AdvisorService _service;

  AdvisorRepository(this._service);

  /// Lấy danh sách advisor từ API
  Future<List<AdvisorModel>> getAdvisors() {
    return _service.getAdvisors();
  }

  /// Gán advisor cho user
  Future<void> assignAdvisor({
    required String userId,
    required String advisorId,
  }) async {
    return _service.assignAdvisorToUser(userId: userId, advisorId: advisorId);
  }

  /// Gán advisor với request model
  Future<void> assignAdvisorRequest(AdvisorAssignRequest request) async {
    return _service.assignAdvisor(request);
  }
}
