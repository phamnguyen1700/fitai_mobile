import '../models/dietary_preference_request.dart';
import '../services/dietary_preference_service.dart';

class DietaryPreferenceRepository {
  final DietaryPreferenceService _service = DietaryPreferenceService();

  Future<void> save(DietaryPreferenceRequest request) async {
    await _service.createOrUpdate(request);
  }
}
