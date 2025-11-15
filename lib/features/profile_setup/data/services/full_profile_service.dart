import 'package:fitai_mobile/core/api/api_client.dart';
import 'package:fitai_mobile/core/api/api_constants.dart';
import 'package:fitai_mobile/features/profile_setup/data/models/full_profile_request.dart';

class FullProfileService {
  final ApiClient _apiClient = ApiClient.account();

  /// PUT /api/user/full-profile
  Future<void> updateFullProfile(FullProfileRequest request) async {
    await _apiClient.put<void>(
      ApiConstants.fullProfile,
      data: request.toJson(),
    );
  }
}
