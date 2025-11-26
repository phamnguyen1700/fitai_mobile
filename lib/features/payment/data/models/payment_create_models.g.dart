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
