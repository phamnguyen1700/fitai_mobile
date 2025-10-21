import 'package:flutter/material.dart';

class CheckoutSummaryCard extends StatelessWidget {
  final int amount;
  final VoidCallback onConfirm;
  final bool loading;

  const CheckoutSummaryCard({
    super.key,
    required this.amount,
    required this.onConfirm,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    String _vnd(int n) =>
        '${n.toString().replaceAll(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), r'$1.')}đ';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  'Tổng thanh toán',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                Text(
                  _vnd(amount),
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: loading ? null : onConfirm,
                child: loading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Xác nhận thanh toán'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
