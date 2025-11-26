// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionProduct _$SubscriptionProductFromJson(Map<String, dynamic> json) =>
    SubscriptionProduct(
      productId: json['productId'] as String,
      priceId: json['priceId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      amount: (json['amount'] as num).toInt(),
      currency: json['currency'] as String,
      interval: $enumDecode(_$BillingIntervalEnumMap, json['interval']),
      isActive: json['isActive'] as bool,
      isAdvisor: json['isAdvisor'] as bool,
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      id: json['id'] as String,
      lastCreate: json['lastCreate'] == null
          ? null
          : DateTime.parse(json['lastCreate'] as String),
      lastUpdate: json['lastUpdate'] == null
          ? null
          : DateTime.parse(json['lastUpdate'] as String),
    );

Map<String, dynamic> _$SubscriptionProductToJson(
  SubscriptionProduct instance,
) => <String, dynamic>{
  'productId': instance.productId,
  'priceId': instance.priceId,
  'name': instance.name,
  'description': instance.description,
  'amount': instance.amount,
  'currency': instance.currency,
  'interval': _$BillingIntervalEnumMap[instance.interval]!,
  'isActive': instance.isActive,
  'isAdvisor': instance.isAdvisor,
  'startDate': instance.startDate?.toIso8601String(),
  'endDate': instance.endDate?.toIso8601String(),
  'id': instance.id,
  'lastCreate': instance.lastCreate?.toIso8601String(),
  'lastUpdate': instance.lastUpdate?.toIso8601String(),
};

const _$BillingIntervalEnumMap = {
  BillingInterval.day: 'day',
  BillingInterval.week: 'week',
  BillingInterval.month: 'month',
  BillingInterval.year: 'year',
};
