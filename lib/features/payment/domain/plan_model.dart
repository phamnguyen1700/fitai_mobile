import 'package:flutter/foundation.dart';

@immutable
class PlanModel {
  final String id; // ex: 'm1', 'm3', 'y1', 'life'
  final String name; // ex: 'Gói 3 tháng'
  final int? months; // null với Trọn đời
  final int price; // giá đã giảm (đơn vị: VND)
  final int? originalPrice; // giá gốc, null nếu không giảm
  final int? discount; // % giảm, null nếu không giảm
  final List<String> perks; // các quyền lợi hiển thị dạng bullet

  const PlanModel({
    required this.id,
    required this.name,
    required this.price,
    required this.perks,
    this.months,
    this.originalPrice,
    this.discount,
  });

  /// Tạo nhanh từ giá gốc + % giảm
  factory PlanModel.discounted({
    required String id,
    required String name,
    required int originalPrice,
    required int discountPercent,
    int? months,
    required List<String> perks,
  }) {
    final p = (originalPrice * (100 - discountPercent) / 100).round();
    return PlanModel(
      id: id,
      name: name,
      months: months,
      price: p,
      originalPrice: originalPrice,
      discount: discountPercent,
      perks: perks,
    );
  }
}
