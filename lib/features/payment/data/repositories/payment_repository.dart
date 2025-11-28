// lib/features/payment/data/repositories/payment_repository.dart
import '../models/payment_create_models.dart';
import '../models/subscription_product.dart';
import '../services/payment_service.dart';

class PaymentRepository {
  final PaymentService _service;

  /// Cho phép truyền service từ ngoài (test/mock), nếu không truyền thì dùng default
  PaymentRepository([PaymentService? service])
    : _service = service ?? PaymentService();

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
    // Nếu BE định nghĩa priceId là String? trong SubscriptionProduct
    final priceId = plan.priceId;
    if (priceId == null || priceId.isEmpty) {
      throw Exception(
        'Gói "${plan.name}" chưa được cấu hình priceId Stripe. Vui lòng liên hệ admin.',
      );
    }

    final req = PaymentCreateRequest(
      userId: userId,
      email: email,
      name: name,
      stripeCustomerId: stripeCustomerId,
      stripePriceId: priceId, // giờ chắc chắn là String non-null
      successUrl: successUrl,
      cancelUrl: cancelUrl,
    );

    return _service.createPayment(req);
  }
}
