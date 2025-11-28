// lib/features/payment/data/repositories/subscription_repository.dart
import 'package:dio/dio.dart';
import '../models/subscription_product.dart';
import '../services/subscription_service.dart';

class SubscriptionRepository {
  final SubscriptionService _service;
  SubscriptionRepository([SubscriptionService? service])
    : _service = service ?? SubscriptionService();

  Future<List<SubscriptionProduct>> getActiveProducts() async {
    try {
      final res = await _service.getActiveProductsRaw();

      if (res.statusCode == 200 && res.data != null) {
        final data = res.data;

        // Case 1: backend trả về mảng trực tiếp (đúng với log hiện tại)
        if (data is List) {
          return SubscriptionProduct.listFromJson(data);
        }

        // Case 2: đề phòng sau này backend bọc thêm { data: [...] }
        if (data is Map<String, dynamic> && data['data'] is List) {
          return SubscriptionProduct.listFromJson(data['data']);
        }

        throw Exception(
          'Định dạng dữ liệu không hợp lệ từ /subscription/active-products.',
        );
      }

      throw Exception('Không lấy được danh sách gói, vui lòng thử lại sau.');
    } on DioException catch (e) {
      final serverMsg = _extractServerMessage(e);
      throw Exception(serverMsg ?? 'Đã xảy ra lỗi, vui lòng thử lại sau.');
    } catch (e) {
      throw Exception('Đã xảy ra lỗi, vui lòng thử lại sau.');
    }
  }

  String? _extractServerMessage(DioException e) {
    try {
      final data = e.response?.data;
      if (data is Map &&
          data['message'] is String &&
          (data['message'] as String).isNotEmpty) {
        return data['message'] as String;
      }
    } catch (_) {}
    return null;
  }
}
