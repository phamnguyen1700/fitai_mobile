import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:fitai_mobile/features/auth/data/models/user_model.dart';
import 'package:fitai_mobile/features/payment/presentation/viewmodels/payment_provider.dart';
import '../../data/models/subscription_product.dart';
import '../../data/models/payment_create_models.dart';

part 'payment_controller.g.dart';

@riverpod
class PaymentController extends _$PaymentController {
  @override
  Future<void> build() async {
    // Không cần làm gì khi init, chỉ để có AsyncNotifier<void>
  }

  Future<PaymentCreateResponse?> createPaymentSession(
    SubscriptionProduct plan,
    UserModel user,
  ) async {
    final repo = ref.read(paymentProvider);

    state = const AsyncValue.loading();

    try {
      // DEBUG
      print('[PaymentController] creating payment for plan: ${plan.name}');
      print('[PaymentController] userId = ${user.id}, email = ${user.email}');

      final result = await repo.createPayment(
        userId: user.id,
        email: user.email,
        name: "${user.firstName ?? ''} ${user.lastName ?? ''}".trim(),
        stripeCustomerId: null,
        plan: plan,
        successUrl: "fitaiplanning://payment/result/success",
        cancelUrl: "fitaiplanning://payment/result/failed",
      );

      print('[PaymentController] sessionUrl = ${result.sessionUrl}');

      state = const AsyncValue.data(null);
      return result;
    } catch (e, st) {
      print('[PaymentController] error: $e');
      state = AsyncValue.error(e, st);
      return null;
    }
  }
}
