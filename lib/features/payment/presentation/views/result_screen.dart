import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_scaffold.dart';

class PaymentResultScreen extends StatelessWidget {
  final bool success;
  const PaymentResultScreen({super.key, required this.success});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return AppScaffold(
      appBar: const AppAppBar(title: 'Thanh toán'),
      showLegalFooter: true,
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  success ? 'Thanh toán thành công!' : 'Thanh toán thất bại',
                  style: t.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  success
                      ? 'Gói của bạn đã được kích hoạt.'
                      : 'Thẻ bị từ chối hoặc không đủ số dư.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Icon(
                  success ? Icons.emoji_emotions : Icons.sentiment_dissatisfied,
                  size: 96,
                  color: Colors.orange,
                ),
                const SizedBox(height: 20),
                if (success)
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => context.go('/home'),
                      child: const Text('Bắt đầu ngay'),
                    ),
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => context.push('/payment/processing'),
                          child: const Text('Thử lại'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FilledButton(
                          onPressed: () => context.go('/payment/checkout'),
                          child: const Text('Chọn phương thức khác'),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
