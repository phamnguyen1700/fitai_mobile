// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_create_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentCreateRequest _$PaymentCreateRequestFromJson(
  Map<String, dynamic> json,
) => PaymentCreateRequest(
  userId: json['userId'] as String,
  email: json['email'] as String,
  name: json['name'] as String,
  stripeCustomerId: json['stripeCustomerId'] as String?,
  stripePriceId: json['stripePriceId'] as String,
  successUrl: json['successUrl'] as String,
  cancelUrl: json['cancelUrl'] as String,
);

Map<String, dynamic> _$PaymentCreateRequestToJson(
  PaymentCreateRequest instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'email': instance.email,
  'name': instance.name,
  'stripeCustomerId': instance.stripeCustomerId,
  'stripePriceId': instance.stripePriceId,
  'successUrl': instance.successUrl,
  'cancelUrl': instance.cancelUrl,
};

PaymentCreateResponse _$PaymentCreateResponseFromJson(
  Map<String, dynamic> json,
) => PaymentCreateResponse(
  sessionUrl: json['sessionUrl'] as String,
  clientSecret: json['clientSecret'] as String?,
  customerId: json['customerId'] as String,
);

Map<String, dynamic> _$PaymentCreateResponseToJson(
  PaymentCreateResponse instance,
) => <String, dynamic>{
  'sessionUrl': instance.sessionUrl,
  'clientSecret': instance.clientSecret,
  'customerId': instance.customerId,
};

SubscriptionProductCreateRequest _$SubscriptionProductCreateRequestFromJson(
  Map<String, dynamic> json,
) => SubscriptionProductCreateRequest(
  name: json['name'] as String,
  description: json['description'] as String,
  amount: json['amount'] as num,
  currency: json['currency'] as String,
  interval: json['interval'] as String,
  isAdvisor: json['isAdvisor'] as bool,
);

Map<String, dynamic> _$SubscriptionProductCreateRequestToJson(
  SubscriptionProductCreateRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'amount': instance.amount,
  'currency': instance.currency,
  'interval': instance.interval,
  'isAdvisor': instance.isAdvisor,
};

SubscriptionProductCreateResponse _$SubscriptionProductCreateResponseFromJson(
  Map<String, dynamic> json,
) => SubscriptionProductCreateResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: SubscriptionProductDto.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SubscriptionProductCreateResponseToJson(
  SubscriptionProductCreateResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

SubscriptionProductDto _$SubscriptionProductDtoFromJson(
  Map<String, dynamic> json,
) => SubscriptionProductDto(
  id: json['id'] as String,
  productId: json['productId'] as String,
  priceId: json['priceId'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  amount: json['amount'] as num,
  currency: json['currency'] as String,
  interval: json['interval'] as String,
  isActive: json['isActive'] as bool,
  isAdvisor: json['isAdvisor'] as bool,
);

Map<String, dynamic> _$SubscriptionProductDtoToJson(
  SubscriptionProductDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'productId': instance.productId,
  'priceId': instance.priceId,
  'name': instance.name,
  'description': instance.description,
  'amount': instance.amount,
  'currency': instance.currency,
  'interval': instance.interval,
  'isActive': instance.isActive,
  'isAdvisor': instance.isAdvisor,
};

ApiErrorResponse _$ApiErrorResponseFromJson(Map<String, dynamic> json) =>
    ApiErrorResponse(message: json['message'] as String);

Map<String, dynamic> _$ApiErrorResponseToJson(ApiErrorResponse instance) =>
    <String, dynamic>{'message': instance.message};
