// lib/features/payment/presentation/views/checkout_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:fitai_mobile/features/auth/presentation/viewmodels/auth_providers.dart';
import 'package:fitai_mobile/features/payment/presentation/viewmodels/payment_controller.dart';

import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../data/models/subscription_product.dart';
import '../viewmodels/subscriptions_provider.dart';

class CheckoutScreen extends ConsumerWidget {
  static const _imgPath = 'lib/core/assets/images';

  /// Gói được chọn truyền từ BuyingScreen (có thể null).
  /// Nếu null thì sẽ fallback lấy từ subscriptionsProvider.
  final SubscriptionProduct? product;

  /// Callback back (dùng cho BuyingScreen, có thể null).
  final VoidCallback? onBack;

  const CheckoutScreen({super.key, this.product, this.onBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subState = ref.watch(subscriptionsProvider);
    final subNotifier = ref.read(subscriptionsProvider.notifier);

    // Nếu có product truyền vào thì dùng, không thì lấy từ provider
    final plan = product ?? subState.selectedProduct;

    if (plan == null) {
      return AppScaffold(
        appBar: const AppAppBar(title: 'Thanh toán'),
        body: Center(
          child: TextButton(
            onPressed: () {
              // nếu có onBack (từ BuyingScreen) thì gọi,
              // không thì pop route về /payment
              if (onBack != null) {
                onBack!();
              } else {
                Navigator.of(context).pop();
              }
            },
            child: const Text('Vui lòng chọn gói trước. Quay lại'),
          ),
        ),
      );
    }

    final t = Theme.of(context).textTheme;
    final messenger = ScaffoldMessenger.of(context);

    // State của PaymentController (AsyncValue<void>)
    final paymentState = ref.watch(paymentControllerProvider);
    final isPaying = paymentState.isLoading;

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
      // Nếu AppAppBar có hỗ trợ onBack, bạn có thể dùng:
      // appBar: AppAppBar(title: 'Thanh toán', onBack: onBack),
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

                  // ==== Tóm tắt đơn ====
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
                  rowKV('Ưu đãi', '0%'),
                  const Divider(height: 28),
                  rowKV(
                    'Thành tiền',
                    _money(plan.amount, plan.currency),
                    vColor: Colors.red,
                    vWeight: FontWeight.w800,
                  ),
                  const SizedBox(height: 16),

                  // ==== Phương thức thanh toán ====
                  Text(
                    'Phương thức thanh toán',
                    style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),

                  _methodTile(
                    context,
                    title: 'Thanh toán bằng Stripe (thẻ quốc tế)',
                    iconPath: '${CheckoutScreen._imgPath}/stripe.png',
                    selected: subState.selectedMethodId == 'stripe',
                    onTap: () => subNotifier.selectMethod('stripe'),
                  ),
                  _methodTile(
                    context,
                    title: 'Thanh toán bằng PayPal',
                    iconPath: '${CheckoutScreen._imgPath}/paypal.png',
                    selected: subState.selectedMethodId == 'paypal',
                    onTap: () => subNotifier.selectMethod('paypal'),
                  ),
                  _methodTile(
                    context,
                    title: 'Thanh toán bằng MoMo',
                    iconPath: '${CheckoutScreen._imgPath}/momo.png',
                    selected: subState.selectedMethodId == 'momo',
                    onTap: () => subNotifier.selectMethod('momo'),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    height: 48,
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: isPaying
                          ? null
                          : () async {
                              // 1. Check method
                              if (subState.selectedMethodId == null) {
                                messenger.showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Vui lòng chọn phương thức thanh toán.',
                                    ),
                                  ),
                                );
                                return;
                              }

                              if (subState.selectedMethodId != 'stripe') {
                                messenger.showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Phương thức này chưa được hỗ trợ.',
                                    ),
                                  ),
                                );
                                return;
                              }

                              // 2. Đợi authNotifierProvider load xong
                              AuthState authState;
                              try {
                                authState = await ref.read(
                                  authNotifierProvider.future,
                                );
                              } catch (e) {
                                messenger.showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Không lấy được thông tin đăng nhập. Vui lòng thử lại.',
                                    ),
                                  ),
                                );
                                return;
                              }

                              if (!authState.isAuthenticated ||
                                  authState.user == null) {
                                messenger.showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Bạn cần đăng nhập trước khi thanh toán.',
                                    ),
                                  ),
                                );
                                return;
                              }

                              final user = authState.user!;

                              try {
                                final controller = ref.read(
                                  paymentControllerProvider.notifier,
                                );

                                // DEBUG
                                // ignore: avoid_print
                                print(
                                  '[Checkout] Creating payment for plan: ${plan.name}',
                                );

                                final resp = await controller
                                    .createPaymentSession(plan);

                                if (resp == null) {
                                  messenger.showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Không tạo được phiên thanh toán. Vui lòng thử lại.',
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                // DEBUG
                                // ignore: avoid_print
                                print(
                                  '[Checkout] sessionUrl = ${resp.sessionUrl}',
                                );

                                final uri = Uri.parse(resp.sessionUrl);

                                if (!await canLaunchUrl(uri)) {
                                  messenger.showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Không mở được trang thanh toán Stripe.',
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                await launchUrl(
                                  uri,
                                  mode: LaunchMode.externalApplication,
                                );
                              } catch (e) {
                                // ignore: avoid_print
                                print('[Checkout] error: $e');
                                messenger.showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Có lỗi khi tạo phiên thanh toán. Vui lòng thử lại.',
                                    ),
                                  ),
                                );
                              }
                            },
                      child: isPaying
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Xác nhận thanh toán'),
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

  String _money(num amount, String currency) {
    final upper = currency.toUpperCase();

    if (upper == 'VND') {
      final vndInt = amount.round();
      final vnd = vndInt.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.',
      );
      return '$vnd đ';
    }

    final formatted = (amount is int)
        ? amount.toString()
        : amount.toStringAsFixed(2);

    return '$formatted $upper';
  }
}
