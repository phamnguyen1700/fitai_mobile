import 'package:dio/dio.dart';
import 'package:fitai_mobile/core/api/api_client.dart';
import 'package:fitai_mobile/core/api/api_constants.dart';

import '../models/activity_level_metadata.dart';

class MetadataApiService {
  final ApiClient _apiClient = ApiClient();

  Future<List<ActivityLevelMetadata>> getActivityLevels() async {
    try {
      final response = await _apiClient.get<List<dynamic>>(
        ApiConstants.activityLevels,
      );

      if (response.statusCode == 200 && response.data != null) {
        final rawList = response.data!;
        return rawList
            .map(
              (e) => ActivityLevelMetadata.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw Exception('Get activity levels failed: Invalid response');
      }
    } on DioException catch (e) {
      throw Exception(
        'Get activity levels failed: ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      throw Exception('Get activity levels failed: $e');
    }
  }
}
