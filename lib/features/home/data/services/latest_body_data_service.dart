// lib/features/home/data/services/body_data_service.dart

import 'package:dio/dio.dart';
import 'package:fitai_mobile/core/api/api_client.dart';
import 'package:fitai_mobile/core/api/api_constants.dart';
import 'package:fitai_mobile/features/home/data/models/latest_body_data.dart';

class BodyDataService {
  final ApiClient _client;

  BodyDataService([ApiClient? client])
    : _client = client ?? ApiClient.account();

  // ========== GET /bodydata/latest (raw) ==========
  Future<Response<dynamic>> getLatestBodyDataRaw() {
    return _client.get<dynamic>(ApiConstants.latestBodyData);
  }

  // ========== GET /bodydata/latest (typed) ==========
  /// Nếu user chưa có body data có thể trả về 204/null → nên cho nullable
  Future<LatestBodyDataModel?> getLatestBodyData() async {
    final res = await getLatestBodyDataRaw();

    if (res.data == null) return null;

    // Swagger trả thẳng object (không bọc "data")
    return LatestBodyDataModel.fromJson(res.data as Map<String, dynamic>);
  }
}
