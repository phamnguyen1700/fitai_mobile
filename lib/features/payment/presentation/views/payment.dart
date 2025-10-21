import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../viewmodels/payment_state.dart';
import '../widgets/plan_grid_cell.dart';

// lib/features/payment/presentation/views/payment.dart
class PaymentScreen extends ConsumerWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(paymentProvider.notifier);
    final state = ref.watch(paymentProvider);
    final plans = notifier.plans; // data giả đã có trong notifier

    return AppScaffold(
      title: 'Nâng cấp gói Premium',
      showBack: true,
      showLegalFooter: true,
      body: body: ListView(
  padding: const EdgeInsets.all(12),
  children: [
    // ⚠️ Canh GIỮA + giới hạn maxWidth cho panel
    Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420), // tùy: 400–480
        child: Card(
          elevation: 1,
          child: Padding(
            const EdgeInsets.fromLTRB(16, 18, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.workspace_premium_rounded,
                    size: 40, color: Colors.orange),
                const SizedBox(height: 8),
                Text(
                  'Mở khoá toàn bộ kế hoạch cá nhân',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  'Chọn gói phù hợp để bắt đầu hành trình tập luyện & dinh dưỡng 30 ngày.',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.78,
                  ),
                  itemCount: plans.length,
                  itemBuilder: (context, i) {
                    final p = plans[i];
                    final selected = state.selectedPlan?.id == p.id;
                    return PlanGridCell(
                      plan: p,
                      selected: selected,
                      onSelect: () => notifier.selectPlan(p),
                      onChoose: () {
                        notifier.selectPlan(p);
                        context.push('/payment/checkout');
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    ),

    const SizedBox(height: 24),
  ],
),
    );
  }
}
