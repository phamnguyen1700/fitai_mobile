import 'package:fitai_mobile/core/api/api_client.dart';
import 'package:fitai_mobile/core/api/api_constants.dart';

import '../models/payment_create_models.dart';

class PaymentService {
  final ApiClient _client = ApiClient.account();

  Future<PaymentCreateResponse> createPayment(
    PaymentCreateRequest request,
  ) async {
    try {
      final res = await _client.post<Map<String, dynamic>>(
        ApiConstants.paymentCreate,
        data: request.toJson(),
      );

      final data = res.data;
      if (data == null) {
        throw Exception("Empty response từ server");
      }

      return PaymentCreateResponse.fromJson(data);
    } catch (e) {
      throw Exception("Không thể tạo payment session: $e");
    }
  }
}
