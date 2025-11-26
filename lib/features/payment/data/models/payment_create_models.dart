// lib/features/payment/data/models/payment_create_models.dart
import 'package:json_annotation/json_annotation.dart';

part 'payment_create_models.g.dart';

/// BODY gửi lên /api/payment/create
@JsonSerializable()
class PaymentCreateRequest {
  final String userId;
  final String email;
  final String name;

  /// Có thể null nếu BE tự tạo customer Stripe lần đầu
  final String? stripeCustomerId;

  /// price_xxx trong Stripe
  final String stripePriceId;

  /// Deep link hoặc web url
  final String successUrl;
  final String cancelUrl;

  const PaymentCreateRequest({
    required this.userId,
    required this.email,
    required this.name,
    this.stripeCustomerId,
    required this.stripePriceId,
    required this.successUrl,
    required this.cancelUrl,
  });

  factory PaymentCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$PaymentCreateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentCreateRequestToJson(this);
}

/// RESPONSE trả về từ /api/payment/create
///
/// Ví dụ:
/// {
///   "sessionUrl": "https://checkout.stripe.com/...",
///   "clientSecret": null,
///   "customerId": "cus_TTnnQqVtu09qCA5"
/// }
@JsonSerializable()
class PaymentCreateResponse {
  final String sessionUrl;
  final String? clientSecret;
  final String customerId;

  const PaymentCreateResponse({
    required this.sessionUrl,
    required this.clientSecret,
    required this.customerId,
  });

  factory PaymentCreateResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentCreateResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentCreateResponseToJson(this);
}
