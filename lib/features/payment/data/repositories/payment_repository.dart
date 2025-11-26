import '../models/payment_create_models.dart';
import '../models/subscription_product.dart';
import '../services/payment_service.dart';

class PaymentRepository {
  final PaymentService _service;

  PaymentRepository(this._service);

  /// Tạo Stripe Checkout Session cho gói đã chọn
  ///
  /// [userId], [email], [name]  : lấy từ user hiện tại
  /// [stripeCustomerId]        : có thì truyền, không có để null (BE tự xử lý)
  /// [plan]                    : SubscriptionProduct đã chọn (dùng plan.priceId)
  /// [successUrl], [cancelUrl] : deep link, ví dụ:
  ///   - fitaiplanning://payment/result/success
  ///   - fitaiplanning://payment/result/failed
  Future<PaymentCreateResponse> createPayment({
    required String userId,
    required String email,
    required String name,
    String? stripeCustomerId,
    required SubscriptionProduct plan,
    required String successUrl,
    required String cancelUrl,
  }) {
    final req = PaymentCreateRequest(
      userId: userId,
      email: email,
      name: name,
      stripeCustomerId: stripeCustomerId,
      stripePriceId: plan.priceId,
      successUrl: successUrl,
      cancelUrl: cancelUrl,
    );

    return _service.createPayment(req);
  }
}
