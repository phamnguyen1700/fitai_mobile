import 'package:fitai_mobile/core/api/api_client.dart';
import 'package:fitai_mobile/core/api/api_constants.dart';
import 'package:fitai_mobile/features/profile_setup/data/models/full_profile_request.dart';

class FullProfileService {
  FullProfileService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient(); // singleton

  final ApiClient _apiClient;

  /// PUT /api/user/full-profile
  Future<void> updateFullProfile(FullProfileRequest request) async {
    await _apiClient.put<void>(
      ApiConstants.fullProfile,
      data: request.toJson(),
    );
  }
}
