import '../models/activity_level_metadata.dart';
import '../services/metadata_api_service.dart';

class ActivityLevelRepository {
  final MetadataApiService _service;

  ActivityLevelRepository({MetadataApiService? service})
    : _service = service ?? MetadataApiService();

  Future<List<ActivityLevelMetadata>> getActivityLevels() {
    return _service.getActivityLevels();
  }
}
