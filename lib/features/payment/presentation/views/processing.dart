import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../viewmodels/payment_state.dart';

class ProcessScreen extends ConsumerStatefulWidget {
  const ProcessScreen({super.key});
  @override
  ConsumerState<ProcessScreen> createState() => _ProcessScreenState();
}

class _ProcessScreenState extends ConsumerState<ProcessScreen> {
  double progress = 0;

  @override
  void initState() {
    super.initState();
    _simulateProgress();
  }

  Future<void> _simulateProgress() async {
    for (int i = 0; i <= 100; i += 5) {
      await Future.delayed(const Duration(milliseconds: 120));
      if (!mounted) return;
      setState(() => progress = i / 100);
    }
    final ok = DateTime.now().millisecond % 2 == 0;
    if (mounted) context.go('/payment/result/${ok ? "success" : "failed"}');
  }

  @override
  Widget build(BuildContext context) {
    final plan = ref.watch(paymentProvider).selectedPlan;
    final t = Theme.of(context).textTheme;

    return AppScaffold(
      title: 'Thanh toán',
      showBack: false,
      showLegalFooter: true,
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Thanh toán',
                    style: t.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(value: progress),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Đang xử lý giao dịch...', style: t.bodySmall),
                  ),
                  const Divider(height: 28),
                  if (plan != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                      ),
                      child: Column(
                        children: [
                          _row(
                            'Gói đã chọn',
                            plan.shortLabel,
                            bold: true,
                            color: Colors.green,
                          ),
                          const SizedBox(height: 6),
                          _row(
                            'Giá gốc',
                            '${_vnd(plan.originalPrice)}đ',
                            color: Colors.red,
                          ),
                          _row(
                            'Ưu đãi',
                            plan.discount != null ? '-${plan.discount}%' : '0%',
                          ),
                          const Divider(height: 24),
                          _row(
                            'Thành tiền',
                            '${_vnd(plan.price)}đ',
                            bold: true,
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 6),
                  Text(
                    'Thanh toán được mã hoá và bảo mật bởi FitAIPlaning',
                    style: t.bodySmall?.copyWith(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(String k, String v, {bool bold = false, Color? color}) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(k),
      Text(
        v,
        style: TextStyle(
          fontWeight: bold ? FontWeight.w800 : null,
          color: color,
        ),
      ),
    ],
  );

  String _vnd(int n) =>
      '${n.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
}
