import 'package:json_annotation/json_annotation.dart';

part 'subscription_current_response.g.dart';

@JsonSerializable()
class SubscriptionCurrentResponse {
  final bool success;
  final SubscriptionData? data;

  SubscriptionCurrentResponse({required this.success, this.data});

  factory SubscriptionCurrentResponse.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionCurrentResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionCurrentResponseToJson(this);
}

@JsonSerializable()
class SubscriptionData {
  final String userId;
  final String subscriptionProductId;
  final String tierType;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final String? cancelledAt;
  final String? stripeSubscriptionId;
  final String stripePriceId;
  final num price;
  final String currency;
  final bool autoRenew;
  final String id;
  final DateTime lastCreate;
  final DateTime lastUpdate;

  SubscriptionData({
    required this.userId,
    required this.subscriptionProductId,
    required this.tierType,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    this.cancelledAt,
    this.stripeSubscriptionId,
    required this.stripePriceId,
    required this.price,
    required this.currency,
    required this.autoRenew,
    required this.id,
    required this.lastCreate,
    required this.lastUpdate,
  });

  factory SubscriptionData.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionDataFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionDataToJson(this);
}
