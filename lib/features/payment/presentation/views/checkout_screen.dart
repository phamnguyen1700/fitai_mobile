// lib/features/payment/presentation/views/checkout_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../viewmodels/subscriptions_provider.dart';

class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});
  static const _imgPath = 'lib/core/assets/images';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(subscriptionsProvider);
    final plan = state.selectedProduct;
    final notifier = ref.read(subscriptionsProvider.notifier);

    if (plan == null) {
      return const AppScaffold(
        appBar: AppAppBar(title: 'Thanh toán'),
        body: Center(child: Text('Vui lòng chọn gói trước.')),
      );
    }

    final t = Theme.of(context).textTheme;

    Widget rowKV(String k, String v, {Color? vColor, FontWeight? vWeight}) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(k, style: t.bodyMedium),
          Text(
            v,
            style: t.bodyMedium?.copyWith(color: vColor, fontWeight: vWeight),
          ),
        ],
      );
    }

    return AppScaffold(
      showLegalFooter: true,
      appBar: const AppAppBar(title: 'Thanh toán'),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 1,
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

                  // Tóm tắt đơn
                  rowKV(
                    'Gói đã chọn',
                    plan.name,
                    vColor: Colors.green,
                    vWeight: FontWeight.w700,
                  ),
                  const SizedBox(height: 4),
                  rowKV(
                    'Giá gốc',
                    _money(plan.amount, plan.currency),
                    vColor: Colors.red,
                  ),
                  rowKV('Ưu đãi', '0%'), // nếu chưa có discount, hiển thị 0%
                  const Divider(height: 28),
                  rowKV(
                    'Thành tiền',
                    _money(plan.amount, plan.currency),
                    vColor: Colors.red,
                    vWeight: FontWeight.w800,
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Phương thức thanh toán',
                    style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),

                  _methodTile(
                    context,
                    title: 'Thanh toán bằng PayPal',
                    iconPath: '$_imgPath/paypal.png',
                    selected: state.selectedMethodId == 'paypal',
                    onTap: () => notifier.selectMethod('paypal'),
                  ),
                  _methodTile(
                    context,
                    title: 'Thanh toán bằng thẻ visa',
                    iconPath: '$_imgPath/visa.png',
                    selected: state.selectedMethodId == 'visa',
                    onTap: () => notifier.selectMethod('visa'),
                  ),
                  _methodTile(
                    context,
                    title: 'Thanh toán bằng momo',
                    iconPath: '$_imgPath/momo.png',
                    selected: state.selectedMethodId == 'momo',
                    onTap: () => notifier.selectMethod('momo'),
                  ),

                  if (state.selectedMethodId == 'visa') ...[
                    const SizedBox(height: 8),
                    _labeledInput(
                      context,
                      label: 'Số thẻ',
                      hint: 'Nhập số thẻ',
                      keyboard: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    _labeledInput(
                      context,
                      label: 'Tên chủ thẻ',
                      hint: 'Nhập tên chủ thẻ',
                    ),
                    const SizedBox(height: 10),
                    _labeledInput(
                      context,
                      label: 'Ngày hết hạn',
                      hint: 'MM/YY',
                      prefixIcon: Icons.calendar_month_rounded,
                    ),
                  ],

                  const SizedBox(height: 8),
                  SizedBox(
                    height: 48,
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => context.push('/payment/processing'),
                      child: const Text('Xác nhận thanh toán'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _methodTile(
    BuildContext context, {
    required String title,
    required String iconPath,
    required bool selected,
    VoidCallback? onTap,
  }) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? cs.primaryContainer.withOpacity(0.25) : cs.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? cs.primary : cs.outlineVariant,
            width: selected ? 1.2 : 1,
          ),
          boxShadow: [
            if (selected)
              BoxShadow(
                color: cs.primary.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(
                iconPath,
                width: 18,
                height: 18,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: cs.primary,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _labeledInput(
    BuildContext context, {
    required String label,
    String? hint,
    IconData? prefixIcon,
    TextInputType? keyboard,
  }) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: t.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
        const SizedBox(height: 6),
        TextField(
          keyboardType: keyboard,
          decoration: InputDecoration(
            hintText: hint,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            filled: true,
            fillColor: cs.surface,
            prefixIcon: prefixIcon == null
                ? null
                : Icon(prefixIcon, size: 18, color: cs.onSurfaceVariant),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: cs.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: cs.primary, width: 1.2),
            ),
          ),
        ),
      ],
    );
  }

  String _money(int amount, String currency) {
    // Đơn giản: VND dùng dấu chấm, còn lại hiển thị "123 USD"
    if (currency.toUpperCase() == 'VND') {
      final vnd = amount.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.',
      );
      return '$vnd đ';
    }
    return '$amount ${currency.toUpperCase()}';
  }
}
