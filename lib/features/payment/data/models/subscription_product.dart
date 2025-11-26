import 'package:json_annotation/json_annotation.dart';

part 'subscription_product.g.dart';

enum BillingInterval {
  @JsonValue('day')
  day,
  @JsonValue('week')
  week,
  @JsonValue('month')
  month,
  @JsonValue('year')
  year,
}

@JsonSerializable(explicitToJson: true)
class SubscriptionProduct {
  final String productId;
  final String priceId;
  final String name;
  final String? description;
  final int amount;
  final String currency;
  final BillingInterval interval;
  final bool isActive;

  final bool isAdvisor; // ⭐ NEW FIELD thêm vào

  final DateTime? startDate;
  final DateTime? endDate;

  final String id;
  final DateTime? lastCreate;
  final DateTime? lastUpdate;

  const SubscriptionProduct({
    required this.productId,
    required this.priceId,
    required this.name,
    this.description,
    required this.amount,
    required this.currency,
    required this.interval,
    required this.isActive,

    required this.isAdvisor, // ⭐ Đưa vào constructor

    this.startDate,
    this.endDate,
    required this.id,
    this.lastCreate,
    this.lastUpdate,
  });

  factory SubscriptionProduct.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionProductFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionProductToJson(this);

  static List<SubscriptionProduct> listFromJson(dynamic data) {
    final list = (data as List).cast<Map<String, dynamic>>();
    return list.map(SubscriptionProduct.fromJson).toList();
  }
}
