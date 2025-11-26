import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:fitai_mobile/features/auth/presentation/viewmodels/auth_providers.dart';
import 'package:fitai_mobile/features/payment/presentation/viewmodels/payment_provider.dart';
import '../../data/models/subscription_product.dart';
import '../../data/models/payment_create_models.dart';

part 'payment_controller.g.dart';

@riverpod
class PaymentController extends _$PaymentController {
  @override
  Future<void> build() async {}

  Future<PaymentCreateResponse?> createPaymentSession(
    SubscriptionProduct plan,
  ) async {
    final repo = ref.read(paymentProvider);
    final user = ref.read(currentUserProvider);

    if (user == null) {
      state = AsyncValue.error("Người dùng chưa đăng nhập", StackTrace.current);
      return null;
    }

    state = const AsyncValue.loading();

    try {
      // DEBUG: in ra cho chắc nó chạy tới đây
      // ignore: avoid_print
      print('[PaymentController] creating payment for plan: ${plan.name}');

      final result = await repo.createPayment(
        userId: user.id, // nếu id nullable
        email: user.email, // tránh null
        name: "${user.firstName ?? ''} ${user.lastName ?? ''}".trim(),
        stripeCustomerId: "", // cho null nếu chưa có
        plan: plan,
        successUrl: "fitaiplanning://payment/result/success",
        cancelUrl: "fitaiplanning://payment/result/failed",
      );

      // DEBUG: in ra sessionUrl
      // ignore: avoid_print
      print('[PaymentController] sessionUrl = ${result.sessionUrl}');

      state = const AsyncValue.data(true);
      return result;
    } catch (e, st) {
      // ignore: avoid_print
      print('[PaymentController] error: $e');
      state = AsyncValue.error(e, st);
      return null;
    }
  }
}
