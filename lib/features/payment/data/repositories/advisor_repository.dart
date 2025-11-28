import '../models/advisor_model.dart';
import '../services/advisor_service.dart';

class AdvisorRepository {
  final AdvisorService _service;

  AdvisorRepository(this._service);

  /// Lấy danh sách advisor khả dụng
  Future<List<AdvisorModel>> getAdvisors() {
    return _service.getAdvisors();
  }

  /// Gán advisor cho user (dùng trong PaymentResultScreen)
  Future<void> assignAdvisor({
    required String userId,
    required String advisorId,
  }) {
    return _service.assignAdvisorToUser(userId: userId, advisorId: advisorId);
  }
}
