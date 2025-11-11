import 'package:fitai_mobile/features/profile_setup/data/models/full_profile_request.dart';
import 'package:fitai_mobile/features/profile_setup/data/services/full_profile_service.dart';

class FullProfileRepository {
  FullProfileRepository({FullProfileService? service})
    : _service = service ?? FullProfileService();

  final FullProfileService _service;

  Future<void> updateFullProfile(FullProfileRequest request) {
    return _service.updateFullProfile(request);
  }
}
