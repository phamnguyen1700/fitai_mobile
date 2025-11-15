import 'package:fitai_mobile/core/api/api_client.dart';
import 'package:fitai_mobile/core/api/api_constants.dart';
import '../models/dietary_preference_request.dart';

class DietaryPreferenceService {
  final ApiClient _apiClient = ApiClient.account();

  Future<void> createOrUpdate(DietaryPreferenceRequest request) async {
    await _apiClient.post(
      ApiConstants.dietaryPreference,
      data: request.toJson(),
    );
  }
}
