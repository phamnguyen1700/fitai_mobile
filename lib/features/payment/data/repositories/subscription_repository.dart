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
        return SubscriptionProduct.listFromJson(res.data);
      }
      throw Exception('Không lấy được danh sách gói, vui lòng thử lại sau.');
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
      if (data is Map &&
          data['message'] is String &&
          (data['message'] as String).isNotEmpty) {
        return data['message'] as String;
      }
    } catch (_) {}
    return null;
  }
}
