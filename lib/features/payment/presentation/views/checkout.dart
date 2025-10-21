import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../viewmodels/payment_state.dart';

class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(paymentProvider);
    final notifier = ref.read(paymentProvider.notifier);
    final plan = state.selectedPlan;

    if (plan == null) {
      return const AppScaffold(
        title: 'Thanh toán',
        body: Center(child: Text('Vui lòng chọn gói trước.')),
      );
    }

    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    Widget summaryRow(String k, String v, {Color? color, FontWeight? w}) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(k, style: t.bodyMedium),
          Text(
            v,
            style: t.bodyMedium?.copyWith(color: color, fontWeight: w),
          ),
        ],
      );
    }

    return AppScaffold(
      title: 'Thanh toán',
      showBack: true,
      showLegalFooter: true,
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // Card tóm tắt giống Figma
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Thanh toán',
                      style: t.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  summaryRow(
                    'Gói đã chọn',
                    plan.name,
                    color: Colors.green,
                    w: FontWeight.w700,
                  ),
                  const SizedBox(height: 6),
                  summaryRow(
                    'Giá gốc',
                    '${_vnd(plan.price)}đ',
                    color: Colors.red,
                  ),
                  summaryRow(
                    'Ưu đãi',
                    plan.discount != null ? '-${plan.discount}%' : '0%',
                  ),
                  const Divider(height: 24),
                  summaryRow(
                    'Thành tiền',
                    '${_vnd(plan.price)}đ',
                    color: Colors.red,
                    w: FontWeight.w800,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'Phương thức thanh toán',
            style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          _methodTile(
            context,
            'PayPal',
            'paypal',
            state.selectedMethodId == 'paypal',
            onTap: () => notifier.selectMethod('paypal'),
          ),
          _methodTile(
            context,
            'Thanh toán bằng thẻ visa',
            'visa',
            state.selectedMethodId == 'visa',
            onTap: () => notifier.selectMethod('visa'),
          ),
          _methodTile(
            context,
            'Thanh toán bằng momo',
            'momo',
            state.selectedMethodId == 'momo',
            onTap: () => notifier.selectMethod('momo'),
          ),
          const SizedBox(height: 12),

          // Form thẻ khi chọn visa
          if (state.selectedMethodId == 'visa') ...[
            _input(context, hint: 'Nhập số thẻ'),
            _input(context, hint: 'Nhập tên chủ thẻ'),
            _input(
              context,
              hint: 'Ngày hết hạn',
              icon: Icons.calendar_month_rounded,
            ),
            const SizedBox(height: 4),
          ],

          const SizedBox(height: 8),
          SizedBox(
            height: 48,
            child: FilledButton(
              onPressed: () => context.push('/payment/processing'),
              child: const Text('Xác nhận thanh toán'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _methodTile(
    BuildContext ctx,
    String title,
    String id,
    bool selected, {
    VoidCallback? onTap,
  }) {
    final cs = Theme.of(ctx).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? cs.primaryContainer.withOpacity(.5) : cs.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? cs.primary : cs.outlineVariant),
        ),
        child: Row(
          children: [
            const Icon(Icons.credit_card_rounded),
            const SizedBox(width: 10),
            Expanded(child: Text(title)),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: cs.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _input(BuildContext ctx, {required String hint, IconData? icon}) {
    final cs = Theme.of(ctx).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          icon: icon == null ? null : Icon(icon),
        ),
      ),
    );
  }

  String _vnd(int n) =>
      '${n.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
}
