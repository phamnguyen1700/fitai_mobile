import 'package:dio/dio.dart';
import 'package:fitai_mobile/features/home/data/models/latest_body_data.dart';
import 'package:fitai_mobile/features/home/data/services/latest_body_data_service.dart';

class BodyDataRepository {
  final BodyDataService _service;

  BodyDataRepository([BodyDataService? service])
    : _service = service ?? BodyDataService();

  /// Lấy latest body data của current user.
  /// Trả về `null` nếu backend không có dữ liệu (204 / body null).
  Future<LatestBodyDataModel?> getLatestBodyData() async {
    try {
      final res = await _service.getLatestBodyDataRaw();

      // Không có body data
      if (res.statusCode == 204 || res.data == null) {
        return null;
      }

      if (res.statusCode == 200) {
        final root = res.data;

        if (root is Map<String, dynamic>) {
          // Case 1: backend bọc trong "data"
          final inner = root['data'];
          if (inner is Map<String, dynamic>) {
            return LatestBodyDataModel.fromJson(inner);
          }

          // Case 2: backend trả thẳng object (giống JSON bạn gửi)
          return LatestBodyDataModel.fromJson(root);
        }

        // Dữ liệu không đúng format
        throw Exception('Dữ liệu body không hợp lệ, vui lòng thử lại sau.');
      }

      throw Exception('Không lấy được dữ liệu body, vui lòng thử lại sau.');
    } on DioException catch (e) {
      final serverMsg = _extractServerMessage(e);
      throw Exception(serverMsg ?? 'Đã xảy ra lỗi, vui lòng thử lại sau.');
    } catch (_) {
      throw Exception('Đã xảy ra lỗi, vui lòng thử lại sau.');
    }
  }

  String? _extractServerMessage(DioException e) {
    try {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        final msg = data['message'] ?? data['error'] ?? data['title'];
        if (msg is String) return msg;
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
