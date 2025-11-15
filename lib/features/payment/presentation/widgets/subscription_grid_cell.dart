import 'package:flutter/material.dart';
import '../../data/models/subscription_product.dart';

class SubscriptionGridCell extends StatelessWidget {
  final SubscriptionProduct product;
  final bool selected;
  final VoidCallback onSelect;
  final VoidCallback onChoose;

  const SubscriptionGridCell({
    super.key,
    required this.product,
    required this.selected,
    required this.onSelect,
    required this.onChoose,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onSelect,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? cs.primary : cs.outlineVariant,
            width: selected ? 2 : 1,
          ),
          boxShadow: const [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black12,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Tên gói
            Text(
              product.name,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            Divider(height: 10, color: cs.outline),

            // Giá + chu kỳ
            Column(
              children: [
                Text(
                  _formatPrice(product.amount, product.currency),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.orange,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '/ ${_intervalLabel(product.interval)}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Features/desc ngắn (tùy backend, demo dùng description)
            ..._perksFor(product).map(
              (f) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 16,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        f,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            FilledButton(
              onPressed: onChoose,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Chọn gói này'),
            ),
          ],
        ),
      ),
    );
  }

  static List<String> _perksFor(SubscriptionProduct p) {
    final desc = (p.description ?? '').trim();

    // Nếu có ký tự “|”, tách thành list
    if (desc.contains('|')) {
      return desc
          .split('|') // tách
          .map((e) => e.trim()) // bỏ khoảng trắng dư
          .where((e) => e.isNotEmpty) // bỏ dòng rỗng
          .toList();
    }

    // fallback: mô tả đơn dòng + thêm auto renew
    final base = <String>[
      if (desc.isNotEmpty) desc,
      'Tự động gia hạn hàng ${_intervalLabel(p.interval)}',
    ];

    return base;
  }

  static String _intervalLabel(BillingInterval i) {
    switch (i) {
      case BillingInterval.day:
        return 'ngày';
      case BillingInterval.week:
        return 'tuần';
      case BillingInterval.month:
        return 'tháng';
      case BillingInterval.year:
        return 'năm';
    }
  }

  static String _formatPrice(int amount, String currency) {
    final cur = currency.toLowerCase();
    if (cur == 'vnd' || cur == 'vnđ' || cur == 'đ') {
      final s = amount.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.',
      );
      return '$sđ';
    }
    // đơn giản cho USD/EUR...
    return '$amount ${currency.toUpperCase()}';
  }
}
