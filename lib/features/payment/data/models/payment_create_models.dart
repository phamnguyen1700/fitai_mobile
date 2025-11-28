// lib/features/payment/data/models/payment_create_models.dart
import 'package:json_annotation/json_annotation.dart';

part 'payment_create_models.g.dart';

/// ======================================
/// 1. BODY gửi lên /api/payment/create
/// ======================================
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

/// ======================================
/// 2. RESPONSE trả về từ /api/payment/create
///
/// Ví dụ:
/// {
///   "sessionUrl": "https://checkout.stripe.com/...",
///   "clientSecret": null,
///   "customerId": "cus_TTnnQqVtu09qCA5"
/// }
/// ======================================
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

/// ======================================================
/// 3. BODY gửi lên /api/subscription/create-product
///
/// Ví dụ:
/// {
///   "name": "Premium Plan",
///   "description": "Access to AI workout and meal planning features",
///   "amount": 9.99,
///   "currency": "usd",
///   "interval": "month",
///   "isAdvisor": false
/// }
/// ======================================================
@JsonSerializable()
class SubscriptionProductCreateRequest {
  final String name;
  final String description;

  /// Số tiền, dùng num để nhận cả int/double từ BE
  final num amount;

  final String currency;
  final String interval;
  final bool isAdvisor;

  const SubscriptionProductCreateRequest({
    required this.name,
    required this.description,
    required this.amount,
    required this.currency,
    required this.interval,
    required this.isAdvisor,
  });

  factory SubscriptionProductCreateRequest.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionProductCreateRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SubscriptionProductCreateRequestToJson(this);
}

/// ======================================================
/// 4. RESPONSE success 200 từ /api/subscription/create-product
///
/// {
///   "success": true,
///   "message": "Product created successfully",
///   "data": {
///     "id": "64f8a3b2c1d2e3f4g5h6i7j8",
///     "productId": "prod_... ",
///     "priceId": "price_... ",
///     "name": "Premium Plan",
///     "description": "Access to AI workout and meal planning features",
///     "amount": 9.99,
///     "currency": "usd",
///     "interval": "month",
///     "isActive": true,
///     "isAdvisor": false
///   }
/// }
/// ======================================================
@JsonSerializable()
class SubscriptionProductCreateResponse {
  final bool success;
  final String message;
  final SubscriptionProductDto data;

  const SubscriptionProductCreateResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SubscriptionProductCreateResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionProductCreateResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SubscriptionProductCreateResponseToJson(this);
}

@JsonSerializable()
class SubscriptionProductDto {
  final String id;
  final String productId;
  final String priceId;
  final String name;
  final String description;

  /// Số tiền (có thể là int hoặc double từ BE)
  final num amount;

  final String currency;
  final String interval;
  final bool isActive;
  final bool isAdvisor;

  const SubscriptionProductDto({
    required this.id,
    required this.productId,
    required this.priceId,
    required this.name,
    required this.description,
    required this.amount,
    required this.currency,
    required this.interval,
    required this.isActive,
    required this.isAdvisor,
  });

  factory SubscriptionProductDto.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionProductDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionProductDtoToJson(this);
}

/// ======================================================
/// 5. RESPONSE error ví dụ:
/// {
///   "message": "Failed to create product in Stripe"
/// }
/// ======================================================
@JsonSerializable()
class ApiErrorResponse {
  final String message;

  const ApiErrorResponse({required this.message});

  factory ApiErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApiErrorResponseToJson(this);
}
