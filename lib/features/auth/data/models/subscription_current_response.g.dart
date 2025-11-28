// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_current_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionCurrentResponse _$SubscriptionCurrentResponseFromJson(
  Map<String, dynamic> json,
) => SubscriptionCurrentResponse(
  success: json['success'] as bool,
  data: json['data'] == null
      ? null
      : SubscriptionData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SubscriptionCurrentResponseToJson(
  SubscriptionCurrentResponse instance,
) => <String, dynamic>{'success': instance.success, 'data': instance.data};

SubscriptionData _$SubscriptionDataFromJson(Map<String, dynamic> json) =>
    SubscriptionData(
      userId: json['userId'] as String,
      subscriptionProductId: json['subscriptionProductId'] as String,
      tierType: json['tierType'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      isActive: json['isActive'] as bool,
      cancelledAt: json['cancelledAt'] as String?,
      stripeSubscriptionId: json['stripeSubscriptionId'] as String?,
      stripePriceId: json['stripePriceId'] as String,
      price: json['price'] as num,
      currency: json['currency'] as String,
      autoRenew: json['autoRenew'] as bool,
      id: json['id'] as String,
      lastCreate: DateTime.parse(json['lastCreate'] as String),
      lastUpdate: DateTime.parse(json['lastUpdate'] as String),
    );

Map<String, dynamic> _$SubscriptionDataToJson(SubscriptionData instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'subscriptionProductId': instance.subscriptionProductId,
      'tierType': instance.tierType,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'isActive': instance.isActive,
      'cancelledAt': instance.cancelledAt,
      'stripeSubscriptionId': instance.stripeSubscriptionId,
      'stripePriceId': instance.stripePriceId,
      'price': instance.price,
      'currency': instance.currency,
      'autoRenew': instance.autoRenew,
      'id': instance.id,
      'lastCreate': instance.lastCreate.toIso8601String(),
      'lastUpdate': instance.lastUpdate.toIso8601String(),
    };
