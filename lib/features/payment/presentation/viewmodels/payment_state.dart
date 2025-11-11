import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../payment/domain/plan_model.dart';

@immutable
class PaymentState {
  final List<PlanModel> plans;
  final PlanModel? selectedPlan;
  final String? selectedMethodId; // 'paypal' | 'visa' | 'momo'

  const PaymentState({
    required this.plans,
    this.selectedPlan,
    this.selectedMethodId,
  });

  PaymentState copyWith({
    List<PlanModel>? plans,
    PlanModel? selectedPlan,
    String? selectedMethodId,
  }) {
    return PaymentState(
      plans: plans ?? this.plans,
      selectedPlan: selectedPlan ?? this.selectedPlan,
      selectedMethodId: selectedMethodId ?? this.selectedMethodId,
    );
  }
}

class PaymentNotifier extends StateNotifier<PaymentState> {
  PaymentNotifier() : super(PaymentState(plans: _fakePlans));

  static final _fakePlans = <PlanModel>[
    PlanModel(
      id: 'm1',
      name: 'Gói 1 tháng',
      months: 1,
      price: 199000,
      perks: const ['Toàn bộ Workout', '30 ngày Meal', 'Video HD'],
    ),
    PlanModel.discounted(
      id: 'm3',
      name: 'Gói 3 tháng',
      months: 3,
      originalPrice: 499000,
      discountPercent: 15,
      perks: const ['Tất cả gói 1T', 'Ưu đãi 15%', 'Tư vấn online'],
    ),
    PlanModel.discounted(
      id: 'y1',
      name: 'Gói 12 tháng',
      months: 12,
      originalPrice: 1499000,
      discountPercent: 35,
      perks: const ['Ưu đãi 35%', 'Ưu tiên', 'Hỗ trợ 24/7'],
    ),
    const PlanModel(
      id: 'life',
      name: 'Trọn đời',
      months: null,
      price: 5000000,
      perks: ['All features', 'One-time pay', 'Lifetime free'],
    ),
  ];

  List<PlanModel> get plans => state.plans;

  void selectPlan(PlanModel p) => state = state.copyWith(selectedPlan: p);

  void selectMethod(String methodId) =>
      state = state.copyWith(selectedMethodId: methodId);
}

// Riverpod provider
final paymentProvider = StateNotifierProvider<PaymentNotifier, PaymentState>((
  ref,
) {
  return PaymentNotifier();
});
