import 'package:fitai_mobile/core/api/api_client.dart';
import 'package:fitai_mobile/core/api/api_constants.dart';

import '../models/payment_create_models.dart';

class PaymentService {
  final ApiClient _client = ApiClient.account();

  /// Gọi /api/payment/create để tạo Stripe Checkout Session
  Future<PaymentCreateResponse> createPayment(
    PaymentCreateRequest request,
  ) async {
    final res = await _client.post<Map<String, dynamic>>(
      ApiConstants.paymentCreate,
      data: request.toJson(),
    );

    // res.data là Map<String, dynamic>
    return PaymentCreateResponse.fromJson(res.data!);
  }
}
